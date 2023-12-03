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
        
        await store.send(.incrementButtonTapped) {
          $0.count = 1 //we are asserting here
        }

      }

}
