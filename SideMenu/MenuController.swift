//
//  MenuController.swift
//  SideMenu
//
//  Created by bui.xuan.huyb on 06/05/2021.
//

import UIKit

protocol MenuDelegate: AnyObject {
    func selectMenuItem(with item: MenuItem)
}

class MenuController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var items: [MenuItem] = [.toScreen1, .toScreen2, .toScreen3]
    weak var delegate: MenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction private func plusButtonTapped(_ sender: Any) {
        let randomItem = items.randomElement()
        items.append(randomItem ?? .toScreen1)
        tableView.reloadData()
    }
}

extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as? MenuItemCell else {
            return UITableViewCell()
        }
        cell.setContentForCell(item: items[indexPath.row])
        return  cell
    }
}

extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectMenuItem(with: items[indexPath.row])
    }
}
