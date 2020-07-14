//
//  MainVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 07/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var gamesList: [GameModel]?
    
    var defService = UserDefaultServices.instance
    
    var gameService = GameService()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        gameService.delegate = self
        if defService.orderPosition > orderingList.count {
            gameService.getAllGames()
        } else {
            gameService.getGames(baseOn: orderingList[defService.orderPosition], defService.isAscending == 0 ? true : false)
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetPressed(_:)), name: NOTIF_RESET_SORT_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(confirmPressed(_:)), name: NOTIF_CONFIRM_SORT_PRESSED, object: nil)
    }
    
    @objc func resetPressed(_ notif: Notification) {
        defService.orderPosition = 99
        gameService.getAllGames()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
    }
    
    @objc func confirmPressed(_ notif: Notification) {
        let isAscending = defService.isAscending == 0 ? true : false
        let order = orderingList[defService.orderPosition]
        
        gameService.getGames(baseOn: order, isAscending)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
    }
    
    @IBAction func btnSortPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSortVC", sender: self)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gamesCell") as? GamesCell else {return UITableViewCell()}
        
        let model = gamesList![indexPath.row]
        cell.setupUI(game: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailGame" {
            let detailVC = segue.destination as! DetailVC
            
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.game = gamesList?[indexPath.row]
            }
        } else if segue.identifier == "toSortVC" {
            let sortVC = segue.destination as! SortVC
            
            sortVC.isModalInPresentation = true
        }
    }
}

extension MainVC: GameDelegate {
    func didUpdateGames(_ service: GameService,_ games: [GameModel]) {
        
        gamesList = games
        DispatchQueue.main.async {
            self.tableView.reloadData()

            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func didFailure(_ error: Error) {
        print("Error: ", error)
    }
}
