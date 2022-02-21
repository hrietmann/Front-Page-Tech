//
//  EmailEditView.swift
//  FPT
//
//  Created by Hans Rietmann on 19/02/2022.
//

import SwiftUI
import AuthenticationKit
import Shimmer



struct EmailEditView: View {
    
    enum Field {
        case emailAddress
        case password
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @FocusState private var focusedField: Field?
    @State private var presentError = false
    @State private var dismissing = false
    @State private var changingEmail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("To securely change your email, enter your new email and your current password.")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal)
                
                TextField("New email", text: $authManager.emailEntry)
                    .textFieldStyle(.frontPageTech(icon: "envelope.fill", check: emailCheck))
                    .focused($focusedField, equals: .emailAddress)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.next)
                
                TextField("Password", text: $authManager.passwordEntry)
                    .textFieldStyle(.frontPageTech(icon: "key.fill", check: passwordCheck))
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.send)
                
                Spacer()
                Button(action: changeEmail) {
                    Group {
                        if authManager.state.isLoading {
                            ProgressView()
                        } else {
                            Text("Change email")
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
            }
            .disabled(authManager.state.isLoading)
            .redacted(reason: authManager.state.isLoading ? .placeholder : [])
            .shimmering(active: authManager.state.isLoading)
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
            .onReceive(authManager.$state) { state in
                guard state.isConnected, changingEmail else { return }
                changingEmail = false
                dismiss()
            }
            .onReceive(authManager.$error) { error in
                presentError = error != nil
            }
            .alert("Error", isPresented: $presentError) {
                
            } message: {
                Text(authManager.error?.localizedDescription ?? "")
            }
            .onAppear {
                authManager.emailEntry = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    focusedField = .emailAddress
                }
            }
            .onDisappear {
                authManager.emailEntry = authManager.user?.email ?? ""
                authManager.passwordEntry = ""
            }
            .onSubmit {
                switch focusedField {
                case .emailAddress:
                    focusedField = .password
                    
                case .password:
                    focusedField = nil
                    guard passwordCheck.isValid else { return }
                    changeEmail()
                    
                default: return
                }
            }
        }
    }
    
    private var canGoToNext: Bool {
        !authManager.emailEntry.isEmpty &&
        authManager.emailEntry.isValidEmail &&
        !authManager.passwordEntry.isEmpty
    }
    
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authManager.emailEntry.isEmpty else { return .none }
        if let error = authManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authManager.emailEntry.isValidEmail ? .valid : .none
    }
    
    private var passwordCheck: FPTTextFieldStyle.CheckState {
        guard authManager.passwordEntry.isEmpty
        else { return authManager.passwordEntry.count >= 6 ? .valid : .none }
        guard focusedField == nil else { return .none }
        return .invalid("Password missing")
    }
    
    private func changeEmail() {
        if authManager.user?.email == authManager.emailEntry {
            dismiss()
            return
        }
        changingEmail = true
        authManager.changeEmail()
    }
    
}

struct EmailEditView_Previews: PreviewProvider {
    static var previews: some View {
        EmailEditView()
    }
}
