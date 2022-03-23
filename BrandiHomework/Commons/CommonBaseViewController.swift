//
//  CommonBaseViewController.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit

internal class CommonBaseViewController: UIViewController {
    deinit {
        printLog(out: "\(type(of: self)): Deinited")
    }
    
    internal lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview($0)
        $0.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
