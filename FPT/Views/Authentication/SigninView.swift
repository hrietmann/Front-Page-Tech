//
//  SigninView.swift
//  FPT
//
//  Created by Hans Rietmann on 28/01/2022.
//

import SwiftUI
import AuthenticationKit
import SPAlert




struct SigninView: View {
    
    enum Field {
            case emailAddress
        case password
        }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @State private var presentPasswordReset = false
    @FocusState private var focusedField: Field?
    @State private var presentError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("To get started, first enter your credentials")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal)
                TextField("Email", text: $authenticationManager.emailEntry)
                    .textFieldStyle(.frontPageTech(icon: "envelope.fill", check: emailCheck))
                    .focused($focusedField, equals: .emailAddress)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.next)
                
                TextField("Password", text: $authenticationManager.passwordEntry)
                    .textFieldStyle(.frontPageTech(icon: "key.fill", check: passwordCheck))
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.send)
                
                Spacer()
                Button(action: signin) {
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
                .disabled(!canGoToNext)
                
                HStack(spacing: 4) {
                    Text("Forgot your password?")
                        .foregroundColor(.secondary)
                    Button {
                        presentPasswordReset = true
                    } label: {
                        Text("Change it")
                            .fontWeight(.bold)
                    }
                }
                .font(.caption)
                .padding(.vertical)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fullScreenCover(isPresented: $presentPasswordReset) {
                    PasswordResetRequestView()
                }

            }
            .disabled(!authenticationManager.state.isDisconnected)
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
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                            .foregroundColor(.label)
                    }
                }
                .onReceive(authenticationManager.$state) { state in
                    guard state.isConnected else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let alertView = SPAlertView(
                            title: "Welcome back!",
                            message: "It's good to see you back dude! 🥸",
                            preset: .custom(.init(systemName: "hand.thumbsup.fill")!))
                        alertView.dismissByTap = true
                        alertView.duration = 4
                        alertView.present(haptic: .success, completion: nil)
                    }
                }
                .onReceive(authenticationManager.$error) { error in
                    presentError = error != nil
                }
                .alert("Error", isPresented: $presentError) {
                    
                } message: {
                    Text(authenticationManager.error?.localizedDescription ?? "")
                }
                .onSubmit {
                    switch focusedField {
                    case .emailAddress:
                        focusedField = .password
                        
                    case .password:
                        focusedField = nil
                        guard passwordCheck.isValid else { return }
                        signin()
                        
                    default: return
                    }
                }
        }
    }
    
    private var canGoToNext: Bool {
        !authenticationManager.emailEntry.isEmpty &&
        authenticationManager.emailEntry.isValidEmail &&
        !authenticationManager.passwordEntry.isEmpty
    }
    
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.emailEntry.isEmpty else { return .none }
        if let error = authenticationManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authenticationManager.emailEntry.isValidEmail ? .valid : .none
    }
    
    private var passwordCheck: FPTTextFieldStyle.CheckState {
        guard authenticationManager.passwordEntry.isEmpty else { return authenticationManager.passwordEntry.count >= 6 ? .valid : .none }
        guard focusedField == nil else { return .none }
        return .invalid("Password missing")
    }
    
    private func signin() {
        authenticationManager.signIn()
    }
    
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
            .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
