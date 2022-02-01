//
//  AuthenticationView.swift
//  FPT
//
//  Created by Hans Rietmann on 28/01/2022.
//

import SwiftUI
import ViewKit
import AuthenticationKit


struct AuthenticationView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authenticationManager: AuthenticationManager<Authenticator>
    @State private var presentLogIn = false
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    VStack(alignment: .leading) {
                        Text("🧻")
                            .font(.largeTitle)
                            .frame(width: 70, height: 70)
                            .scaleEffect(2)
                        Text("Become part of the toilet squad right now!".capitalized)
                            .font(.title.weight(.heavy))
                    }
                    .offset(y: -35)
                        .frame(maxHeight: .infinity)
                    
                    Button {
                        
                    } label: {
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: "applelogo")
                                .font(.title2)
                                .offset(y: -1)
                            Text("Continue with Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .font(.headline)
                        .foregroundColor(Color(.label))
                        .overlay { Rectangle().stroke(Color(.tertiaryLabel), lineWidth: 1) }
                    }
                    .buttonStyle(BounceButtonStyle())
                    
                    Divider()
                        .overlay {
                            Text("Or")
                                .font(.caption)
                                .textCase(.uppercase)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .background(.background)
                        }
                        .padding(.vertical)
                    
                    NavigationLink {
                        SignupView()
                    } label: {
                        Text("Create account")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(.tint)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(BounceButtonStyle())
                    
                    Button {
                        
                    } label: {
                        
                    }
                    
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Not now")
                            .font(.footnote.italic())
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(.accentColor)
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(BounceButtonStyle())
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Text("Have an account already?")
                        .foregroundColor(.secondary)
                    Button {
                        presentLogIn = true
                    } label: {
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                }
                .font(.caption)
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.bottom)
                .foregroundColor(.accentColor)
                .fullScreenCover(isPresented: $presentLogIn) {
                    SigninView()
                }
            }
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
        }
        .navigationBarHidden(true)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthenticationView()
        }
        .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
