import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var wrongUsername: CGFloat = 0
    @State private var wrongPassword: CGFloat = 0
    @State private var showingLoginScreen = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color.orange
                    .ignoresSafeArea()

                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    Text("Login")
                        .font(.custom("Helvetica Neue", size: 40).weight(.bold))
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 215/255, blue: 0/255), Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                        .padding(.vertical, 20)

                    TextField("E-mail", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                        } else {
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                        }

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }

                    Button("Login") {
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.top, 10)

                    NavigationLink(destination: create(), label: {
                        Text("No account? Create one here")
                            .bold()
                            .padding()
                            .foregroundColor(.cyan)
                            .underline()
                    })

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                .fixedSize()
                .onTapGesture {
                    hideKeyboard()
                }
                .ignoresSafeArea(.keyboard)

                // Ajout du texte "Alpha v0.4" en bas à droite
                .overlay(
                    Text("Alpha v0.4")
                        .foregroundColor(.white)
                        .padding()
                        .offset(x: 130, y: 360)
                        .bold()
                        .underline()
                )
            }
            .navigationBarHidden(true)
        }
    }

    func authenticateUser(username: String, password: String) {
        // Reset error messages
        wrongUsername = 0
        wrongPassword = 0
        errorMessage = nil

        if username.isEmpty {
            errorMessage = "Username is required"
            return
        }

        if password.isEmpty {
            errorMessage = "Password is required"
            return
        }

        if username.lowercased() == "mario2021" {
            if password.lowercased() == "abc123" {
                showingLoginScreen = true
            } else {
                wrongPassword = 2
                errorMessage = "Incorrect password"
            }
        } else {
            wrongUsername = 2
            errorMessage = "User not found"
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

