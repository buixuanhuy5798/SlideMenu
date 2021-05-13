//
//  MenuItemCell.swift
//  SideMenu
//
//  Created by bui.xuan.huyb on 06/05/2021.
//

import UIKit

enum MenuItem {
    case toScreen1
    case toScreen2
    case toScreen3
    
    var title: String {
        switch self {
        case .toScreen1:
            return "To Screen 1"
        case .toScreen2:
            return "To Screen 2"
        case .toScreen3:
            return "To Screen 3"
        }
    }
}

class MenuItemCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    func setContentForCell(item: MenuItem) {
        titleLabel.text = item.title
    }
}
