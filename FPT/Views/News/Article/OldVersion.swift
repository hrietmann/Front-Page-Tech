//
//  OldVersion.swift
//  FPT
//
//  Created by Hans Rietmann on 28/06/2021.
//

import SwiftUI
import Views
import Shimmer




struct OldVersion: View {
    
    @ObservedObject var manager: ArticleManager
    @Environment(\.presentationMode) var presentationMode
    let namespace: Namespace.ID
    @State private var readyToClose = false
    @State private var presentUnderConstruction = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear
                    .aspectRatio(contentMode: .fit)
                    .aspectRatio(1.4, contentMode: .fill)
                    .overlay(image)
                    .frame(maxWidth: .infinity)
                    .background(Color(.tertiarySystemFill))
                    .shimmering(active: manager.image.isLoading)
                    .clipped()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .blur(radius: self.getBlurRadiusForImage(geometry))
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: UIScreen.main.bounds.width * 0.85)
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    header
                        .padding(.bottom)
                    
                    writer
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    Image("page1")
                        .resizable()
                        .scaledToFit()
                        .padding(.top)
                    Text(
    """
    For some, iPad mini is an absolute favorite. All the warm fuzzy feels of an iPad, packed into this tiny, nearly one-handed device. The last iPad mini we got, iPad mini 5, was released back in 2019 and a lot of us assumed that we wouldn’t be getting a new version.
    
    However, rumors of a new iPad mini have stayed alive and we’ve been back and forth on what to expect.
    
    Back in April, Sonny Dickson posted images of supposed “dummy units” for new iPads. One of which was iPad mini.
    """).padding().padding(.horizontal)
                    Text(
    """
    At least from those images, it didn’t appear as though iPad mini would be getting a significant redesign. That changes with today’s FrontPageTech.com exclusive, as we’re showing you the first redesign to Apple’s iPad mini in six years.
    
    More recently, last week we received a new report from Mark Gurman, via Bloomberg, claiming that the new iPad mini would have “narrower borders”, noting that the “removal of the home button” had also been tested.
    
    Working with multiple sources, we obtained a blend schematics, CAD files, as well as real hands-on images with the newly redesigned iPad mini. As always, in order to protect the sources, I reached out to render artist, RendersbyIan, to have those images and schematics brought to life in hawt 3D renders.
    
    Here’s the new iPad mini!
    """).padding().padding(.horizontal)
                    Image("page2")
                        .resizable()
                        .scaledToFit()
                }
                
                Group {
                    Text(
    """
    As you can see, the new iPad mini is set to receive the flat treatment. Getting the very familiar flat sides and back, as we’ve seen with almost every new Apple product recently. In fact, it’s nearly identical to the 2020 iPad Air. It’s iPad Air, but smol.
    """).padding().padding(.horizontal)
                    
                    Image("page3")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    As Gurman first reported: yes, the home button has been removed in favor of a larger screen fitting inside nearly the same footprint as the previous iPad mini. In fact, I’ve been told that there’s only a 3mm difference between the footprint of this new iPad mini, and the last.
    
    iPad mini 6 sits at 206.3mm x 137.8mm x 6.1mm
    """).padding().padding(.horizontal)
                    
                    Image("page4")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    Touch ID has now moved to the power button, speakers have been dramatically improved — in fact, one source referred to these new speakers as “crazy nice”.
    """).padding().padding(.horizontal)
                    
                    Image("page5")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    The Lightning connector has also been swapped out in favor of USB-C, which is… an interesting move, especially for iPad mini.
    """).padding().padding(.horizontal)
                }
                
                Group {
                    Image("page6")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    According to sources, the newly redesigned iPad mini 6 will come in 3 colors: Silver, black and gold.
    
    But that’s not all for this little guy…
    
    Sources also referenced support for Apple Pencil… but not the current one. A smaller one.
    """).padding().padding(.horizontal)
                    
                    Image("page7")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    Which got us thinking… Remember that “Apple Pencil 3” leak from a few months ago?
    
    We went back to look at those leaked images and came up with an interesting theory: What if that’s not Apple Pencil 3? What if those leaked images were of a smaller Apple Pencil mini?
    
    Take a look here, as we scaled the leaked images against the current Apple Pencil. You can see that the leaked images depict something significantly smaller.
    """).padding().padding(.horizontal)
                    
                    Image("page8")
                        .resizable()
                        .scaledToFit()
                    
                    Text("""
    There’s also the possibility that this is the new Apple Pencil 3, not a special one for iPad mini, which will in fact end up being a smaller product than the last two Apple Pencils.
    
    Along with the redesign, I’ve been told iPad mini will ship with 5G and Apple’s A14 processor inside and is expected by the end of the year.
    """).padding().padding(.horizontal)
                    
                    Spacer()
                        .frame(height: UIApplication.shared.windows[0].safeAreaInsets.bottom)
                }
            }
            .font(.footnote.weight(.medium))
            .padding(.top, -16 * 6)
        }
        .redacted(reason: manager.article.isLoading ? .placeholder:[])
        .edgesIgnoringSafeArea(.all)
        .overlay(closeButton)
        .transition(.opacity)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.secondarySystemBackground))
        .onAppear {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
    
    
    
    @ViewBuilder
    var image: some View {
        if let image = manager.image.result {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
        } else {
            EmptyView()
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(manager.article.result?.subtitle.uppercased() ?? Article.list[0].subtitle.uppercased())
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.pink)
                .lineLimit(1)
            Text(manager.article.result?.title.uppercased() ?? Article.list[0].title.uppercased())
                .font(.title3)
                .fontWeight(.heavy)
                .font(.headline)
                .foregroundColor(Color(.label))
        }
        .animation(.spring())
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .padding()
        .background(Color(.tertiarySystemBackground))
        .shadow(radius: 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var writer: some View {
        VStack(spacing: 20) {
            HStack {
                Image("FPT App Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("By \(manager.article.result?.author ?? "Fah Pah Tah")")
                        .font(.headline)
                        .bold()
                    Text("Published \(manager.article.result?.createdAt.timeAgo ?? "- time ago")")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { presentUnderConstruction.toggle() }) {
                    Label("Share", systemImage: "paperplane.fill")
                        .foregroundColor(.pink)
                        .font(.footnote.bold())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Capsule())
                }
                .buttonStyle(BounceButtonStyle())
            }
            
            warning
        }
    }
    
    var warning: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("⚠️")
                .font(.headline)
            Text("The news bellow is only dummy content to show the general layout. Take note that multiple features are missing in this early version like interactive 3D renders preview, links to outside content, integrated video preview, and much more… Stay tuned !")
                .font(.footnote.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray)
        }
        .padding(16)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    var closeButton: some View {
        Button(action: close, label: {
            Image(systemName: "xmark")
                .font(.subheadline.bold())
                .padding(8)
                .foregroundColor(.secondary)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Circle())
        })
            .scaleEffect(readyToClose ? 1.4:1)
            .animation(.spring(response: 0.3))
            .buttonStyle(BounceButtonStyle())
            .shadow(radius: 8)
            .padding()
            .padding(.top, UIApplication.shared.windows[0].safeAreaInsets.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func close() {
//        HomeManager.shared.dimissCurrentPage()
        presentationMode.wrappedValue.dismiss()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
    
    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        handleCloseBehaviour(offset: offset)
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        return blur * 4 // Values will range from 0 - 6
    }
    
    private func handleCloseBehaviour(offset: CGFloat) {
        withAnimation(.spring(response: 0.4)) {
            let screenWidth = UIScreen.main.bounds.width
            if offset > screenWidth * 0.95 {
                if offset > screenWidth * 1.25 {
                    close()
                } else {
                    guard !readyToClose else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.readyToClose = true
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }
                }
            } else {
                guard readyToClose else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.readyToClose = false
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                }
            }
        }
    }
    
}

struct OldVersion_Previews: PreviewProvider {
    static var previews: some View {
        OldVersion(manager: .init(feed: .init()), namespace: Namespace().wrappedValue)
    }
}
