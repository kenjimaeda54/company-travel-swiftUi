//
//  ProfileScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 12/09/23.
//

import SwiftUI

struct ProfileScreen: View {
  var body: some View {
    VStack {
      Text("ProfilleScreen")
    }
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ProfileScreen_Previews: PreviewProvider {
  static var previews: some View {
    ProfileScreen()
  }
}
