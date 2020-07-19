//
//  DetailVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var game: GameModel?
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var labelReleasedDate: UILabel!
    @IBOutlet weak var labelPlaytime: UILabel!
    @IBOutlet weak var labelRatingTop: UILabel!
    @IBOutlet weak var labelRatingCount: UILabel!
    @IBOutlet weak var labelPlatforms: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var labelMetacritics: UILabel!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    
    var service = CoreDataService.self
    override func viewDidLoad() {
        super.viewDidLoad()
        title = game?.name
        
        if service.isFavorite(game!) == true {
            btnFavorite.image = UIImage(systemName: "star.fill")
        } else {
            btnFavorite.image = UIImage(systemName: "star")
        }
        
        viewBg.setGradientBackground(colorTop: .clear, colorBottom: UIColor(named: "grey")!)
        labelReleasedDate.text = game?.released?.convertToDate() ?? ""
        labelPlaytime.text = " · AVERAGE PLAYTIME: \(game!.playtime) HOURS"
        labelRatingCount.text = "\(String(describing: game!.reviews_count)) RATINGS"
        
        print("rating: ", game!.ratings[0])
        let rating = (game?.ratings.count)! > 0 ? "\"\(game!.ratings[0].title.capitalizingFirstLetter())\"" : ""
        labelRatingTop.text = rating
        
        var platformsName = [String]()
        game?.platforms.forEach({ (platformArray) in
            platformsName.append(platformArray.platform.name)
        })
        labelPlatforms.text = platformsName.joined(separator: ", ")
        
        var genresName = [String]()
        game?.genres.forEach({ (genre) in
            genresName.append(genre.name)
        })
        
        labelGenre.text = genresName.joined(separator: ", ")
        
        labelMetacritics.layer.borderWidth = 0.5
        labelMetacritics.layer.cornerRadius = 5
        labelMetacritics.text = "\(String(describing: game!.metacritic ?? 0))"
        
        let metascore = game?.metacritic ?? 0
        if metascore > 66 {
            labelMetacritics.layer.borderColor = UIColor.systemGreen.cgColor
            labelMetacritics.textColor = UIColor.systemGreen
        } else if metascore > 40 {
            labelMetacritics.layer.borderColor = UIColor.yellow.cgColor
            labelMetacritics.textColor = UIColor.yellow
        } else {
            labelMetacritics.layer.borderColor = UIColor.red.cgColor
            labelMetacritics.textColor = UIColor.red
        }
        
        if let gameBg = game?.background_image {
            let url = URL(string: gameBg)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.imgGame.image = image
            }
        }
    }
    
    @IBAction func btnFavoritePressed(_ sender: Any) {
        if service.isFavorite(game!) == true {
            service.deleteFromFavorite(game!)
            btnFavorite.image = UIImage(systemName: "star")
        } else {
            service.saveToFavorite(game!)
            btnFavorite.image = UIImage(systemName: "star.fill")
        }
    }
}
