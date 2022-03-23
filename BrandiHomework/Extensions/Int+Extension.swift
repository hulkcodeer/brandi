//
//  Int+Extension.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import Foundation

extension Int {
    func toComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
