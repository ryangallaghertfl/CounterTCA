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
          //code
        case .getFactButtonTapped:
          //code
        case .incrementButtonTapped:
          //code
        case .toggleTimerButtonTapped:
          //code
        }
      }
    }
}

struct ContentView: View {
    var fact: Bool?
    var isTimerOn = false
  var body: some View {
    Form {
      Section {
        Text("0")
        Button("Decrement") {
          //Do something
        }
        Button("Increment") {
          //Do something
        }
      }
        Section {
          Button("Get fact") {}
          if let fact {
            Text("Some fact")
          }
        }
        
        Section {
            if isTimerOn {
                Button("Stop timer") {
                    //Do something
                }
            } else {
                Button("Start timer") {
                    //Do something
                }
            }
        }
    }
  }
}

#Preview {
    ContentView()
}
