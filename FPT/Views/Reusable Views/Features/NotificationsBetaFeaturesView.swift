//
//  NotificationsBetaFeaturesView.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import SwiftUI
import ViewKit


struct NotificationsBetaFeaturesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 40) {
                        NotificationsBetaFeature(icon: "suit.heart.fill", text: "Choose your notifications based on the themes you care about like videos, exclusives, forum answers to your questions, …")
                        NotificationsBetaFeature(icon: "star.fill", text: "Receive custom punctual push notifications from Jon like Fah Pah Tah features announcement, custom surveys,  etc…")
                        NotificationsBetaFeature(icon: "person.2.fill", text: "Jon will be able to send custom notifications to specific audience only (like those who sub to exclusives or videos) or the entire toilet squad.")
                        NotificationsBetaFeature(icon: "bag.fill.badge.plus", text: "Create reminders for merch before they're gone and/or be alerted for new ones.")
                        NotificationsBetaFeature(icon: "rectangle.stack.fill.badge.plus", text: "Much much more is in my feature's bag…")
                        WarningView(text: "This view will only be presented during the beta testing to describe the features to the community and frontpagetech team.")
                    }
                    .font(.headline.weight(.semibold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 60)
                }
                
                Divider()
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Really cool ! 😎".uppercased())
                        .font(.body.weight(.heavy))
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(20)
                }
                .buttonStyle(BounceButtonStyle())
            }
            .navigationTitle(Text("Notifications"))
        }
    }
}


fileprivate struct NotificationsBetaFeature: View {
    let icon: String
    let text: LocalizedStringKey
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: icon)
                .font(.title.weight(.bold))
                .foregroundColor(.accentColor)
                .frame(width: 30)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct NotificationsBetaFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsBetaFeaturesView()
    }
}
