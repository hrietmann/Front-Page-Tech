//
//  SignupExperienceOptionsView.swift
//  FPT
//
//  Created by Hans Rietmann on 29/01/2022.
//

import SwiftUI
import AuthenticationKit

struct SignupExperienceOptionsView: View {
    
    @State private var sharePhone = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Customize your experience")
                .font(.title3)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Connect with people you know")
                    .font(.headline, weight: .heavy)
                Toggle("Let other find your Twitter account by your phone number.", isOn: $sharePhone)
                    .font(.footnote, weight: .medium)
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Connect with people you know")
                    .font(.headline, weight: .heavy)
                Toggle("Let other find your Twitter account by your phone number.", isOn: $sharePhone)
                    .font(.footnote, weight: .medium)
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Connect with people you know")
                    .font(.headline, weight: .heavy)
                Toggle("Let other find your Twitter account by your phone number.", isOn: $sharePhone)
                    .font(.footnote, weight: .medium)
            }
            .padding(.bottom)
            
            Spacer()
            Button {
                
            } label: {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
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
    }
}

struct SignupExperienceOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupExperienceOptionsView()
        }
        .environmentObject(AuthenticationManager(authenticator: Authenticator()))
    }
}
