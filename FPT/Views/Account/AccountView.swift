//
//  AccountView.swift
//  FPT
//
//  Created by Hans Rietmann on 31/01/2022.
//

import SwiftUI
import AuthenticationKit
import ViewKit
import Shimmer



struct AccountView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @State private var confirmAccountDeletion = false
    @State private var presentAuthenticationView = false
    @State private var presentProfileImageEdit = false
    @State private var presentUsernameEdit = false
    @State private var presentEmailEdit = false
    @State private var presentPasswordReset = false
    @State private var presentAppIcons = false
    @AppStorage("selectedAppIcon") private var selectedAppIcon = "FPT App Icon"
    
    var body: some View {
        NavigationView {
            newContent
        }
        .preferredColorScheme(.dark)
    }
    
    var username: String {
        if let username = authManager.user?.username { return username }
        if authManager.state.isLoading { return "Loading" }
        return authManager.state.isDisconnected ? "Sign in" : "Anonymous"
    }
    
    var newContent: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    
                    Section {
                        header
                        Spacer()
                    }
                    
                    Section {
                        AccountOptionView("Change profile image", systemName: "photo.fill") {
                            presentProfileImageEdit = true
                        }
                        .sheet(isPresented: $presentProfileImageEdit) {
                            ProfileImageEditView().colorScheme(.dark)
                        }
                        AccountOptionView("Change username", systemName: "person.text.rectangle.fill") {
                            presentUsernameEdit = true
                        }
                        .sheet(isPresented: $presentUsernameEdit) {
                            UsernameEditView().colorScheme(.dark)
                        }
                        AccountOptionView("Change email", systemName: "envelope.fill") {
                            presentEmailEdit = true
                        }
                        .sheet(isPresented: $presentEmailEdit) {
                            EmailEditView().colorScheme(.dark)
                        }
                        AccountOptionView("Change password", systemName: "key.fill") {
                            presentPasswordReset = true
                        }
                        .sheet(isPresented: $presentPasswordReset) {
                            PasswordResetRequestView().colorScheme(.dark)
                        }
                        if UIApplication.shared.supportsAlternateIcons {
                            AccountOptionView("Change App icon") {
                                Image(selectedAppIcon)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color.secondary, lineWidth: 0.4)
                                    }
                            } completion: {
                                presentAppIcons = true
                            }
                            .sheet(isPresented: $presentAppIcons) {
                                AppIconsView().colorScheme(.dark)
                            }
                        }
                        Divider()//.padding(.horizontal)
                    }
                    .disabled(authManager.state.isDisconnected)
                    .opacity(authManager.state.isDisconnected ? 0.5:1)
                    
                    Section {
                        if authManager.state.isDisconnected {
                            AccountOptionView("Sign in", systemName: "rectangle.and.pencil.and.ellipsis") {
                                presentAuthenticationView = true
                            }
                            .foregroundColor(.blue)
                            .fullScreenCover(isPresented: $presentAuthenticationView) {
                                AuthenticationView().colorScheme(.dark)
                            }
                        }
                        if authManager.state.isConnected {
                            AccountOptionView("Sign out", systemName: "lock.fill") {
                                authManager.signOut()
                            }
                            .foregroundColor(.red)
                            AccountOptionView("Delete account", systemName: "trash.fill") {
                                confirmAccountDeletion = true
                            }
                            .foregroundColor(.red)
                            .confirmationDialog("Are you sure you want to delete your account? It will be deleted for ever! (that's a very long time…)", isPresented: $confirmAccountDeletion, titleVisibility: .visible) {
                                Button("Delete my account", role: .destructive) {
                                    authManager.deleteUser()
                                }
                                Button("Cancel", role: .cancel, action: {})
                            }
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Text("Proudly designed in 🇫🇷")
                        Text("By Hans Rietmann")
                        Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")") +
                        Text(" build \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")")
                    }
                    .font(.caption)
                    .foregroundColor(.tertiaryLabel)
                    .redacted(reason: [])
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .safeAreaInset(edge: .top) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline, weight: .bold)
                        .accentColor(.white)
                        .padding(12)
                        .background(.ultraThickMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.bounce(scale: 0.8))
                .shimmering(active: false)
                .redacted(reason: [])
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background {
                VStack(alignment: .trailing) {
                    if let email = authManager.user?.email {
                        Text("Front Page Tech Member".uppercased())
                        Text(email.uppercased())
                    }
                }
                .padding(.top)
                .padding(.trailing)
                .font(.caption)
                .foregroundColor(Color(uiColor: .systemGray5).opacity(0.9))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
            VStack {
                Text(username.uppercased())
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .kerning(10)
                    .foregroundColor(Color(uiColor: .systemGray5))
                    .rotated(.degrees(90))
                    .padding(.horizontal, -8)
                    .padding(.top)
                Color(uiColor: .systemGray5)
                    .frame(width: 2)
                    .ignoresSafeArea()
            }
            .redacted(reason: [])
        }
        .redacted(reason: authManager.state.isLoading ? .placeholder : [])
        .shimmering(active: authManager.state.isLoading)
        .animation(.easeOut, value: authManager.state.isLoading)
        .navigationBarHidden(true)
        .background {
            Color.accentColor
                .frame(width: 240, height: 240)
                .clipShape(Circle())
                .ignoresSafeArea()
                .offset(x: -100, y: -150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(.black)
        .colorScheme(.dark)
    }
    
    var header: some View {
        Color(uiColor: .secondarySystemBackground)
            .frame(width: 140, height: 140)
            .overlay {
                userImage
            }
            .overlay(Circle().stroke(Color.white, lineWidth: 16))
            .clipShape(Circle())
            .frame(maxWidth: .infinity)
    }
    
    var userImage: some View {
        SwiftUI.AsyncImage(url: authManager.user?.profileImageURL) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color(uiColor: .tertiarySystemGroupedBackground)
                .overlay {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .shimmering(active: authManager.user?.profileImageURL != nil)
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
