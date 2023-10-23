//
//  BuyTravelScreeen.swift
//  Company Travel
//
//  Created by kenjimaeda on 22/10/23.
//

import SwiftUI

struct BuyTravelScreeen: View {
  var destination: String
  @State private var isNavigate = false
  @StateObject private var enviromentUser = EnvironmentUser()
  @StateObject var store = StoreUsers(httpClient: HttpClientFactory.create()) // store e stateobject

  var body: some View {
    NavigationStack {
      VStack {
        Group {
          Text(
            "Muito obrigado por comprar a viagem para destino"
          )
          .font(.custom(
            FontsApp.openRegular,
            size: 17
          )) // nao aceita padding e nem o fontWeigth modifier porque sao views
          .foregroundColor(ColorsApp.gray) +
          Text(" \(destination),")
          .font(.custom(FontsApp.openBold, size: 17))
          .foregroundColor(ColorsApp.orange) +

          Text(" você recebera por e-mail detalhes sobre pagamento, é da viagem.")
          .font(.custom(FontsApp.openRegular, size: 17))
          .foregroundColor(ColorsApp.gray)
        }
        .padding(.horizontal, 20)
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .background(ColorsApp.background)
      .safeAreaInset(edge: .bottom, content: {
        ButtonCommon(action: { isNavigate.toggle() }, title: "Voltar usar App")
          .padding(.horizontal, 20)
          .padding(.vertical, 30)
      })
      .navigationDestination(isPresented: $isNavigate) {
        RootView(user: store.user)
          .navigationBarBackButtonHidden(true)
      }
      .onAppear {
        store.getUserLoged()
      }
    }
  }
}
