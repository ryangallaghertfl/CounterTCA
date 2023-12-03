//
//  CounterTCATests.swift
//  CounterTCATests
//
//  Created by Ryan Gallagher on 01/12/2023.
//
import ComposableArchitecture
import XCTest
@testable import CounterTCA


@MainActor
final class CounterTCATests: XCTestCase {
    
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        //as we are using value types we can compare state changes before and after state is copied
        await store.send(.incrementButtonTapped) {
            $0.count = 1 //we are asserting here
        }
        
    }
    
    func testTimer() async throws {

        let store = TestStore(initialState: CounterFeature.State()) {
          CounterFeature()
        }

        await store.send(.toggleTimerButtonTapped) {
          $0.isTimerOn = true
        }
        try await Task.sleep(for: .milliseconds(1_100))
        await store.receive(.timerTicked) {
          $0.count = 1
        }
        try await Task.sleep(for: .milliseconds(1_100))
        await store.receive(.timerTicked) {
          $0.count = 2
        }
        await store.send(.toggleTimerButtonTapped) {
          $0.isTimerOn = false
        }
      }
    
}
