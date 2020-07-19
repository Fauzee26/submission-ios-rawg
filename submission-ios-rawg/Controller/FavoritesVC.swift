//
//  FavoritesVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 19/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackEmpty: UIStackView!
    
    var gamesList: [GameModel]?
    
    var defService = UserDefaultServices.instance
    var cdService = CoreDataService.self
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        gamesList = cdService.getFavoriteGames()
        
        emptyCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

        gamesList = cdService.getFavoriteGames()
        tableView.reloadData()
        
        emptyCheck()
    }
    
    func emptyCheck() {
        if gamesList?.count == 0 {
            tableView.isHidden = true
            stackEmpty.isHidden = false
        } else {
            tableView.isHidden = false
            stackEmpty.isHidden = true
        }
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as? GamesCell else {return UITableViewCell()}
        
        let model = gamesList![indexPath.row]
        
        var data: Data?
        if let gameBg = model.background_image {
            let url = URL(string: gameBg)
            data = try? Data(contentsOf: url!)
        }
        
        cell.setupUI(game: model, imageData: data)
        
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
        }
    }
}
