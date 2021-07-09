//
//  TabsView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import Views



struct TabsView: View {
    
    
    
    var body: some View {
        HTab {
            TabPage(NewsView())
                .selected(
                    Image(systemName: "newspaper.fill")
                        .foregroundColor(.pink)
                        .overlay(notifDot)
                )
                .deselected(
                    Image(systemName: "newspaper")
                        .overlay(notifDot)
                )
            
            TabPage(ForumView())
                .selected(
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.pink)
                )
                .deselected(
                    Image(systemName: "bubble.left.and.bubble.right")
                )
            
            TabPage(Models3DView())
                .selected(Image(systemName: "view.3d").font(.title2.weight(.heavy)).foregroundColor(.pink))
                .deselected(Image(systemName: "view.3d"))
            
            TabPage(PodcastView())
                .selected(Image(systemName: "waveform").font(.title2.weight(.heavy)).foregroundColor(.pink))
                .deselected(Image(systemName: "waveform"))
            
            TabPage(StoreView())
                .selected(Image(systemName: "bag.fill").foregroundColor(.pink))
                .deselected(Image(systemName: "bag"))
        }
        .foregroundColor(Color(.label))
    }
    
    var notifDot: some View {
        Color.red
            .frame(width: 6, height: 6)
            .clipShape(Circle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: 10)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
