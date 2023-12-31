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
        
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
          CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
          }

        await store.send(.toggleTimerButtonTapped) {
          $0.isTimerOn = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
          $0.count = 1
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
          $0.count = 2
        }
        await store.send(.toggleTimerButtonTapped) {
          $0.isTimerOn = false
        }
      }
    
    func testGetFact() async {
       let store = TestStore(initialState: CounterFeature.State()) {
         CounterFeature()
       } withDependencies: {
             $0.numberFact.fetch = { "\($0) is a great number!" }
           }
       await store.send(.getFactButtonTapped) {
         $0.isLoadingFact = true
       }
       await store.receive(.factResponse("0 is a great number!")) {
         $0.fact = "0 is a great number!"
         $0.isLoadingFact = false
       }
     }
    
    func testGetFact_Failure() async {
        let store = TestStore(initialState: CounterFeature.State()) {
          CounterFeature()
        } withDependencies: {
          $0.numberFact.fetch = { _ in
            struct SomeError: Error {}
            throw SomeError()
          }
        }
        XCTExpectFailure()
        await store.send(.getFactButtonTapped) {
          $0.isLoadingFact = true
        }
      }
    
}
