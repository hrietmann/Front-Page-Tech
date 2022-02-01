//
//  PasswordResetRequestView.swift
//  FPT
//
//  Created by Hans Rietmann on 29/01/2022.
//

import SwiftUI
import AuthenticationKit

struct PasswordResetRequestView: View {
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Bool?
    @State private var presentError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Reset your password")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal)
                
                Text("Enter your account email to receive a confirmation code.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .padding(.horizontal)
                
                TextField("Email", text: $authenticationManager.emailEntry)
                    .textFieldStyle(.frontPageTech(icon: "envelope.fill", check: emailCheck))
                    .focused($focusedField, equals: true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.send)
                
                Spacer()
                Button(action: sendResetEmail) {
                    Group {
                        if authenticationManager.state.isLoading {
                            ProgressView()
                        } else {
                            Text("Send")
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
                .disabled(!canSendEmail)
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
                .onSubmit {
                    focusedField = nil
                    guard canSendEmail else { return }
                    sendResetEmail()
                }
                .onReceive(authenticationManager.$error) { error in
                    presentError = error != nil
                }
        }
    }
    
    private var canSendEmail: Bool {
        !authenticationManager.emailEntry.isEmpty &&
        authenticationManager.emailEntry.isValidEmail
    }
    
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.emailEntry.isEmpty else { return .none }
        if let error = authenticationManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authenticationManager.emailEntry.isValidEmail ? .valid : .none
    }
    
    private func sendResetEmail() {
        authenticationManager.sendPasswordResetEmail()
    }
}

struct PasswordResetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetRequestView()
    }
}
