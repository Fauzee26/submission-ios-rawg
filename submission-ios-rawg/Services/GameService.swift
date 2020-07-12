//
//  GameService.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func didUpdateGames(_ service: GameService, _ games: [GameModel])
    func didFailure(_ error: Error)
}

struct GameService {
    let mainURL = "https://api.rawg.io/api/games"
    var delegate: GameDelegate?
        
    func getAllGames() {
        if let url = URL(string: mainURL) {
            performRequest(with: url)
        }
    }
    
    func getGames(baseOn order: String, _ isAscending: Bool) {
        let isAsc = isAscending ? "-" : ""
        let addUrl = mainURL + "?ordering=" + isAsc + order
        
        print(addUrl)
        if let url = URL(string: addUrl) {
            performRequest(with: url)
        }
    }
    
    fileprivate func performRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailure(error!)
                return
            }
            
            if let data = data {
                if let arrayGames = self.parseJSON(data) {
                    self.delegate?.didUpdateGames(self, arrayGames)
                }
            }
        }
        
        task.resume()
    }
    
    fileprivate func parseJSON(_ data: Data) -> [GameModel]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(GameModels.self, from: data)
            
            return decodedData.results
        } catch {
            delegate?.didFailure(error)
            return nil
        }
    }
}
