//
//  PointsOfInterest.swift
//  Company Travel
//
//  Created by kenjimaeda on 04/10/23.
//

import MapKit
import SwiftUI

struct PointsOfInterest: View {
  @State private var showAlert = false
  var geocode: PointsGeoCode
  @StateObject private var storePointsIntereset = StorePoints(httpCLient: HttpClientFactory.create())
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack {
      if #available(iOS 17.0, *) {
        Map {}
      } else {
        Text("Não esta disponível para sua versão")
          .alert("Precisa atualizar para versão 17", isPresented: $showAlert) {
            Text("Voltar")
              .onTapGesture {
                dismiss()
              }
          }
      }
    }
    .onAppear {
      if #available(iOS 17.0, *) {
        showAlert = false
      } else {
        showAlert = true
      }
    }
  }
}

#Preview {
  PointsOfInterest(geocode: PointsGeoCode(latitude: "9", longitude: "0"))
}
