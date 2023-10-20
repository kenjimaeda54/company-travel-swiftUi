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
  @State private var isPresented = false
	@State private var selectedAnnotation: PointsData

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
            GeometryReader { geometry in

              ZStack {
                Map(initialPosition: .region(MKCoordinateRegion(
                  center: CLLocationCoordinate2D(
                    latitude: destination.pointsActivies[0],
                    longitude: destination.pointsActivies[1]
                  ),
                  span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
                ))) {
                  ForEach(storePointsIntereset.pointsInterest!.data, id: \.id) { it in
                    Annotation("", coordinate: CLLocationCoordinate2D(
                      latitude: Double(it.geoCode.latitude),
                      longitude: Double(it.geoCode.longitude)
                    )) {
                      VStack(spacing: 3) {
                        Image("annotation")
                          .resizable()
                          .renderingMode(.template)
                          .frame(width: 35, height: 35)
                          .foregroundColor(ColorsApp.orange)
                        Text(it.name)
                          .font(.custom(FontsApp.openRegular, size: 12))
                          .foregroundColor(ColorsApp.white)
                          .padding(.vertical, 5)
                          .padding(.horizontal, 7)
                          .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 7)
                          )
                      }
											.onTapGesture {
												isPresented.toggle()
												selectedAnnotation = it
											}
                    }
                  }
                }
                .mapControlVisibility(.hidden)
                .mapStyle(.hybrid(elevation: .realistic))
                ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "chevron.left", action: {})
                  .frame(width: 15, height: 10)
                  .padding(.all, 7)
                  .background(
                    .ultraThinMaterial,
                    in: Circle()
                  )
                  .position(x: 20, y: geometry.safeAreaInsets.top)
              }
            }
						.sheet(isPresented: $isPresented) {
							VStack(spacing: 3) {
								Text(selectedAnnotation.name)
								
								
							}
							
							
						}

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
