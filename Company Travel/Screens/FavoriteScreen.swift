//
//  FavoriteScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 12/09/23.
//

import SwiftUI

struct FavoriteScreen: View {
  var body: some View {
    VStack {
      Text("Favorite Screen")
    }
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct FavoriteScreen_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteScreen()
  }
}
