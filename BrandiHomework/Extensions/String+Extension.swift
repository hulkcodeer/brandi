//
//  String+Extension.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import Foundation

extension String {
    var urlEncoded: String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset)
        return encodedString ?? self
    }
}
