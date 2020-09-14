//
//  UITableView+.swift
//  5MinTub
//
//  Created by Đạt on 2/17/20.
//  Copyright © 2020 Đạt. All rights reserved.
//
import UIKit

extension UITableView {
    
    func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func registerClass(cellType: UITableViewCell.Type) {
        let className = cellType.className
        register(cellType, forCellReuseIdentifier: className)
    }
    
    func register(reusableViewType: UITableViewHeaderFooterView.Type,
                  bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func registerClass(reusableViewType: UITableViewHeaderFooterView.Type) {
        let className = reusableViewType.className
        register(reusableViewType, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: type.className) as! T
    }
}

