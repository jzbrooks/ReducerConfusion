//
//  ContentView.swift
//  ReducerConfusion
//
//  Created by Justin Brooks on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct FirstInitialPickerFeature {

  @Reducer
  struct Path {
    @ObservableState
    enum State: Equatable {
      case detail(SheetDetailFeature.State)
    }

    enum Action {
      case detail(SheetDetailFeature.Action)
    }

    var body: some ReducerOf<Self> {
      Scope(state: \.detail, action: \.detail) {
        SheetDetailFeature()
      }
    }
  }
  
  @ObservableState
  struct State : Equatable {
    var path = StackState<Path.State>()
  }
  
  enum Action {
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      FirstInitialPickerFeature.Path()
    }
  }
}

struct FirstInitialPickerView: View {
  @Bindable var store: StoreOf<FirstInitialPickerFeature>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        ForEach(65..<91) { ascii in
          let char = String(Character(UnicodeScalar(ascii)!))
          NavigationLink(state: FirstInitialPickerFeature.Path.State.detail(SheetDetailFeature.State(firstInitial: char))) {
            Text(char)
          }
        }
      }
    } destination: { store in
      switch store.state {
      case .detail:
        if let store = store.scope(state: \.detail, action: \.detail) {
          SheetDetailView(store: store)
        }
      }
    }
  }
}
