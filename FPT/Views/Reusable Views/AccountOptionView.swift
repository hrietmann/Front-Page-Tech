//
//  AccountOptionView.swift
//  FPT
//
//  Created by Hans Rietmann on 16/02/2022.
//

import SwiftUI
import ViewKit



struct AccountOptionView<Icon:View>: View {
    
    let title: String
    let image: Icon
    let completion: (() -> ())?
    let toggle: Binding<Bool>?
    
    init(_ title: String, systemName: String, completion: (() -> ())? = nil) where Icon == Image {
        self.title = title
        self.image = Image(systemName: systemName)
        self.completion = completion
        self.toggle = nil
    }
    
    init(_ title: String, imageNamed: String, completion: (() -> ())? = nil) where Icon == Image {
        self.title = title
        self.image = Image(imageNamed)
        self.completion = completion
        self.toggle = nil
    }
    
    init(_ title: String, image: () -> Icon, completion: (() -> ())? = nil) {
        self.title = title
        self.image = image()
        self.completion = completion
        self.toggle = nil
    }
    
    init(_ title: String, systemName: String, toggle: Binding<Bool>) where Icon == Image {
        self.title = title
        self.image = Image(systemName: systemName)
        self.completion = nil
        self.toggle = toggle
    }
    
    init(_ title: String, toggle: Binding<Bool>, image: () -> Icon) {
        self.title = title
        self.image = image()
        self.completion = nil
        self.toggle = toggle
    }
    
    init(_ title: String, imageNamed: String, toggle: Binding<Bool>) where Icon == Image {
        self.title = title
        self.image = Image(imageNamed)
        self.completion = nil
        self.toggle = toggle
    }
    
    var body: some View {
        if let completion = completion {
            Button {
                completion()
            } label: {
                content
            }
            .buttonStyle(.bounce(scale: 0.98))
        } else {
            content
        }
    }
    
    var content: some View {
        HStack {
            image.unredacted()
            Text(title).unredacted()
            Spacer()
            if let toggle = toggle {
                Toggle("", isOn: toggle)
            }
        }
        .font(.body, weight: .bold)
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.secondary, lineWidth: 0.3)
        }
    }
}

struct AccountOptionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AccountOptionView("Stateless option", systemName: "person.fill")
                .padding(.horizontal)
            AccountOptionView("Actionable option", systemName: "person.fill", completion: {})
                .padding(.horizontal)
            AccountOptionView("Stateless option", systemName: "person.fill", toggle: .constant(true))
                .padding(.horizontal)
                .tint(.blue)
        }
    }
}
