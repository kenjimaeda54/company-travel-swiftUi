//
//  ContentView.swift
//  Company Travel
//
//  Created by kenjimaeda on 10/09/23.
//

import FirebaseFirestore
import SwiftUI

struct HomeScreen: View {
  var body: some View {
    VStack {
      Text("Ola test")
        .font(.custom(FontsApp.openBold, size: 22))
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen()
  }
}
