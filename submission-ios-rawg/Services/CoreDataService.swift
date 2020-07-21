//
//  CoreDataService.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 18/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static func getFavoriteGames() -> [GameModel] {
        var gameModels = [GameModel]()
        
        if let appDelegate = appDelegate {
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: K.Core.entityGame)
            
            do {
                let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                result?.forEach { gameModel in
                    
                    var ratings = [Rating]()
                    let ratingsData = gameModel.value(forKey: K.Core.rating_title) as! String
                    let ratingsArray = ratingsData.components(separatedBy: ", ")
                    ratingsArray.forEach { (strRating) in
                        let rating = Rating(title: strRating)
                        ratings.append(rating)
                    }
                    
                    let platformsData = gameModel.value(forKey: K.Core.platforms_name) as! String
                    let platformsArray = platformsData.components(separatedBy: ", ")
                    var platforms = [Platforms]()
                    platformsArray.forEach { (name) in
                        let platform = Platform(name: name)
                        let platformsTop = Platforms(platform: platform)
                        platforms.append(platformsTop)
                    }
                    
                    let strGenre = gameModel.value(forKey: K.Core.genre_name) as! String
                    let genreStrToArray = strGenre.components(separatedBy: ", ")
                    var genreArray = [Genre]()
                    genreStrToArray.forEach { (genreName) in
                        let genre = Genre(name: genreName)
                        genreArray.append(genre)
                    }
                        
                    gameModels.append(
                        GameModel(id: gameModel.value(forKey: K.Core.id) as! Int,
                                  name: gameModel.value(forKey: K.Core.name) as? String,
                                  released: gameModel.value(forKey: K.Core.released) as? String,
                                  background_image: gameModel.value(forKey: K.Core.background_image) as? String,
                                  rating: gameModel.value(forKey: K.Core.rating) as! Double,
                                  rating_top: gameModel.value(forKey: K.Core.rating_top) as! Double,
                                  ratings_count: gameModel.value(forKey: K.Core.ratings_count) as! Int,
                                  playtime: gameModel.value(forKey: K.Core.playtime) as! Int,
                                  reviews_count: gameModel.value(forKey: K.Core.reviews_count) as! Int,
                                  ratings: ratings,
                                  platforms: platforms,
                                  genres: genreArray,
                                  metacritic: gameModel.value(forKey: K.Core.metacritic) as? Int)
                    )
                }
            } catch let err {
                print("Failed to load data, \(err)")
            }
        }
        return gameModels
    }
    
    static func saveToFavorite(_ model: GameModel) {
        if let appDelegate = appDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: K.Core.entityGame, in: managedContext) else {return}
            
            var arrayRating = [String]()
            var strRating = ""
            model.ratings.forEach { (rating) in
                arrayRating.append(rating.title)
            }
            strRating = arrayRating.joined(separator: ", ")
            
            var arrayGenre = [String]()
            var strGenre = ""
            model.genres.forEach { (genre) in
                arrayGenre.append(genre.name)
            }
            strGenre = arrayGenre.joined(separator: ", ")
            
            var arrayPlatform = [String]()
            var strPlatform = ""
            model.platforms.forEach { (platform) in
                arrayPlatform.append(platform.platform.name)
            }
            strPlatform = arrayPlatform.joined(separator: ", ")
            
            let insert = NSManagedObject(entity: entity, insertInto: managedContext)
            insert.setValue(model.id, forKey: K.Core.id)
            insert.setValue(model.name, forKey: K.Core.name)
            insert.setValue(model.released, forKey: K.Core.released)
            insert.setValue(model.background_image, forKey: K.Core.background_image)
            insert.setValue(model.rating, forKey: K.Core.rating)
            insert.setValue(model.rating_top, forKey: K.Core.rating_top)
            insert.setValue(model.ratings_count, forKey: K.Core.ratings_count)
            insert.setValue(model.playtime, forKey: K.Core.playtime)
            insert.setValue(model.reviews_count, forKey: K.Core.reviews_count)
            insert.setValue(strRating, forKey: K.Core.rating_title)
            insert.setValue(strPlatform, forKey: K.Core.platforms_name)
            insert.setValue(strGenre, forKey: K.Core.genre_name)
            insert.setValue(model.metacritic, forKey: K.Core.metacritic)
            
            do {
                try managedContext.save()
            } catch let err {
                print("Failed to save data, \(err)")
            }
        }
    }
    
    static func isFavorite(_ model: GameModel) -> Bool {
        var isFavorite = false
        
        if let appDelegate = appDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: K.Core.entityGame)
            fetchRequest.predicate = NSPredicate(format: "\(K.Core.id) = %ld", model.id)
            do {
                let fetch = try managedContext.fetch(fetchRequest)

                if !fetch.isEmpty {
                    isFavorite = true
                }
            } catch let err {
                print("error check isFavorite: ", err)
            }
        }
        
        return isFavorite
    }
    
    static func deleteFromFavorite(_ model: GameModel) {
        if let appDelegate = appDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: K.Core.entityGame)
            fetchRequest.predicate = NSPredicate(format: "\(K.Core.id) = %ld", model.id)
            
            do {
                let fetch = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                
                if fetch.isEmpty {return}
                
                for f in fetch {
                    managedContext.delete(f)
                }
                try managedContext.save()
            } catch let err {
                print("error check isFavorite: ", err)
            }
        }
    }
}
