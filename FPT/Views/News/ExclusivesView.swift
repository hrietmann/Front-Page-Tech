//
//  HomeFeed.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI

struct ExclusivesView: View {
    
    var namespace: Namespace.ID
    
    var body: some View {
        NewsFeed(namespace: namespace, articles: Article.list)
    }
}

struct HomeFeed_Previews: PreviewProvider {
    static var previews: some View {
        ExclusivesView(namespace: Namespace.init().wrappedValue)
    }
}
