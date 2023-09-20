//
//  ButtomCommon.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import SwiftUI

struct ButtonCommon: View {
  let action: () -> Void
  let title: String
  let isLoading: Bool

  // para colocar default parametro preciso do init
  init(action: @escaping () -> Void, title: String, isLoading: Bool = false) {
    self.action = action
    self.title = title
    self.isLoading = isLoading
  }

  var body: some View {
    Button(action: action) {
      if isLoading {
        // https://sarunw.com/posts/swiftui-progressview/#:~:text=You%20can%20change%20the%20color,modifier.

        ProgressView()
          .tint(ColorsApp.white) // tint altera cor do progress

      } else {
        Text(title)
          .font(.custom(FontsApp.openRegular, size: 17))
          .foregroundColor(ColorsApp.white)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(ColorsApp.blue)
    )
  }
}

struct ButtomCommon_Previews: PreviewProvider {
  static var previews: some View {
    ButtonCommon(action: {}, title: "Prosseguir")
  }
}
