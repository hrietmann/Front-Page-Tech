//
//  AccountView.swift
//  FPT
//
//  Created by Hans Rietmann on 31/01/2022.
//

import SwiftUI
import AuthenticationKit

struct AccountView: View {
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if authenticationManager.state.isLoading {
                    ProgressView()
                }
                if authenticationManager.state.isConnected {
                    Text("Connected as \(authenticationManager.user?.username ?? "Username")")
                    Button {
                        authenticationManager.signOut()
                    } label: {
                        Text("Sign out")
                    }
                }
                if authenticationManager.state.isDisconnected {
                    Button {
                        authenticationManager.signIn()
                    } label: {
                        Text("Sign in")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Account")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Back", action: dismiss.callAsFunction)
                    }
                }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
