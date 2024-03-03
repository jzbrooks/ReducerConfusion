//
//  ReducerConfusionApp.swift
//  ReducerConfusion
//
//  Created by Justin Brooks on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct ReducerConfusionApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: .init()) {
          TopLevelFeature()
        })
    }
  }
}
