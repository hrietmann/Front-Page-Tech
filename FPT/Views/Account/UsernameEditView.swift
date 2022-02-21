//
//  UsernameEditView.swift
//  FPT
//
//  Created by Hans Rietmann on 18/02/2022.
//

import SwiftUI
import AuthenticationKit
import Shimmer



struct UsernameEditView: View {
    
    enum Field {
        case username
    }
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @State private var presentNextPage = false
    @State private var loadUsername = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Change your username")
                .font(.title3)
                .fontWeight(.heavy)
                .padding()
            
            TextField("Username", text: $authManager.usernameEntry)
                .textFieldStyle(.frontPageTech(icon: "person.fill", check: usernameCheck))
                .focused($focusedField, equals: .username)
                .keyboardType(.alphabet)
                .textContentType(.name)
                .autocapitalization(.words)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(false)
                .submitLabel(.send)
            
            Spacer()
            
            Button(action: changeUsername) {
                Text("Change")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
            }
            .disabled(!canChangeUsername)
            
            Button("Cancel") {
                dismiss()
            }
            .font(.subheadline.weight(.bold))
            .padding(8)
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
        .redacted(reason: authManager.state.isLoading ? .placeholder : [])
        .shimmering(active: authManager.state.isLoading)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .username
            }
        }
        .onSubmit {
            switch focusedField {
            case .username:
                focusedField = nil
                guard authManager.usernameError == nil else { return }
                changeUsername()
                
            default: break
            }
        }
        .onReceive(authManager.$state) { state in
            switch state {
            case .connected:
                guard loadUsername else { return }
                loadUsername = false
                dismiss()
            default: return
            }
        }
    }
    
    private var canChangeUsername: Bool {
        !authManager.usernameEntry.isEmpty
    }
    private var usernameCheck: FPTTextFieldStyle.CheckState {
        guard !authManager.usernameEntry.isEmpty else { return .none }
        if let error = authManager.usernameError, focusedField == nil
        { return .invalid(error.localizedDescription) }
        return authManager.usernameEntry.isValidUsername ? .valid : .none
    }
    private func changeUsername() {
        focusedField = nil
        if authManager.usernameEntry == authManager.state.user?.username {
            dismiss()
            return
        }
        let error = authManager.usernameError
        guard error == nil else { return }
        loadUsername = true
        authManager.changeUsername()
    }
}

struct UsernameEditView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameEditView()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
