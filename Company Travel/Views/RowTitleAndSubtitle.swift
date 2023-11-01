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
  var spaceAvaibleText: CGFloat?

  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.custom(FontsApp.openLight, size: 17))
        .foregroundColor(ColorsApp.black)
        .padding(.trailing, 20)
        .frame(width: 100, alignment: .leading)

      VStack {
        TextField(
          text: $valueSubTitle, axis: .vertical)
        {
          Text(subTitle)
            .font(.custom(FontsApp.openBold, size: 17))
            .foregroundColor(ColorsApp.gray)
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
      }
      .frame(width: spaceAvaibleText)
      .accessibilityIdentifier(subTitle)
    }
  }
}

#Preview {
  RowTitleAndSubtitle(title: "Nome", subTitle: "Juninho", valueSubTitle: .constant(""))
}
