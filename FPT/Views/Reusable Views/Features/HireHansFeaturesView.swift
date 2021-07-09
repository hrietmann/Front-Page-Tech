//
//  HireHansFeaturesView.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import SwiftUI
import ViewKit

struct HireHansFeaturesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) var openURL
    
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            Image("hans.hand.hi")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: 3)
                .frame(width: 280)
            
            Divider()
            
            ScrollViewReader { scroll in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        messagesHeader
                        thankyouMessage
                            .bubbleAnimation(on: appeared, with: 0, in: scroll)
                        sideProjectMessage
                            .bubbleAnimation(on: appeared, with: 2, in: scroll)
                        twitterMessage
                            .bubbleAnimation(on: appeared, with: 7, in: scroll)
                        bookMessage
                            .bubbleAnimation(on: appeared, with: 12, in: scroll)
                        subscriptionMessage
                            .bubbleAnimation(on: appeared, with: 17, in: scroll)
                    }
                    .padding(.vertical)
                    .padding(.bottom, 80)
                }
            }
            .overlay(
                ZStack(alignment: .bottom) {
                backButton
            }
                    .opacity(appeared ? 1:0)
                    .offset(y: appeared ? 0:16*2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .animation(.spring(response: 0.6).delay(0.2 + 22))
            )
            
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear { appeared = true }
    }
    
    
    var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Text("Return to the app".uppercased())
                .font(.body.italic().weight(.heavy))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
                .shadow(color: .accentColor.opacity(0.4), radius: 12, x: 4, y: 12)
        }
        .buttonStyle(BounceButtonStyle())
    }
    
    
    var messagesHeader: some View {
        VStack(spacing: 0) {
            Text("Today")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("Thank you from Hans ❤️")
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
        }
    }
    
    
    var thankyouMessage: some View {
        Bubble(userImage: "hans", circled: true,
               text: "Thank you Jon for looking at the FPT app ! 😇")
    }
    
    
    var twitterMessage: some View {
        HStack(spacing: 0) {
            Image("hans.idea")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .scaleEffect(1.8)
                .offset(x: 4, y: -4)
                .padding(.leading)
                .frame(maxHeight: .infinity, alignment: .bottom)
            
            ChatBubble(direction: .left) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("If there's any feature you wish to add, send me a quick DM on Twitter. 💌")
                        .font(.subheadline)
                        .padding()
                        .padding(.horizontal, 6)
                    Divider()
                    Button(action: {
                        openURL(URL(string: "https://twitter.com/messages/1449711853-1449711853?recipient_id=1449711853")!)
                    }, label: {
                        HStack(spacing: 12) {
                            Image("twitter")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("twitter"))
                            Text("Send a DM to Hans")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(Color(.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(Color("twitter").brightness(0.2).opacity(0.2))
                }
                .background(Color(.secondarySystemFill))
            }
            .offset(x: -8)
        }
    }
    
    
    var sideProjectMessage: some View {
        Bubble(userImage: "hans.stars", circled: false,
               text: "FPT is only a cool side project for me right now. However, I would be very proud to make it on a full time. 🤩")
    }
    
    
    var bookMessage: some View {
        HStack(spacing: 0) {
            Image("hans.thumbs.up")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .scaleEffect(1.8)
                .offset(x: 4, y: -4)
                .padding(.leading)
                .frame(maxHeight: .infinity, alignment: .bottom)
            
            ChatBubble(direction: .left) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("If you feel like offering me the opportunity to work with you would give you value, consider booking a call. 🤗")
                        .font(.subheadline)
                        .padding()
                        .padding(.horizontal, 6)
                    Divider()
                    Button(action: {
                        openURL(URL(string: "https://calendly.com/hansrietmann/rendez-vous")!)
                    }, label: {
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.red)
                            Text("Book a 30mn call")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(Color(.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(Color.red.brightness(0.2).opacity(0.2))
                }
                .background(Color(.secondarySystemFill))
            }
            .offset(x: -8)
        }
    }
    
    var subscriptionMessage: some View {
        Bubble(userImage: "hans.hand.v", circled: false,
               text: "P.S. : With that many unique features, I did think about integrate premium subscription using in-app purchases. So… your app could easely become a new source of income for you. 💸")
    }
}


fileprivate extension View {
    func bubbleAnimation(on appeared: Bool, with delay: TimeInterval, in scroll: ScrollViewProxy, to anchor: UnitPoint = .center) -> some View {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + delay) {
            withAnimation(.spring()) {
                scroll.scrollTo(delay, anchor: anchor)
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


fileprivate struct Bubble: View {
    
    let userImage: String
    let circled: Bool
    let text: String
    
    var body: some View {
        HStack(spacing: 0) {
            if circled {
                avatar
                    .clipShape(Circle())
                    .padding(.leading)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                avatar
                    .scaleEffect(1.8)
                    .offset(x: 4, y: -4)
                    .padding(.leading)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            ChatBubble(direction: .left) {
                Text(text)
                    .font(.subheadline)
                    .padding()
                    .padding(.horizontal, 6)
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

struct HireHansFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        HireHansFeaturesView()
    }
}
