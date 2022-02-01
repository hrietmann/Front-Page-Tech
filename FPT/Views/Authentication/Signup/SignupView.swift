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
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var presentNextPage = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Create your account")
                .font(.title3)
                .fontWeight(.heavy)
                .padding()
            
            TextField("Name", text: $authenticationManager.usernameEntry)
                .textFieldStyle(.frontPageTech(icon: "person.fill", check: usernameCheck))
                .focused($focusedField, equals: .username)
                .keyboardType(.alphabet)
                .textContentType(.name)
                .autocapitalization(.words)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(false)
                .submitLabel(.next)
            
            TextField("Email", text: $authenticationManager.emailEntry)
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
                    focusedField = !authenticationManager.usernameEntry.isEmpty ? .emailAddress : nil
                    
                case .emailAddress:
                    focusedField = nil
                    guard authenticationManager.usernameError == nil,
                          authenticationManager.emailError == nil
                    else { return }
                    goNext()
                    
                default: break
                }
            }
    }
    
    private var canGoToNext: Bool {
        !authenticationManager.usernameEntry.isEmpty &&
        !authenticationManager.emailEntry.isEmpty
    }
    private var usernameCheck: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.usernameEntry.isEmpty else { return .none }
        if let error = authenticationManager.usernameError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authenticationManager.usernameEntry.isValidUsername ? .valid : .none
    }
    private var emailCheck: FPTTextFieldStyle.CheckState {
        guard !authenticationManager.emailEntry.isEmpty else { return .none }
        if let error = authenticationManager.emailError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authenticationManager.emailEntry.isValidEmail ? .valid : .none
    }
    private func goNext() {
        focusedField = nil
        let error = authenticationManager.usernameError ?? authenticationManager.emailError
        guard error == nil else { return }
        presentNextPage = true
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
        }
            .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
