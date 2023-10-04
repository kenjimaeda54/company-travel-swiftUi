//
//  DetailsDestinationScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 04/10/23.
//

import SwiftUI

struct DetailsDestinationScreen: View {
  let destination: DestinationModel
  @State private var presentedSheet = true

  var body: some View {
    VStack {
      AsyncImage(url: URL(string: destination.poster)) { phase in

        if let image = phase.image {
          image
            .resizable() // para conseguir manipular precisa dessa propriedade
            .scaledToFill()

        } else {
          PlaceHolderImageDestionation()
        }
      }
      .onTapGesture {
        presentedSheet.toggle()
      }
    }
    .ignoresSafeArea(.all)
    .frame(minWidth: 0, minHeight: 0)
    .sheet(isPresented: $presentedSheet) {
      VStack(alignment: .leading) {
        HStack {
          Text(destination.title)
            .font(.custom(FontsApp.openSemiBold, size: 19))
            .foregroundColor(ColorsApp.black)
          Spacer()
          // uma maneira de fazer rico texto aqui e usando o +
          // o exemplo abaixo estarei concatenado destination.price com persom
          // flutter e compose ja possui componente propries
          Text(destination.price)
            .font(.custom(FontsApp.openMedium, size: 19))
            .foregroundColor(ColorsApp.blue) +
            Text(" /pessoa")
            .font(.custom(FontsApp.openLight, size: 19))
            .foregroundColor(ColorsApp.black)
        }
        HStack {
          Image("markMap")
            .resizable()
            .renderingMode(.template)
            .frame(width: 20, height: 20)
            .foregroundColor(ColorsApp.blue)
          Text(destination.location)
            .font(.custom(FontsApp.openLight, size: 15))
            .foregroundColor(ColorsApp.black)
        }
        HStack(alignment: .top, spacing: 0) {
          VStack(alignment: .leading) {
            Text("Descrição")
              .padding(.bottom, 10)
              .font(.custom(FontsApp.openRegular, size: 17))
              .foregroundColor(ColorsApp.black)
              .background(
                ColorsApp.blue
                  .frame(height: 2)
                  .padding(.top, 20)
              )
            Text(destination.overview)
							.fontWithLineHeight(font: UIFont(name: FontsApp.openLight, size: 16)!, lineHeight: 25)
							.foregroundColor(ColorsApp.black)
          }
          Text("Mapa")
            .font(.custom(FontsApp.openRegular, size: 17))
            .foregroundColor(ColorsApp.black)
            .offset(x: -200)
        }
        .padding(.top, 20)
        .frame(alignment: .leading)

        Spacer()
				Button(action: {}) {
					Spacer()
					Text("Comprar agora")
						.padding(.vertical,10)
						.foregroundColor(ColorsApp.white)
					Spacer()
				}
				.background(
			     RoundedRectangle(cornerRadius: 50)
						.foregroundColor(ColorsApp.blue)
				)
				
      }
      .presentationDetents([.customMedium])
      .padding(EdgeInsets(top: 15, leading: 5, bottom: 0, trailing: 5))
    }
  }
}

#Preview {
  DetailsDestinationScreen(destination: destionationMock[1])
}
