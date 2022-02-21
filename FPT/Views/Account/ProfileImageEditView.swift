//
//  ProfileImageEditView.swift
//  FPT
//
//  Created by Hans Rietmann on 18/02/2022.
//

import SwiftUI
import AuthenticationKit
import SwiftUIX



struct ProfileImageEditView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @Environment(\.dismiss) private var dismiss
    @State private var presentImagePicker = false
    @State private var presentError = false
    @State private var isUplaodingImage = false
    
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
            
            if authManager.state.isLoading {
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
            
            Button(action: saveNewImage) {
                Text("Save image")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
            }
            .disabled(authManager.profileImage == nil)
            
            Button("Cancel") {
                dismiss()
                authManager.profileImage = nil
            }
                .font(.subheadline.weight(.bold))
                .padding(8)
        }
        .tint(.accentColor)
        .disabled(authManager.state.isLoading)
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
        .onReceive(authManager.$error) { error in
            presentError = error != nil
        }
        .alert("Error", isPresented: $presentError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authManager.error?.localizedDescription ?? "error")
        }
        .onReceive(authManager.$state) { state in
            guard isUplaodingImage else { return }
            switch state {
            case .connected:
                withAnimation {
                    isUplaodingImage = false
                    authManager.profileImage = nil
                    dismiss()
                }
                
            default: return
            }
        }
        .onAppear {
            authManager.profileImage = nil
        }
        .shimmering(active: authManager.state.isLoading)
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
            ImagePicker(image: $authManager.profileImage)
                .allowsEditing(true)
                .sourceType(.photoLibrary)
        }
    }
    
    
    var profileButtonLabel: some View {
        ZStack {
            if let image = authManager.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                SwiftUI.AsyncImage(url: authManager.user?.profileImageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.clear
                }
            }
        }
        .frame(width: 160, height: 160)
        .background(Color(.secondarySystemFill))
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.tertiaryLabel), lineWidth: 0.3)
                .shimmering(active: authManager.user?.profileImageURL != nil)
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
    
    private func saveNewImage() {
        isUplaodingImage = true
        authManager.changeProfileImage()
    }
}

struct ProfileImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageEditView()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
