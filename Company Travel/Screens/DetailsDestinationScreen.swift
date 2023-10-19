//
//  DetailsDestinationScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 04/10/23.
//

import SwiftUI

struct DetailsDestinationScreen: View {
  let destination: DestinationModel
  @State private var isPresented = true
  @State private var interactive = false
  @Environment(\.dismiss) var dismiss
  @Environment(\.isPresented) var presentation
  @State private var isNavigate = false

  func handleBack() {
    dismiss()
  }

  var body: some View {
    GeometryReader { metrics in
      NavigationStack {
        ZStack {
          AsyncImage(url: URL(string: destination.poster)) { phase in

            if let image = phase.image {
              image
                .resizable() // para conseguir manipular precisa dessa propriedade
                .scaledToFill()

            } else {
              PlaceHolderImageDestionation()
            }
          }
          .accessibilityIdentifier(destination.poster)
          Button(action: { isPresented.toggle() }) {
            Text("Abrir detalhes")
              .font(.custom(FontsApp.openLight, size: 19))
              .foregroundColor(ColorsApp.white)
              .padding(.all, 8)
          }
          .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 5)
          )
          .position(x: metrics.size.width / 2, y: metrics.size.height - 100)
        }
      }
    }
    .ignoresSafeArea(.all)
    .frame(minWidth: 0, minHeight: 0)
    .sheet(isPresented: $isPresented) {
      VStack(spacing: 0) {
        ScrollView(showsIndicators: false) {
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
          .frame(maxWidth: .infinity, alignment: .leading)
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
              .onTapGesture {
                isNavigate.toggle()
                isPresented.toggle()
              }
          }
          .padding(.top, 5)
          .frame(alignment: .leading)

          Spacer()
        }

        Button(action: {}) {
          Spacer()
          Text("Comprar agora")
            .padding(.vertical, 10)
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
      /* .interactiveDismissDisabled(!interactive)*/ // para remover swipe e close sheet, porem nenhum evento ira funfa
    }
    .navigationDestination(isPresented: $isNavigate) {
      PointsOfInterestScreen(destination: destination)
        .navigationBarBackButtonHidden(true)
    }
    .safeAreaInset(edge: .top, alignment: .leading) {
      HStack {
        ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "chevron.left", action: handleBack)
          .frame(width: 15, height: 10)
          .padding(.all, 7)
          .background(
            .ultraThinMaterial,
            in: Circle()
          )
          .offset(x: 20)
        Spacer()
        ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "heart", action: {})
          .frame(width: 15, height: 10)
          .padding(.all, 7)
          .background(
            .ultraThinMaterial,
            in: Circle()
          )
          .offset(x: -20)
      }
    }
  }
}

#Preview {
  DetailsDestinationScreen(destination: destionationMock[1])
}
