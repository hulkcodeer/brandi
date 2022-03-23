//
//  CommonBaseTableViewCell.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit

internal class CommonBaseCollectionViewCell: UICollectionReusableView {
    deinit {
        printLog(out: "\(type(of: self)): Deinited")
    }
}
