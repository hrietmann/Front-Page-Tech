//
//  Product.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import Foundation



struct Product: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let price: NSDecimalNumber
    
    static let list = [
        Product(title: "Recycle Bin logo design", image: "shopping-0", price: 47.99),
        Product(title: "FPT 404 - We got hacked, limited t-shirt", image: "shopping-1", price: 23.98),
        Product(title: "Toilet Squad … hub", image: "shopping-2", price: 45.99),
        Product(title: "Toilet Squad … hub", image: "shopping-3", price: 24.98),
        Product(title: "Recycle Bin logo design", image: "shopping-4", price: 24.98),
        Product(title: "Recycle Bin logo design", image: "shopping-5", price: 16.98),
        Product(title: "Recycle Bin logo design", image: "shopping-6", price: 27.99),
        Product(title: "FAH PAH TAH (Re-release)", image: "shopping-7", price: 24.98),
        Product(title: "FAH PAH TAH (Re-release)", image: "shopping-8", price: 47.99),
        Product(title: "MAG-O-NUTS", image: "shopping-9", price: 44.99),
        Product(title: "MAG-O-NUTS", image: "shopping-10", price: 22.98),
        Product(title: "MAG-O-NUTS", image: "shopping-11", price: 23.98)
    ]
}



extension NSDecimalNumber {
    var price: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        return formatter.string(from: self)!
    }
}
