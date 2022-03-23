//
//  CommonBaseTableViewCell.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit

internal class CommonBaseCollectionViewCell: UICollectionViewCell {
    internal lazy var totalView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    deinit {
        printLog(out: "\(type(of: self)): Deinited")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal func makeUI() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
