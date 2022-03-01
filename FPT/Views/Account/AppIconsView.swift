//
//  AppIconsView.swift
//  FPT
//
//  Created by Hans Rietmann on 21/02/2022.
//

import SwiftUI
import ViewKit


struct AppIconsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedAppIcon") private var selectedAppIcon = "FPT App Icon"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        
                        Text("Select the FPT app icon you want to use.")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.horizontal)
                            .padding()
                        
                        AppIconItem(image: "FPT App Icon", title: "Season 9", description: "Memorable season that saw Jon Prosser loose his eye brows.", selectedAppIcon: $selectedAppIcon)
                            .padding(.horizontal)
                        
                        AppIconItem(image: "FPT App Icon 2", title: "FPT Newspaper", description: "Simple and clean 3D newspaper.", selectedAppIcon: $selectedAppIcon)
                            .padding(.horizontal)
                        
                        AppIconItem(image: "FPT App Icon 3", title: "Jon's Eye Brows", description: "Funny memory ", selectedAppIcon: $selectedAppIcon)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal, -16)
                
                Divider()
                    .padding(.horizontal, -16)
                    .padding(.bottom)
                
                Button(action: setAppIcon) {
                    Text("Change App icon")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.tint)
                    .foregroundColor(.white)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                        .foregroundColor(.label)
                }
            }
        }
    }
    
    func setAppIcon() {
        let numberString = selectedAppIcon.components(separatedBy: " ").last ?? "1"
        let number = Int(numberString) ?? 1
        let string = "AppIconAlternate\(number)"
        UIApplication.shared.setAlternateIconName(string) { _ in
            self.dismiss()
        }
    }
}

struct AppIconsView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconsView()
    }
}


fileprivate struct AppIconItem: View {
    
    let image: String
    let title: String
    let description: String
    @Binding var selectedAppIcon: String
    private var isSelected: Bool { image == selectedAppIcon }
    
    var body: some View {
        Button {
            selectedAppIcon = image
        } label: {
            HStack(spacing: 16) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(uiColor: .secondarySystemFill), lineWidth: 0.4)
                    }
                    .shadow(color: .black.opacity(isSelected ? 0.2: 0), radius: 6, x: 1, y: 2)
                
                VStack(alignment: .leading) {
                    Text(title.uppercased())
                        .font(.subheadline.weight(.heavy))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(description)
                        .font(.footnote)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Image(systemName: "circle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(uiColor: .secondarySystemFill), lineWidth: 1)
            }
            .shadow(color: .black.opacity(isSelected ? 0.3: 0), radius: 12, x: 4, y: 6)
        }
        .buttonStyle(.bounce)
        .animation(.spring(), value: isSelected)
    }
    
}
