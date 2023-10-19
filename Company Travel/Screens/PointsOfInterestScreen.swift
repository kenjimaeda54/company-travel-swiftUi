//
//  PointsOfInterest.swift
//  Company Travel
//
//  Created by kenjimaeda on 04/10/23.
//

import MapKit
import SwiftUI

// https://www.appcoda.com/swiftui-maps/
struct PointsOfInterestScreen: View {
  @State private var showAlert = false
  var destination: DestinationModel
  @StateObject private var storePointsIntereset = StorePoints(httpCLient: HttpClientFactory.create())
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        switch storePointsIntereset.isLoading {
        case .loading:
          Text("IsLoading")
            .font(.custom(FontsApp.openMedium, size: 25))
            .foregroundColor(ColorsApp.blue)

        case .failure:
          Text("Error")
            .font(.custom(FontsApp.openMedium, size: 25))
            .foregroundColor(ColorsApp.blue)

        default:
          if #available(iOS 17.0, *) {
            Map(initialPosition: .region(MKCoordinateRegion(
              center: CLLocationCoordinate2D(
                latitude: destination.pointsActivies[0],
                longitude: destination.pointsActivies[1]
              ),
              span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
            ))) {
              ForEach(storePointsIntereset.pointsInterest!.data, id: \.id) { it in
                Annotation(
                  "",
                  coordinate: CLLocationCoordinate2D(
                    latitude: Double(it.geoCode.latitude),
                    longitude: Double(it.geoCode.longitude)
                  )
                ) {
                  Image("annotation")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 35, height: 35)

                    .foregroundColor(ColorsApp.orange)
                }
              }
            }
            .mapControlVisibility(.hidden)

          } else {
            Text("Não esta disponível para sua versão")
              .font(.custom(FontsApp.openMedium, size: 25))
              .foregroundColor(ColorsApp.blue)
              .alert("Precisa atualizar para versão 17", isPresented: $showAlert) {
                Text("Voltar")
                  .onTapGesture {
                    dismiss()
                  }
              }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(ColorsApp.background)
    .onAppear {
      if #available(iOS 17.0, *) {
        showAlert = false
        storePointsIntereset.getAllPointsInreset(geoCode: PointsGeoCode(
          latitude: destination.pointsActivies[0],
          longitude: destination.pointsActivies[1]
        ))
      } else {
        showAlert = true
      }
    }
  }
}

#Preview {
  PointsOfInterestScreen(destination: destionationMock[0])
}
