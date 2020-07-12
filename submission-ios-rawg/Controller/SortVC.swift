//
//  SortVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class SortVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnResetSort: UIButton!
    
    var defService = UserDefaultServices.instance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        btnConfirm.layer.cornerRadius = 5
        btnResetSort.layer.borderWidth = 1
        btnResetSort.layer.cornerRadius = 5
        btnResetSort.layer.borderColor = UIColor(named: "grey")?.cgColor
        
        switchStatus.isOn = defService.isAscending == 0 ? true : false
        labelStatus.text = switchStatus.isOn ? "Descending" : "Ascending"
        
        switchStatus.isEnabled = defService.orderPosition > orderingList.count ? false : true
        if defService.orderPosition > orderingList.count {
            btnConfirm.isEnabled = false
            btnConfirm.alpha = 0.5
        }
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        let onState = switchStatus.isOn
        
        defService.isAscending = onState ? 0 : 1
        labelStatus.text = onState ? "Descending" : "Ascending"
    }
    
    @IBAction func btnConfirmPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_CONFIRM_SORT_PRESSED, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResetPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_RESET_SORT_SELECTED, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SortVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrder")!
        cell.textLabel?.text = orderingList[indexPath.row].capitalizingFirstLetter()
        
        cell.accessoryType = indexPath.row == defService.orderPosition ? .checkmark : .none
//        if indexPath.row == defService.orderPosition {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defService.orderPosition = indexPath.item
        switchStatus.isEnabled = defService.orderPosition > orderingList.count ? false : true
        btnConfirm.isEnabled = true
        btnConfirm.alpha = 1
        
        tableView.reloadData()
    }
}
