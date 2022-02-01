//
//  ArticleBody.swift
//  FPT
//
//  Created by Hans Rietmann on 11/07/2021.
//

import SwiftUI

struct ArticleBody: View {
    
    
    let article: Article?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if let article = article {
                
            } else {
                placeholder
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }
    
    var placeholder: some View {
        Group {
            Image("page1")
                .resizable()
                .scaledToFill()
                .padding(.top)
            Text(
"""
For some, iPad mini is an absolute favorite. All the warm fuzzy feels of an iPad, packed into this tiny, nearly one-handed device. The last iPad mini we got, iPad mini 5, was released back in 2019 and a lot of us assumed that we wouldn’t be getting a new version.
""").padding().padding(.horizontal)
            Image("page2")
                .resizable()
                .scaledToFill()
            
            Text(
    """
    As you can see, the new iPad mini is set to receive the flat treatment. Getting the very familiar flat sides and back, as we’ve seen with almost every new Apple product recently. In fact, it’s nearly identical to the 2020 iPad Air. It’s iPad Air, but smol.
    """).padding().padding(.horizontal)
            
            Image("page3")
                .resizable()
                .scaledToFill()
        }
    }
    
}

struct ArticleBody_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ArticleBody(article: nil)
        }
    }
}
