//
//  RowDestionation.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import SwiftUI

struct RowDestionation: View {
  var destionation: DestinationModel
  var body: some View {
    VStack {
      AsyncImage(url: URL(string: destionation.poster), scale: 20) { phase in

        if let image = phase.image {
          image
            .resizable()
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .frame(width: 170, height: 230)
        }
        VStack {
          Text(destionation.title)
            .foregroundColor(ColorsApp.black)
          Text(destionation.location)
            .foregroundColor(ColorsApp.black)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
      }
    }
    .background(ColorsApp.white)
    .cornerRadius(20)
  }
}

struct RowDestionation_Previews: PreviewProvider {
  static var previews: some View {
    RowDestionation(destionation: destionationMock[0])
      .previewLayout(.sizeThatFits)
  }
}
