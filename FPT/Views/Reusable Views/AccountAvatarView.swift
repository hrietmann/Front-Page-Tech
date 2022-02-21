//
//  AccountView.swift
//  FPT
//
//  Created by Hans Rietmann on 24/06/2021.
//

import SwiftUI
import AuthenticationKit
import ViewKit
import SPAlert
import Shimmer



struct AccountAvatarView: View {
    
    enum AuthPage: Int, Identifiable {
        
        case authentication
        case account
        
        var id: Int { rawValue }
    }
    @State private var presentPage: AuthPage? = nil
    @EnvironmentObject private var authentication: AuthManager<Authenticator>
    
    var body: some View {
        Button {
            presentPage = authentication.state.isConnected ? .account : .authentication
        } label: {
            SwiftUI.AsyncImage(url: authentication.user?.profileImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(Color(.label))
                    .frame(width: 18, height: 18, alignment: .center)
                    .shimmering(active: authentication.user?.profileImageURL != nil)
            }
            .frame(width: 40, height: 40)
            .background(.thinMaterial)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color(.secondarySystemFill), lineWidth: 0.5)
            }
        }
        .buttonStyle(BounceButtonStyle())
        .onReceive(authentication.$state) { state in
            if state.isConnected, presentPage == .authentication {
                UIApplication.shared.connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .map { $0 as? UIWindowScene }
                        .compactMap { $0 }
                        .first?.windows
                        .filter { $0.isKeyWindow }
                        .first?.rootViewController?
                        .dismiss(animated: true) {
                            self.presentPage = .account
                        }
            }
            if state.isDisconnected, presentPage == .account { presentPage = nil }
        }
        .fullScreenCover(item: $presentPage) { page in
            switch page {
            case .authentication: AuthenticationView()
            case .account: AccountView()
            }
        }
//        .alert(isPresented: $presentAccountWorkInProgress, content: {
//            Alert(title: Text("Stop 🛑"), message: Text("This space is under construction ! 🚧 Come back in a later version 👷🏽‍♂️"), dismissButton: .cancel(Text("🧻🧻🧻")))
//        })
    }
}

struct AccountAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AccountAvatarView()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
