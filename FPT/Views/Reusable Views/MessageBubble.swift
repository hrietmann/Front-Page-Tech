//
//  MessageBubble.swift
//  FPT
//
//  Created by Hans Rietmann on 27/01/2022.
//

import SwiftUI
import ViewKit


struct MessageBubble: View {
    
    let userImage: String
    let circled: Bool
    let text: String
    var avatarLeadingPadding = 16.0
    
    var body: some View {
        HStack(spacing: 0) {
            if circled {
                avatar
                    .clipShape(Circle())
                    .padding(.leading, avatarLeadingPadding)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                avatar
                    .scaleEffect(1.8)
                    .offset(x: 4, y: -4)
                    .padding(.leading, avatarLeadingPadding)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            ChatBubble(direction: .left) {
                Text(text)
                    .font(.subheadline)
                    .padding()
                    .padding(.leading, 6)
                    .padding(.trailing, 2)
                    .background(Color(.secondarySystemFill))
            }
            .offset(x: -8)
        }
    }
    
    var avatar: some View {
        Image(userImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(userImage: "john", circled: true, text: "Problem md flsfkdslm fmldks fkds fkd fkds fkd sfdskfd")
    }
}



extension View {
    func messageBubbleAnimation(on appeared: Bool, with delay: TimeInterval, in scroll: ScrollViewProxy?, to anchor: UnitPoint = .center) -> some View {
        if let scroll = scroll {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + delay) {
                withAnimation(.spring()) {
                    scroll.scrollTo(delay, anchor: anchor)
                }
            }
        }
        return self
            .id(delay)
            .opacity(appeared ? 1:0)
            .offset(x: appeared ? 0:-16*4, y: appeared ? 0:16*2)
            .scaleEffect(appeared ? 1:0.8)
            .animation(.spring(response: 0.6).delay(0.2 + delay))
    }
}
