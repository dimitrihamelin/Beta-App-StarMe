import SwiftUI

struct create: View {
    @State private var firstName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var errorMessage: String?
    @State private var showingLoginScreen = false

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

                VStack(spacing: 20) {
                    Text("Create")
                        .font(.custom("Helvetica Neue", size: 40).weight(.bold))
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 215/255, blue: 0/255), Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                        .padding(.vertical, 20)

                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    TextField("E-mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none) // Disable auto-capitalization for email
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

                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 20)
                        }

                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                    }

                    Button("Create") {
                        createAccount()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.top, 10)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                .fixedSize() 
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    func createAccount() {
        // Reset error messages
        errorMessage = nil

        // Validate input fields
        if firstName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required"
            return
        }

        // Check first name length
        if firstName.count < 3 {
            errorMessage = "First name must be at least 3 characters"
            return
        }

        // Check email format
        if !isValidEmail(email) {
            errorMessage = "Invalid email address"
            return
        }

        // Check password conditions
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters"
            return
        }

        // Check if passwords match
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }

        // Implement your account creation logic here
        // You may want to check for existing accounts, etc.

        // For demonstration purposes, let's assume the account is created successfully.
        // After creating the account, set showingLoginScreen to false to dismiss LoginView.
        showingLoginScreen = false
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct create_Previews: PreviewProvider {
    static var previews: some View {
        create()
    }
}

