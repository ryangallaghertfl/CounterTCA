//
//  ContentView.swift
//  CounterTCA
//
//  Created by Ryan Gallagher on 01/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State {
        var count = 0
        var fact: String?
        var isTimerOn = false
    }
    
    enum Action {
        case decrementButtonTapped
        case getFactButtonTapped
        case incrementButtonTapped
        case toggleTimerButtonTapped
    }
    
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .decrementButtonTapped:
          state.count -= 1
          return .none

        case .getFactButtonTapped:
          // TODO: Perform network request
          return .none

        case .incrementButtonTapped:
          state.count += 1
          return .none

        case .toggleTimerButtonTapped:
          state.isTimerOn.toggle()
          // TODO: Start a timer
          return .none
        }
      }
    }
}

struct ContentView: View {
  let store: StoreOf<CounterFeature>

  var body: some View {
    Form {
      Section {
        Text("\(self.store.count)")
        Button("Decrement") {
          self.store.send(.decrementButtonTapped)
        }
        Button("Increment") {
          self.store.send(.incrementButtonTapped)
        }
      }

      Section {
        Button("Get fact") {
          self.store.send(.getFactButtonTapped)
        }
        if let fact = self.store.fact {
          Text(fact)
        }
      }

      Section {
        if self.store.isTimerOn {
          Button("Stop timer") {
            self.store.send(.toggleTimerButtonTapped)
          }
        } else {
          Button("Start timer") {
            self.store.send(.toggleTimerButtonTapped)
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
    }
  )
}
