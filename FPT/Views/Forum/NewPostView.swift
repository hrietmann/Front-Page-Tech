//
//  NewPostView.swift
//  FPT
//
//  Created by Hans Rietmann on 02/02/2022.
//

import SwiftUI
import AuthenticationKit



struct NewPostView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @StateObject private var model: NewPostViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Bool?
    @State private var presentError = false
    
    init(user: User) {
        let model = NewPostViewModel(user: user, placeholder: "What do you want to say kid?")
        _model = .init(wrappedValue: model)
    }
    
    var body: some View {
        NavigationView {
            HStack(alignment: .top, spacing: 8) {
                currentUserProfileImage
                
                TextEditor(text: $model.message)
                    .focused($focusedField, equals: true)
                    .foregroundColor(model.message == model.placeholder ? .secondary : .primary)
                    .onTapGesture {
                        if model.message == model.placeholder {
                            model.message = ""
                        }
                    }
                    .onChange(of: focusedField) { field in
                        if field == nil {
                            model.message = model.message.isEmpty || model.message == model.placeholder ? model.placeholder : model.message
                        } else {
                            model.message = model.message == model.placeholder ? "" : model.message
                        }
                    }
                    .disabled(model.isLoading)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6)
                { focusedField = true }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.createNewPost()
                    } label: {
                        if model.isLoading {
                            ProgressView()
                        } else {
                            Text("Post")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.accentColor)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .disabled(model.message.isEmpty || model.message == model.placeholder || model.isLoading)
                }
            }
            .onReceive(model.$isCreated) { if $0 { dismiss() } }
            .onReceive(model.$error) { if $0 != nil { presentError = true } }
            .onReceive(model.$isLoading) { if $0 { focusedField = nil } }
            .alert("Error", isPresented: $presentError) {
                
            } message: {
                Text(model.error?.localizedDescription ?? "")
            }
        }
    }
    
    var currentUserProfileImage: some View {
        SwiftUI.AsyncImage(url: authManager.user?.profileImageURL) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color(.label))
                .frame(width: 16, height: 16, alignment: .center)
        }
        .frame(width: 35, height: 35)
        .background(.thinMaterial)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.secondarySystemFill), lineWidth: 0.5)
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(user: .exemple)
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
