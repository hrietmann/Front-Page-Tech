//
//  SignupProfileView.swift
//  FPT
//
//  Created by Hans Rietmann on 29/01/2022.
//

import SwiftUI
import SwiftUIX
import AuthenticationKit
import SPAlert


struct SignupProfileView: View {
    
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @State private var presentImagePicker = false
    @State private var dismissing = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Pick a profile picture")
                .font(.title3)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.top)
            
            Text("Have a favorite selfie? Upload it now.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Spacer()
            
            if authenticationManager.state.isLoading {
                ProgressView()
                    .transition(
                        .move(edge: .bottom)
                            .combined(with: .opacity)
                            .combined(with: .scale)
                            .animation(.easeOut)
                    )
            } else {
                profileButton
                    .transition(
                        .move(edge: .bottom)
                            .combined(with: .opacity)
                            .combined(with: .scale)
                            .animation(.easeOut)
                    )
            }
            
            Spacer()
            Spacer()
            Spacer()
            
            Button(action: signup) {
                Text("Sign up")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
            }
            .disabled(authenticationManager.profileImage == nil)
            
            Button("Skip for now", action: signup)
            .font(.subheadline.weight(.bold))
            .padding(8)
        }
        .disabled(authenticationManager.state.isLoading)
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
        .onReceive(authenticationManager.$state) { state in
            guard state.isConnected, dismissing == false else { return }
            dismissing.toggle()
            if authenticationManager.profileImage != nil {
                authenticationManager.changeProfileImage()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let alertView = SPAlertView(
                    title: "Welcome!",
                    message: "I'm proud to have you in the toilet squad dude! 😘",
                    preset: .heart)
                alertView.dismissByTap = true
                alertView.duration = 4
                alertView.present(haptic: .success, completion: nil)
            }
        }
    }
    
    var profileButton: some View {
        Button {
            presentImagePicker = true
        } label: {
            profileButtonLabel
        }
        .overlay {
            profileAddButton
        }
        .fullScreenCover(isPresented: $presentImagePicker) {
            ImagePicker(image: $authenticationManager.profileImage)
                .allowsEditing(true)
                .sourceType(.photoLibrary)
        }
    }
    
    
    var profileButtonLabel: some View {
        ZStack {
            if let image = authenticationManager.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 160, height: 160)
        .background(Color(.secondarySystemFill))
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color(.tertiaryLabel), lineWidth: 0.3)
            }
    }
    
    var profileAddButton: some View {
        Button {
            presentImagePicker = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .padding(20)
                .background(.background)
        }
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.tertiaryLabel), lineWidth: 0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .offset(x: 16, y: 16)
    }
    
    private func signup() {
        authenticationManager.signUp()
    }
}

struct SignupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupProfileView()
        }
        .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
