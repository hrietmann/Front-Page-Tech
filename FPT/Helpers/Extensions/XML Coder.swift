//
//  XML Coder.swift
//  FPT
//
//  Created by Hans Rietmann on 10/02/2022.
//

import Foundation
import SWXMLHash





extension URL: XMLElementDeserializable, XMLAttributeDeserializable {
    public static func deserialize(_ element: XMLElement) throws -> URL {
        let url = URL(string: element.text)
        guard let validURL = url else {
            throw XMLDeserializationError.typeConversionFailed(type: "URL", element: element)
        }
        return validURL
    }
    
    public static func deserialize(_ attribute: XMLAttribute) throws -> URL {
        let url = URL(string: attribute.text)
        guard let validURL = url else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "URL", attribute: attribute)
        }
        return validURL
    }
    
    public func validate() throws {
        // empty validate... only necessary for custom validation logic after parsing
    }
}

extension Date: XMLElementDeserializable, XMLAttributeDeserializable {
    public static func deserialize(_ element: XMLElement) throws -> Date {
        let date = ISO8601DateFormatter().date(from: element.text)
        guard let validDate = date else {
            throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }
        return validDate
    }
    
    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        let date = ISO8601DateFormatter().date(from: attribute.text)
        guard let validDate = date else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }
        return validDate
    }
    
    public func validate() throws {
        // empty validate... only necessary for custom validation logic after parsing
    }
}
