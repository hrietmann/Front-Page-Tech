//
//  SignupView.swift
//  FPT
//
//  Created by Hans Rietmann on 28/01/2022.
//

import SwiftUI
import AuthenticationKit
import SwiftUIX


struct SignupView: View {
    
    enum Field {
            case username
            case emailAddress
        }
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var presentNextPage = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Create your account")
                .font(.title3)
                .fontWeight(.heavy)
                .padding()
            
            TextField("Name", text: $authManager.usernameEntry)
                .textFieldStyle(.frontPageTech(icon: "person.fill", check: usernameCheck))
                .focused($focusedField, equals: .username)
                .keyboardType(.alphabet)
                .textContentType(.name)
                .autocapitalization(.words)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(false)
                .submitLabel(.next)
            
            TextField("Email", text: $authManager.emailEntry)
                .textFieldStyle(.frontPageTech(icon: "envelope.fill", check: emailCheck))
                .focused($focusedField, equals: .emailAddress)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.next)
            
            Spacer()
            
            Button(action: goNext) {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
            }
            .disabled(!canGoToNext)
            .overlay {
                NavigationLink(isActive: $presentNextPage) {
                    SignupPasswordView()
                } label: {
                    EmptyView()
                }
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
                case .username:
                    focusedField = !authManager.usernameEntry.isEmpty ? .emailAddress : nil
                    
                case .emailAddress:
                    focusedField = nil
                    guard authManager.usernameError == nil,
                          authManager.emailError == nil
                    else { return }
                    goNext()
                    
                default: break
                }
            }
    }
    
    private var canGoToNext: Bool {
        !authManager.usernameEntry.isEmpty &&
        !authManager.emailEntry.isEmpty
    }
    private var usernameCheck: FPTTextFieldStyle.CheckState {
        guard !authManager.usernameEntry.isEmpty else { return .none }
        if let error = authManager.usernameError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authManager.usernameEntry.isValidUsername ? .valid : .none
    }
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authManager.emailEntry.isEmpty else { return .none }
        if let error = authManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authManager.emailEntry.isValidEmail ? .valid : .none
    }
    private func goNext() {
        focusedField = nil
        let error = authManager.usernameError ?? authManager.emailError
        guard error == nil else { return }
        presentNextPage = true
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
