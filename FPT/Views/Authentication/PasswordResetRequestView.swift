//
//  PasswordResetRequestView.swift
//  FPT
//
//  Created by Hans Rietmann on 29/01/2022.
//

import SwiftUI
import AuthenticationKit
import Shimmer
import SPAlert



struct PasswordResetRequestView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Bool?
    @State private var presentError = false
    @State private var sendingResetEmail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Reset your password")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal)
                    .unredacted()
                
                Text("Enter your account email to receive a confirmation code.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .padding(.horizontal)
                
                TextField("Email", text: $authManager.emailEntry)
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
                        if authManager.state.isLoading, authManager.taskCompleted == false {
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
            .shimmering(active: authManager.state.isLoading && !authManager.taskCompleted)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    focusedField = true
                }
            }
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
                .onReceive(authManager.$error) { error in
                    presentError = error != nil
                }
                .onReceive(authManager.$state) { state in
                    guard state.isLoading == false, sendingResetEmail else { return }
                    sendingResetEmail = false
                    dismiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let alertView = SPAlertView(
                            title: "Email sent!",
                            message: "Check your emails to finish your password reset! 📬",
                            preset: .custom(.init(systemName: "paperplane.fill")!))
                        alertView.dismissByTap = true
                        alertView.duration = 4
                        alertView.present(haptic: .success, completion: nil)
                    }
                }
        }
    }
    
    private var canSendEmail: Bool {
        !authManager.emailEntry.isEmpty &&
        authManager.emailEntry.isValidEmail
    }
    
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authManager.emailEntry.isEmpty else { return .none }
        if let error = authManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authManager.emailEntry.isValidEmail ? .valid : .none
    }
    
    private func sendResetEmail() {
        sendingResetEmail = true
        authManager.sendPasswordResetEmail()
    }
}

struct PasswordResetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetRequestView()
    }
}
