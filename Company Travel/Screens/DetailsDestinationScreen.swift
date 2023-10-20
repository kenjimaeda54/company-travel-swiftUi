//
//  DetailsDestinationScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 04/10/23.
//

import MapKit
import SwiftUI

enum TabSelected {
  case overview
  case points
}

struct DetailsDestinationScreen: View {
  let destination: DestinationModel
  @State private var showAlert = false
  @State private var isPresented = true
  @State private var interactive = false
  @Environment(\.dismiss) var dismiss
  @Environment(\.isPresented) var presentation
  @State private var isNavigate = false
  @State private var tabSelected: TabSelected = .overview
  @StateObject private var storePointsIntereset = StorePoints(httpCLient: HttpClientFactory.create())

  func handleBack() {
    dismiss()
  }

  var body: some View {
    GeometryReader { metrics in
      NavigationStack {
        if tabSelected == TabSelected.points {
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
                      }
                    }
                  }
                  .mapControlVisibility(.hidden)
                  .mapStyle(.hybrid(elevation: .realistic))
                  ButtonCommonWithIcon(
                    foregroundColor: ColorsApp.white,
                    iconSytem: "chevron.left",
                    action: { handleBack() }
                  )
                  .frame(width: 15, height: 10)
                  .padding(.all, 7)
                  .background(
                    .ultraThinMaterial,
                    in: Circle()
                  )
                  .position(x: 25, y: metrics.size.height * 0.08)
                  ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "heart", action: {})
                    .frame(width: 15, height: 10)
                    .padding(.all, 7)
                    .background(
                      .ultraThinMaterial,
                      in: Circle()
                    )
                    .position(x: metrics.size.width - 25, y: metrics.size.height * 0.08)
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

              } else {
                Text("Não esta disponível para sua versão")
                  .font(.custom(FontsApp.openMedium, size: 25))
                  .foregroundColor(ColorsApp.blue)
                  .alert("Precisa atualizar para versão 17", isPresented: $showAlert) {
                    Text("Voltar")
                      .onTapGesture {
                        tabSelected = TabSelected.overview
                      }
                  }
              }
            }
          }

        } else {
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

          HStack(alignment: .top, spacing: 15) {
            TextOverviewOrPoints(isShowWithDecoration: tabSelected == TabSelected.overview, text: "Descrição")
              .onTapGesture {
                tabSelected = TabSelected.overview
              }

            TextOverviewOrPoints(isShowWithDecoration: tabSelected == TabSelected.points, text: "Pontos de interesse")
              .onTapGesture {
                tabSelected = TabSelected.points
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
          .padding(.top, 5)
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          Text(destination.overview)
            .fontWithLineHeight(font: UIFont(name: FontsApp.openLight, size: 16)!, lineHeight: 25)
            .foregroundColor(ColorsApp.black)

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
    .safeAreaInset(edge: .top, alignment: .leading) {
      if tabSelected == TabSelected.overview {
        HeaderStack(actionFavorite: {})
      }
    }
  }
}

#Preview {
  DetailsDestinationScreen(destination: destionationMock[1])
}

struct TextOverviewOrPoints: View {
  var isShowWithDecoration: Bool

  var text: String
  var body: some View {
    if isShowWithDecoration {
      Text(text)
        .padding(.bottom, 10)
        .font(.custom(FontsApp.openRegular, size: 17))
        .foregroundColor(ColorsApp.black)
        .background(
          ColorsApp.blue
            .frame(height: 2)
            .padding(.top, 20)
        )
    } else {
      Text(text)
        .padding(.bottom, 10)
        .font(.custom(FontsApp.openRegular, size: 17))
        .foregroundColor(ColorsApp.black)
    }
  }
}
