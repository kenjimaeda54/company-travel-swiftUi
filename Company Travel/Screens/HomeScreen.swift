//
//  ContentView.swift
//  Company Travel
//
//  Created by kenjimaeda on 10/09/23.
//

import FirebaseFirestore
import SwiftUI

struct HomeScreen: View {
  @StateObject var storeHome = StoreHome(httpClient: HttpClientFactory.create())
  @State private var isFavorite = false

  var body: some View {
    ScrollView(showsIndicators: false) {
      Group {
        HStack {
          VStack(alignment: .leading) {
            Text("Hi Bella,")
              .font(.custom(FontsApp.openLight, size: 17))
              .foregroundColor(ColorsApp.gray)
            Text("Viajando hoje?")
              .font(.custom(FontsApp.openBold, size: 23))
              .foregroundColor(ColorsApp.black)
          }
          Spacer()
          AsyncImage(url: URL(string: "https://github.com/kenjimaeda54.png")) { phase in
            if let image = phase.image {
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
          }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        Text("Destinos")
          .font(.custom(FontsApp.openRegular, size: 20))
          .foregroundColor(ColorsApp.black)
          .frame(maxWidth: .infinity, alignment: .leading)

        if storeHome.stateLoading == .sucess {
          LazyVGrid(columns: gridItemDestionation, spacing: 30) {
            ForEach(storeHome.destinations, id: \.location) { destination in
              RowDestionation(destionation: destination, isFavorite: $isFavorite)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
          }
        }
      }
      .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
    .onAppear {
      storeHome.getDestionations()
    }
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen()
  }
}
