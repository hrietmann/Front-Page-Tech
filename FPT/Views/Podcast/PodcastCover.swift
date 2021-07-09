//
//  PodcastCover.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import Views


struct PodcastCover: View {
    
    @State private var presentNotWorking = false
     
    var body: some View {
        VStack(spacing: 16) {
            
            Image("podcast")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 16)
            
            Text("Genius Bar".uppercased())
                .font(.title3.weight(.heavy))
                .foregroundColor(Color.white)
            
            Text("Jon Prosser + Sam Kohl")
                .font(.footnote)
                .foregroundColor(Color(.cyan).opacity(0.8))
            
            Button(action: { presentNotWorking.toggle() }) {
                Label("Play", systemImage: "play.fill")
                    .padding(.vertical)
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.black)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .alert(isPresented: $presentNotWorking) {
                Alert(title: Text("I can't, sir… 😪"), message: Text("I know, that's disapointing… But you know, that's already a lot done considering this app was built in only 3 days and in the toilets on a 13‘‘ MacBook. 😂"), dismissButton: .cancel(Text("That's already very cool ! 👌🏻")))
            }
            
            Text("Though this show is hosted bu Jon Prosser and Sam Kohl, this id DEFINITELY not a podcast about Apple. Nope. Huh uh.")
                .font(.footnote)
                .foregroundColor(Color.white)
            
            Text("Technologies • Updates each two weeks")
                .font(.footnote)
                .foregroundColor(Color(.cyan).opacity(0.8))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity)
        .background(Color("podcast"))
        .buttonStyle(BounceButtonStyle())
        .overlay(
            Color("podcast")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .padding(.top, -UIScreen.main.bounds.width)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
    }
}

struct PodcastCover_Previews: PreviewProvider {
    static var previews: some View {
        PodcastCover()
    }
}
