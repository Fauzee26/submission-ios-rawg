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
    
    func setupUI(game: GameModel) {
        labelGame.text = game.name
        labelRating.text = "⭐️\(String(format: "%.1f", game.rating))/\(Int(game.rating_top))"
        
        if let gameBg = game.background_image {
            let url = URL(string: gameBg)
            let data = try? Data(contentsOf: url!)

            if let imageData = data {
                let image = UIImage(data: imageData)
                self.imgBgGame.image = image
            }
        }
    }
}
