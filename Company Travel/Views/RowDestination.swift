//
//  RowDestionation.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import CachedAsyncImage
import SwiftUI

// cheat test
// https://www.hackingwithswift.com/articles/148/xcode-ui-testing-cheat-sheet
struct RowDestination<Content: View>: View {
  var destination: DestinationModel
  var content: () -> Content

  var body: some View {
    ZStack {
      content()

      VStack {
        CachedAsyncImage(url: URL(string: destination.poster)) { phase in

          if let image = phase.image {
            image
              .resizable()
              .frame(width: 165, height: 230)
          } else {
            PlaceHolderImageDestionation()
          }

          VStack(alignment: .leading, spacing: 3) {
            Text(destination.title)
              .font(.custom(FontsApp.openRegular, size: 15))
              .foregroundColor(ColorsApp.black)
              .lineLimit(1)
              .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            HStack {
              Image("markMap")
                .resizable()
                .frame(width: 20, height: 20)
              Text(destination.location)
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
    RowDestination(destination: destionationMock[0]) {
      Image(systemName: "heart.fill")
        .font(.system(size: 25))
        .foregroundColor(ColorsApp.red)
        .background(
          Circle()
            .foregroundColor(ColorsApp.background)
            .frame(width: 60, height: 60)
        )
        .offset(x: 70, y: -140)
        .zIndex(2)
        .accessibilityLabel("This image have touch")
    }
    .previewLayout(.sizeThatFits)
  }
}
