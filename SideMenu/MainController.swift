//
//  ViewController.swift
//  SideMenu
//
//  Created by bui.xuan.huyb on 06/05/2021.
//

import UIKit

private struct Constant {
    static let widthNotificationView = UIScreen.main.bounds.width * 2 / 3
}

class MainController: UIViewController {
    
    @IBOutlet private var blurMenuView: UIView!
    @IBOutlet private var openMenuButton: UIButton!
    @IBOutlet private var menuViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var menuView: UIView!
    
    private var isOpenMenu = false
    private var beginPoint: CGFloat = 0
    private var difference: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        menuViewTrailingConstraint.constant = -Constant.widthNotificationView
        blurMenuView.isHidden = true
    }

    private func setUpUI() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuController = storyboard.instantiateViewController(identifier: "MenuController") as? MenuController else {
            return
        }
        menuController.delegate = self
        menuController.view.frame = menuView.bounds
        menuView.addSubview(menuController.view)
        addChild(menuController)
        menuController.didMove(toParent: self)
    }
    
    @IBAction private func openMenuButtonTapped(_ sender: Any) {
        displayMenu()
    }
    
    func displayMenu() {
        isOpenMenu.toggle()
        blurMenuView.alpha = isOpenMenu ? 0.5 : 0
        blurMenuView.isHidden = !isOpenMenu
        UIView.animate(withDuration: 0.2) {
            self.menuViewTrailingConstraint.constant = self.isOpenMenu ? 0 : -(UIScreen.main.bounds.width * 2 / 3)
            self.view.layoutIfNeeded()
        }
    }
}

extension MainController {
    // Lưu lại toạ độ x điểm bắt đầu chạm
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isOpenMenu {
            if let touch = touches.first {
                let location = touch.location(in: blurMenuView)
                beginPoint = location.x
            }
        }
    }
    
    // Tính khoảng cách người dùng vuốt theo trục x để thay đổi toạ độ Menu, tạo hiệu ứng trượt theo cử chỉ của người dùng
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if isOpenMenu, let touch = touches.first {
            let location = touch.location(in: blurMenuView)
            let differenceFromBeginPoint = location.x - beginPoint
            if differenceFromBeginPoint > 0, differenceFromBeginPoint < Constant.widthNotificationView {
                difference = differenceFromBeginPoint
                menuViewTrailingConstraint.constant = -differenceFromBeginPoint
                blurMenuView.alpha = 0.5 * (1 - differenceFromBeginPoint / Constant.widthNotificationView)
            }
        }
    }
    
    // Sau khi người dùng thả tay, tính toán khoảng cách điểm kết thúc so với điểm bắt đầu theo trục x để quyết định ẩn hay vẫn hiển thị Menu
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isOpenMenu {
            if difference == 0, let touch = touches.first {
                // Trường hợp người dùng chỉ chạm, không vuốt, nếu điểm chạm nằm ngoài MenuView, sẽ ẩn MenuView đi
                let location = touch.location(in: blurMenuView)
                if !menuView.frame.contains(location) {
                    displayNotification(isShown: false)
                }
            } else if difference > Constant.widthNotificationView / 2 {
                // Trường hợp khoảng cách lớn 1/2 độ rộng Menu, ẩn Menu đi
                displayNotification(isShown: false)
            } else {
                // Trường hợp khoảng cách chưa đủ 1/2 độ rộng Menu, hiển thị lại Menu
                displayNotification(isShown: true)
            }
        }
        difference = 0
    }
    
    // Cập nhật constaint và opacity của BlurView theo trạng thái ẩn, hiện của Menu
    private func displayNotification(isShown: Bool) {
        blurMenuView.alpha = isShown ? 0.5 : 0
        blurMenuView.isHidden = !isShown
        UIView.animate(withDuration: 0.2) {
            self.menuViewTrailingConstraint.constant = isShown ? 0 : -Constant.widthNotificationView
            self.view.layoutIfNeeded()
        }
        isOpenMenu = isShown
    }
}

extension MainController: MenuDelegate {
    func selectMenuItem(with item: MenuItem) {
        switch item {
        case .toScreen1:
            print("User select screen 1")
        case .toScreen2:
            print("User select screen 2")
        case .toScreen3:
            print("User select screen 3")
        }
    }
}
