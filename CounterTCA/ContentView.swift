//
//  ContentView.swift
//  CounterTCA
//
//  Created by Ryan Gallagher on 01/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct NumberFactClient {
  var fetch: @Sendable (Int) async throws -> String
}

//numberfact client needs to conform to dependencykey, which registers the numberfact client with the dependency management system

//MARK: conforming for dependency registration
//livevalue is required for live situations
extension NumberFactClient: DependencyKey {
  static let liveValue = Self { number in
    let (data, _) = try await URLSession.shared.data(
      from: URL(string: "http://www.numbersapi.com/\(number)")!
    )
    return String(decoding: data, as: UTF8.self)
  }
}

//MARK: gives us access to the keypath in the dependency property wrapper to finish registration with the property library
extension DependencyValues {
  var numberFact: NumberFactClient {
    get { self[NumberFactClient.self] }
    set { self[NumberFactClient.self] = newValue }
  }
}

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoadingFact = false
        var isTimerOn = false
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case factResponse(String)
        case getFactButtonTapped
        case incrementButtonTapped
        case timerTicked
        case toggleTimerButtonTapped
    }
    
    private enum CancelID {
        case timer
      }
    
    @Dependency(\.continuousClock) var clock
    
    @Dependency(\.numberFact) var numberFact
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoadingFact = false
                return .none
                
            case .getFactButtonTapped:
              state.fact = nil
              state.isLoadingFact = true
              return .run { [count = state.count] send in
                try await send(.factResponse(self.numberFact.fetch(count)))
              }
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .timerTicked:
                state.count += 1
                return .none
                
            case .toggleTimerButtonTapped:
                    state.isTimerOn.toggle()
                    if state.isTimerOn {
                      return .run { send in
                          for await _ in self.clock.timer(interval: .seconds(1)) {
                                        await send(.timerTicked)
                        }
                      }
                      .cancellable(id: CancelID.timer)
                    } else {
                        return .cancel(id: CancelID.timer)
                    }
                    
                  }
                }
              }
            }

struct ContentView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                }
                Section {
                          Button {
                            viewStore.send(.getFactButtonTapped)
                          } label: {
                            HStack {
                              Text("Get fact")
                              if viewStore.isLoadingFact {
                                Spacer()
                                ProgressView()
                              }
                            }
                          }
                          if let fact = viewStore.fact {
                            Text(fact)
                          }
                        }
                
                Section {
                    if viewStore.isTimerOn {
                        Button("Stop timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    } else {
                        Button("Start timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
  ContentView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
            ._printChanges()
    }
  )
}

