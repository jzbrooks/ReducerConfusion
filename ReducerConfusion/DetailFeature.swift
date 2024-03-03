//
//  DetailFeature.swift
//  ReducerConfusion
//
//  Created by Justin Brooks on 3/2/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct DetailFeature {
  @ObservableState
  struct State : Equatable {
    var number: Int
  }
  
  enum Action {
    case numberChanged(Int)
  }
  
  var body : some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .numberChanged(let new):
        state.number = new
        return .none
      }
    }
  }
}

struct DetailView : View {
  let store: StoreOf<DetailFeature>
  
  var body : some View {
    VStack {
      Text("Current value is \(store.number)")
      Button("Increment") { store.send(.numberChanged(store.number + 1))}
    }
  }
}
