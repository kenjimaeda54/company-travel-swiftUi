//
//  RowDestionation.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import SwiftUI

struct RowDestionation: View {
  var destionation: DestinationModel
  @Binding var isFavorite: Bool

  var body: some View {
    ZStack {
      Image(systemName: "heart.fill")
        .font(.system(size: 25))
        .foregroundColor(isFavorite ? ColorsApp.red : ColorsApp.gray)
        .background(
          Circle()
            .foregroundColor(ColorsApp.background)
            .frame(width: 60, height: 60)
        )
        .offset(x: 70, y: -140)
        .zIndex(2)
        .gesture(
          TapGesture()
            .onEnded { _ in
              isFavorite.toggle()
            }
        )

      VStack {
        AsyncImage(url: URL(string: destionation.poster), scale: 20) { phase in

          if let image = phase.image {
            image
              .resizable()
              .frame(width: 165, height: 230)
          } else {
            PlaceHolderImageDestionation()
          }

          VStack(alignment: .leading, spacing: 3) {
            Text(destionation.title)
              .font(.custom(FontsApp.openRegular, size: 15))
              .foregroundColor(ColorsApp.black)
              .lineLimit(1)
              .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            HStack {
              Image("markMap")
                .resizable()
                .frame(width: 20, height: 20)
              Text(destionation.location)
                .font(.custom(FontsApp.openLight, size: 13))
                .foregroundColor(ColorsApp.black)
                .lineLimit(1)
            }
            .padding(EdgeInsets(top: 3, leading: 10, bottom: 5, trailing: 10))
            .frame(width: 165, alignment: .leading)
          }

          .frame(width: 165, alignment: .top)
        }
      }
      .background(ColorsApp.white)
      .cornerRadius(5)
    }
  }
}

struct RowDestionation_Previews: PreviewProvider {
  static var previews: some View {
    RowDestionation(destionation: destionationMock[0], isFavorite: .constant(false))
      .previewLayout(.sizeThatFits)
  }
}
