//
//  FPTTextFieldStyle.swift
//  FPT
//
//  Created by Hans Rietmann on 28/01/2022.
//

import Foundation
import SwiftUI
import StringKit



extension TextFieldStyle where Self == FPTTextFieldStyle {
    
    static func frontPageTech(icon: String, check: FPTTextFieldStyle.CheckState = .none) -> FPTTextFieldStyle
    { .init(icon: icon, check: check) }
    
    static var frontPageTech: FPTTextFieldStyle
    { .init(icon: nil, check: .none) }
    
}

struct FPTTextFieldStyle: TextFieldStyle {
    
    let icon: String?
    
    enum CheckState {
        case none
        case valid
        case invalid(String?)
        var message: String? {
            switch self {
            case .invalid(let message): return message
            default: return nil
            }
        }
        var isValid: Bool {
            switch self {
            case .valid: return true
            default: return false
            }
        }
    }
    let check: CheckState
    @State private var popoverMessage: String? = nil
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                configuration
                
                if check.isValid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white, .green)
                        .font(.title2)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
                
                if let message = check.message {
                    Button {
                        present(message: message)
                    } label: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.black, .yellow)
                    }
                    .font(.title2)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .font(.headline.weight(.bold))
            .padding(14)
            .background(.ultraThinMaterial)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .onChange(of: check.message) { message in
                guard let message = message
                else { hidePopMessage() ;  return }
                present(message: message)
            }
            
            if let popoverMessage = popoverMessage {
                Text(popoverMessage)
                    .font(.subheadline.weight(.bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.yellow)
                    .foregroundColor(.black)
            }
        }
        .background(.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func present(message: String?) {
        withAnimation(.spring()) {
            popoverMessage = popoverMessage != nil ? nil : message ?? "Invalid value"
        }
    }
    
    private func hidePopMessage() {
        withAnimation(.spring()) {
            popoverMessage = nil
        }
    }
}

fileprivate struct FPTTextFieldStyleView: View {
    
    @State private var text = ""
    
    var body: some View {
        TextField("Email", text: $text)
            .textFieldStyle(.frontPageTech(
                icon: "envelope.fill",
                check: text.isEmpty ? .none : text.isValidEmail ? .valid : .invalid("Please enter a valid email."))
            )
            .padding()
    }
}


struct FPTTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        FPTTextFieldStyleView()
    }
}
