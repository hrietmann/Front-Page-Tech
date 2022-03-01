//
//  AsyncImage.swift
//  FPT
//
//  Created by Hans Rietmann on 10/07/2021.
//

import SwiftUI
import ViewKit
import Shimmer



//struct AsyncImage<Placeholder: View>: View {
//    
//    let placeholder: Placeholder
//    @StateObject private var manager: AsyncImageManager
//    init(url: URL?, placeholder: Placeholder) {
//        _manager = .init(wrappedValue: .init(url: url))
//        self.placeholder = placeholder
//    }
//    
//    var body: some View {
//        ZStack {
//            Group {
//                Color(.tertiarySystemFill)
//                placeholder
//            }
//            .shimmering(active: manager.image.isWaitingOrLoading)
//            
//            if let image = manager.image.result {
//                image
//                    .resizable()
//                    .scaledToFill()
//                    .transition(.opacity)
//            }
//        }
//    }
//}
//
//struct AsyncImage_Previews: PreviewProvider {
//    static var previews: some View {
//        AsyncImage(url: URL(string: "https://www.frontpagetech.com/wp-content/uploads/2021/06/flippyboi3.jpg"),
//                   placeholder: Image(systemName: "person.crop.circle")
//                    .resizable()
//                    .scaledToFit()
//        )
//            .aspectRatio(1, contentMode: .fit)
//            .frame(width: 150)
//            .clipped()
//            .clipShape(Circle())
//    }
//}
