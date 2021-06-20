//
//  AndroidView.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI

struct AndroidView: View {
    var namespace: Namespace.ID
    var body: some View {
        NewsFeed(namespace: namespace, articles: Article.list.filter { $0.subtitle.lowercased() == "android" })
    }
}

struct AndroidView_Previews: PreviewProvider {
    static var previews: some View {
        AndroidView(namespace: Namespace().wrappedValue)
    }
}
