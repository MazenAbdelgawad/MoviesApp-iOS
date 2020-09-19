//
//  NetWorkModel.swift
//  MoviesWatchApp
//
//  Created by Mazen Mohamed on 1/3/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import UIKit
import AFNetworking
class NetWorkModel {
 static var netWorkModel = NetWorkModel()
 var moviesList:[MovieModel] = []
 let manager = AFHTTPSessionManager()
 let imageUrl = "http://image.tmdb.org/t/p/w185"
//let urlBase = "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=2d0a12b1276288201fdd33c398e32339"
    
let urlBase = "https://api.themoviedb.org/3/discover/movie?api_key=61719a042a2b3abfbe5c5e2588b4e408"
    
 private init ()
 {

 }
    func getMovieDetails() {
    moviesList = []
    manager.get(
        urlBase,
        parameters: nil,
        success:
        {
            (operation, responseObject) in
            
            
            if let jsonObject = responseObject as?  [String : Any]
            {
                let movies = jsonObject["results"] as! [[String : Any]]
                for item in movies
               {
                let id = item["id"] as! Int
                let poster = self.imageUrl + (item["poster_path"] as! String)
                let title = item["original_title"] as! String
                let overView = item["overview"] as! String
                let rate = item["vote_average"] as! NSNumber
                let releaseDate = item["release_date"] as! String
                let popularity = item["popularity"] as! NSNumber
                let movie = MovieModel(id: id, title: title, poster: poster, overView: overView, rating: rate, releaseDate: releaseDate,popularity:popularity)
                self.moviesList.append(movie)
                
            }
                print("count net : \(self.moviesList.count)")
            }
          DispatchQueue.main.async {
           NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
          }
    },
        failure:
        {
            (operation, error) in
            print("Error: " + error.localizedDescription)
    })
        
        
    }
    
}
