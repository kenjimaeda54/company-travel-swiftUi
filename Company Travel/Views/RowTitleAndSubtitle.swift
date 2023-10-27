//
//  RowTitleAndSubtitle.swift
//  Company Travel
//
//  Created by kenjimaeda on 27/10/23.
//

import SwiftUI

struct RowTitleAndSubtitle: View {
  var title: String
  var subTitle: String
  @Binding var valueSubTitle: String
  var body: some View {
    HStack {
      Text(title)
        .font(.custom(FontsApp.openLight, size: 17))
        .foregroundColor(ColorsApp.black)
        .padding(.trailing, 20)
        .frame(width: 80)
      TextField(text: $valueSubTitle) {
        Text(subTitle)
          .font(.custom(FontsApp.openBold, size: 17))
          .foregroundColor(ColorsApp.gray)
          .multilineTextAlignment(.leading)
          .padding(.horizontal, 0)
      }
    }
  }
}

#Preview {
  RowTitleAndSubtitle(title: "Nome", subTitle: "Juninho", valueSubTitle: .constant(""))
}
