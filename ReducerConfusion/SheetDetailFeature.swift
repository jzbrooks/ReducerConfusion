//
//  DetailFeature.swift
//  ReducerConfusion
//
//  Created by Justin Brooks on 3/2/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SheetDetailFeature {
  @ObservableState
  struct State : Equatable {
    let firstInitial: String
    var surname: String = ""
  }
  
  enum Action {
    case surnameChanged(String)
  }
  
  var body : some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .surnameChanged(let new):
        state.surname = new
        return .none
      }
    }
  }
}

struct SheetDetailView : View {
  @Bindable var store: StoreOf<SheetDetailFeature>
  
  var body : some View {
    VStack {
      Text("Please enter your last name")
      TextField("\(store.firstInitial)", text: $store.surname.sending(\.surnameChanged))
    }
  }
}
