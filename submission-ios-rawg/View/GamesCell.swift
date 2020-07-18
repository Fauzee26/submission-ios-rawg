//
//  GamesCell.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class GamesCell: UITableViewCell {
    
    @IBOutlet weak var imgBgGame: RoundedImageView!
    @IBOutlet weak var labelGame: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    func setupUI(game: GameModel, imageData: Data?) {
        labelGame.text = game.name
        
        var dateReleased = ""
        if let gameReleased = game.released {
            dateReleased = " · \(gameReleased.convertToDate())"
        }
        labelRating.text = "⭐️\(String(format: "%.1f", game.rating))/\(Int(game.rating_top))\(dateReleased)"
        
        
        var image = UIImage(named: "empty")
        
        if let imgData = imageData {
            image = UIImage(data: imgData)
        }
        self.imgBgGame.image = image
    }
}
