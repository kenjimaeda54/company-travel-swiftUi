//
//  PlaceHolders.swift
//  Company Travel
//
//  Created by kenjimaeda on 13/09/23.
//

import SwiftUI

struct PlaceHolderImageDestionation: View {
  var body: some View {
    Image("placeHolderCity")
      .resizable()
      .frame(width: 165, height: 230)
      .redactShimmer(condition: true)
  }
}

struct PlaceHolderScreen: View {
  var body: some View {
    Image("placeHolderCity")
      .resizable()
      .ignoresSafeArea()
      .redactShimmer(condition: true)
  }
}

#Preview {
  PlaceHolderScreen()
}
