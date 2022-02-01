//
//  NewPasswordView.swift
//  FPT
//
//  Created by Hans Rietmann on 29/01/2022.
//

import SwiftUI
import AuthenticationKit

struct SignupPasswordView: View {
    
    enum Field {
            case password
            case password2
        }
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @FocusState private var focusedField: Field?
    @State private var presentNextPage = false
    @State private var presentError = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("You'll need a password")
                .font(.title3)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.top)
            
            Text("Make sure it's at least \(constraints).")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            
            SecureField("Password", text: $authenticationManager.passwordEntry)
                .textFieldStyle(.frontPageTech(icon: "key.fill", check: passwordCheck))
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
            
            SecureField("Confirm your password", text: $authenticationManager.passwordEntry2)
                .textFieldStyle(.frontPageTech(icon: "key.fill", check: password2Check))
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password2)
                .submitLabel(.next)
            
            Spacer()
            
            Button(action: goNext) {
                Group {
                    if authenticationManager.state.isLoading {
                        ProgressView()
                    } else {
                        Text("Next")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .textCase(.uppercase)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.tint)
                .foregroundColor(.white)
            }
            .disabled(canGoToNext == false || authenticationManager.state.isDisconnected == false)
            .background {
                NavigationLink(isActive: $presentNextPage) {
                    SignupProfileView()
                } label: { EmptyView() }
                .hidden()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
            }
            .onSubmit {
                switch focusedField {
                case .password:
                    focusedField = authenticationManager.passwordEntry.isEmpty ? nil : .password2
                    
                case .password2:
                    focusedField = nil
                    guard authenticationManager.passwordError == nil,
                          authenticationManager.password2Error == nil
                    else { return }
                    goNext()
                    
                default: break
                }
            }
            .onReceive(authenticationManager.$error) { error in
                presentError = error != nil
            }
            .alert("Error", isPresented: $presentError) {
                
            } message: {
                Text(authenticationManager.error?.localizedDescription ?? "Unknown error")
            }
    }
    
    private var constraints: String {
        ListFormatter.localizedString(byJoining: Authenticator.passwordConstraints.map {
            switch $0 {
            case .atLeast8Characters:           return "8 characters"
            case .atLeastOneLowercaseLetter:    return "1 lowercase letter"
            case .atLeastOneUppercaseLetter:    return "1 capital letter"
            case .atLeastOneDigits:             return "1 digit"
            case .atLeastOneSpecialCharacter:   return "1 special character"
            }
        })
    }
    
    private var canGoToNext: Bool {
        !authenticationManager.passwordEntry.isEmpty &&
        !authenticationManager.passwordEntry2.isEmpty
    }
    
    private var passwordCheck: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.passwordEntry.isEmpty else { return .none }
        if let error = authenticationManager.passwordError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        let constraints = Authenticator.passwordConstraints
        return authenticationManager.passwordEntry.isValidPassword(with: constraints) ? .valid : .none
    }
    
    private var password2Check: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.passwordEntry2.isEmpty else { return .none }
        if let error = authenticationManager.password2Error, focusedField == nil
        { return .invalid(error.localizedDescription) }
        let constraints = Authenticator.passwordConstraints
        return authenticationManager.passwordEntry2.isValidPassword(with: constraints) ? .valid : .none
    }
    
    private func goNext() {
        focusedField = nil
        let error = authenticationManager.passwordError ?? authenticationManager.password2Error
        guard error == nil else { return }
        presentNextPage = true
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupPasswordView()
        }
        .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
