//
//  ContentView.swift
//  ReducerConfusion
//
//  Created by Justin Brooks on 2/29/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct TopLevelFeature {
  @Reducer(state: .equatable)
  enum Destination {
    case sheet(FirstInitialPickerFeature)
  }
  
  @Reducer
  struct Path {
    @ObservableState
    enum State: Equatable {
      case detail(DetailFeature.State)
    }

    enum Action {
      case detail(DetailFeature.Action)
    }

    var body: some ReducerOf<Self> {
      Scope(state: \.detail, action: \.detail) {
        DetailFeature()
      }
    }
  }
  
  @ObservableState
  struct State : Equatable {
    @Presents var destination: Destination.State?

    var path = StackState<Path.State>()
  }
  
  enum Action {
    case addClicked
    case destination(PresentationAction<Destination.Action>)
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addClicked:
        state.destination = .sheet(FirstInitialPickerFeature.State())
        return .none
      case .destination:
        return .none
      case .path:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .forEach(\.path, action: \.path) {
      TopLevelFeature.Path()
    }
  }
}

struct ContentView: View {
  @Bindable var store: StoreOf<TopLevelFeature>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        ForEach(0..<100) { number in
          NavigationLink(state: TopLevelFeature.Path.State.detail(DetailFeature.State(number: number))) {
            Text("\(number)")
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { store.send(.addClicked) }) {
            Label("add", systemImage: "plus")
              .labelStyle(.iconOnly)
          }
        }
      }
      .sheet(item: $store.scope(state: \.destination?.sheet, action: \.destination.sheet))
      { store in
        FirstInitialPickerView(store: store)
      }
    } destination: { store in
      switch store.state {
      case .detail:
        if let store = store.scope(state: \.detail, action: \.detail) {
          DetailView(store: store)
        }
      }
    }
  }
}
