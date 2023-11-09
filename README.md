# Travel
Marktplace de viagem, usuário pode visualizar descrição, pontos de interesses da viagem, preço por pessoa, inclusive comprar e retirar nas lojas credenciadas, outra finalidade é possibilidade usuário de editar seu perfil

## Motivação
- Uma maneira de testar a tela com usuário no envirometObject é realizar as etapas navegando ate a tela de destino
- No setUpWithError estou sempre navegando até tela home assim não me preocupo com os dados do usuário, pois  persisto via enviromentObject



```swift

  //HomeScreen
 override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()

    let buttonRegister = app.buttons["Entrar"]

    let textFieldEmail = app.textViews["Insira seu email"]
    let textFieldPassword = app.secureTextFields["Insira uma senha"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")
    buttonRegister.tap()
  }


```



##
- Nao e possivel editar os json que estao no bundle do projeto, entao uma alternativa foi salvar no sandbox do celular
- Cada  novo emulador preciso criar os arquivos no sandBox


```swift

 //para carregar
 func loadFileManager<T: Decodable>(filename: String, type: T.Type) -> T {
    var documentDirectory: URL?

    do {
      let url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      documentDirectory = url.appendingPathComponent(filename)
      print(url) //printo o caminho do sandBox que foi salvo
    } catch {
      print(error.localizedDescription)
    }

    do {
      let data = try Data(contentsOf: (documentDirectory ?? URL(string: ""))!)
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print(error.localizedDescription)
      fatalError("Failed decode json")
    }
  }

  // para salvar
 func writeFileManager(filename: String, model: Encodable) {
    var documentDirectory: URL?
    do {
      let url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      documentDirectory = url.appendingPathComponent(filename)
    } catch {
      print(error.localizedDescription)
    }

    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(model)
      try jsonData.write(to: documentDirectory!)
    } catch {
      fatalError("Can't save")
    }
  }

// para utilizar
func getUserLoged(completion: @escaping (UserModel?) -> Void) {
    let users = loadFileManager(filename: "User.json", type: [UserModel].self)
    let findUser = users.first { $0.uid == "3434342JAJApEDRO" }
    completion(findUser)
  }

  photoUserRef.downloadURL { url, _ in
            if let url = url {
              var usersJson = self.loadFileManager(filename: "User.json", type: [UserModel].self)
              let userModel = UserModel(uid: userId, displayName: name, photoUrl: url, email: email)
              usersJson.append(userModel)
              self.writeFileManager(filename: "User.json", model: usersJson)

              return completion(.success(userModel))
            }

            return completion(.failure(.badURL))
          }

```
##
- Para pegar image da camera, pode criar uma view usando UIViewControllerRepresentable
- Criei um modificador para saber se existe uma imagem valida selecionado, seja pela galeria ou após usar a câmera
- Emuladores de IOS não possui câmera, então precisa usar uma função específica do Swift para determinar se esta em um emulador ou dispositivo fisico

```swift

//extension
public extension UIImage {
  var hasContent: Bool {
    return cgImage != nil || ciImage != nil
  }
}




// para usar
@State private var image = UIImage()


  
 if image.hasContent {
       Image(uiImage: image)
              .resizable()
              .frame(width: 100, height: 100)
              .background(Color.black.opacity(0.2))
              .clipShape(Circle())
 } else {
      Image("avatar")
              .resizable()
              .frame(width: 100, height: 100)
              .background(Color.black.opacity(0.2))
              .clipShape(Circle())
}

  //para pegar o device
  if UIDevice.current.isSimulator {
           Text("Identificamos que esta em um emulador 🥲")
              .font(.custom(FontsApp.openLight, size: 16))
              .foregroundColor(ColorsApp.gray)
            ButtonCommon(
              action: handleGetPhotoGallery,
              title: "Pegar foto da galeria"
            )
   } else {
            ButtonCommon(
              action: handleGetPhotoGallery,
              title: "Pegar foto da galeria"
            )
            ButtonCommon(
              action: handleGetPhotoCamera,
              title: "Tirar foto"
            )
   }
 

//usei um tempo para evitar conflitos no momento de abrir a camera
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      showSheetGallery.toggle()
    }


//pego da camera
 ImagePicker(sourceType: .camera, selectedImage: $image)


//pego da galeria
ImagePicker(sourceType: .photoLibrary, selectedImage: $image)


```

##
- Para salvar a imagem no storage(firebase)  é recuperar   usei o data do UiImage e após isso fiz o download
- A  URL retornada no downloadURL e possível exibir diretamente no AsyncImag

```swift
  @State private var image = UIImage()

  var imageForFirebase: Data? {
    return image.jpegData(compressionQuality: 0.5)
  }

// para fazer uplaod no firebase
func converterDataFromUrlRequest(
    data: Data?,
    reference: String,
    completion: @escaping (Result<URL, HttpError>) -> Void
  ) {
    let storageRef = storage.reference()
    let photoUserRef = storageRef.child("images/\(reference).jpg")
    if let uploadPhoto = data {
      photoUserRef.putData(uploadPhoto, metadata: nil) { _, error in

        if error != nil {
          print(error)
          return completion(.failure(.badResponse))
        }

        photoUserRef.downloadURL { url, _ in
          if let url = url {
            return completion(.success(url))
          }

          return completion(.failure(.badURL))
        }
      }
    }
    return completion(.failure(.noData))
  }


//usando a foto
 AsyncImage(url: stateUser.user.photoUrl ?? URL(string: "https://github.com/kenjimaeda54.png")) { phase in
              if let image = phase.image {
                image
                  .resizable()
                  .frame(width: 50, height: 50)
                  .clipShape(Circle())
                  .accessibilityIdentifier("teste")
              }
            }

```

##
- Para detectar cada mudança nos publishers posso usar onReceive, por exemplo, se desejo após emitir o publisher do stateLoading efetuar algo, consigo usando esse recurso

```swift
//toda vez qeu o publisher do destinations alterar acontece um evento aqui
.onReceive(storeHome.$destinations) { destination in
        storeFavorite.handleDestinationFavorites(destinations: destination)
  }



```

## Link da publicação
- [Linkedin](https://www.linkedin.com/posts/kenjimaeda1233_firebase-swiftui-ios-activity-7128336421202870272-N21t?utm_source=share&utm_medium=member_desktop)






