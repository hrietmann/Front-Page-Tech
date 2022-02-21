//
//  NewsHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI
import ViewKit
import AuthenticationKit

struct NewsHeader: View {
    @State private var presentNotifWorkInProgress = false
    @State private var presentMoreDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .leading)
                    .padding(20)
                Spacer()
                
                HStack(spacing: 30) {
                    SeachHeaderButton()
                        .hidden()
                    
                    Button(action: { presentNotifWorkInProgress.toggle() }, label: {
                        Image(systemName: "bell.badge.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.vertical)
                    })
                        .foregroundStyle(Color(.red), Color(.label))
                    .alert(isPresented: $presentNotifWorkInProgress, content: {
                        Alert(title: Text("Well…"),
                              message: Text("Sometimes, it's better to wait until things are ready… This really looks like s**t right now… 💩"),
                              primaryButton: .default(Text("Tell me more…"),
                                                      action: { DispatchQueue.main.async { presentMoreDetails.toggle() } }),
                              secondaryButton: .cancel(Text("🚽")))
                    })
                    .sheet(isPresented: $presentMoreDetails) {
                        NotificationsBetaFeaturesView()
                    }
                    .hidden()
                    
                    AccountAvatarView()
                }
                .buttonStyle(BounceButtonStyle())
                .padding()
            }
            .frame(height: UIScreen.main.bounds.width * 0.2)
            .zIndex(-2)
            
            Text("A Dumb Tech News App For Smart People.".uppercased())
                .font(.caption)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pink)
                .zIndex(-1)
        }
    }
}

struct HomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        NewsHeader()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
