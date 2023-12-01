//
//  CounterTCAApp.swift
//  CounterTCA
//
//  Created by Ryan Gallagher on 01/12/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: CounterFeature.State()
        ) {
          CounterFeature()
        }
      )
    }
  }
}
