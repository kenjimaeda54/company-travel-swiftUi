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

  var body: some View {
    ScrollView(showsIndicators: false) {
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
			.padding(EdgeInsets.init(top: 0, leading: 0, bottom: 20, trailing: 0))
      Text("Destinos")
        .font(.custom(FontsApp.openRegular, size: 20))
        .foregroundColor(ColorsApp.black)
				.frame(maxWidth: .infinity,alignment: .leading)

      if storeHome.stateLoading == .sucess {
        LazyVGrid(columns: gridItemDestionation) {
          ForEach(storeHome.destinations, id: \.location) { destination in
            RowDestionation(destionation: destination)
          }
        }
      }
    }
    .padding(EdgeInsets(top: 10, leading: 17, bottom: 0, trailing: 17))
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(ColorsApp.background)
    .onAppear {
      storeHome.getDestionations()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen()
  }
}
