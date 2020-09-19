//
//  NetworkSessionGetJSONData.swift
//  swift_Lab6_MovieList_UrlSession_JSON
//
//  Created by Mazen Mohamed on 12/24/19.
//  Copyright © 2019 Mazen Mohamed. All rights reserved.
//

import Foundation
import AFNetworking

class NetworkSessionGetJSONData {
    
    static var delegate : NetworkSessionGetJSONDataDelegate!
    static var delegateGetReviews : NetworkSessionGetReviewsDataDelegate!
    
 /*   static func getJSONDataNotWork() {
        
        var json : [Dictionary<String,Any>]?
        
        let manager = AFHTTPSessionManager()
        manager.get("http://api.androidhive.info/json/movies.json", parameters: nil, success: { (operation, responseObject) in
            if let jsonObject = responseObject as! [Dictionary<String,Any>]?
            {
               json = jsonObject
                delegate.networkSessionGetJSONData_FinishedLoading(json: json)
            }
            
        }, failure: {
            (operation , error) in
            print("@@@ error= \(error.localizedDescription)")
        })
        
    }*/
    
    
    static func getJSONData(url: URL) {
        var movies : [Movie] = []
    
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
        
        let requset = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requset)
        { ( data, response, error) in
            do{
                var jsonRsponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                
                var jsonArray = jsonRsponse!["results"] as! [[String:Any]]
                
                for i in 0..<jsonArray.count
                {
                    var movietemp = Movie()
                    var dic : Dictionary<String,Any>?
                    dic = jsonArray[i]
                    movietemp.setTitle(s:dic!["title"] as! String)
                    movietemp.setPoster_path(s:dic!["poster_path"] as! String)
                    movietemp.setId(i: dic!["id"] as! Int)
                    movietemp.setOverview(s: dic!["overview"] as! String)
                    movietemp.setRelease_date(s: dic!["release_date"] as! String)
                    movietemp.setOriginal_title(s: dic!["original_title"] as! String)
                    movietemp.setVote_average(f: dic!["vote_average"] as! Double)
                    movies.append(movietemp)
                }
                
                //DispatchQueue.main.async {
                delegate.networkSessionGetJSONData_FinishedLoading(movies : movies)
                //}
                
            }catch{
                print("Error,,NetworkSessionGetJSONData = \(error)")
            }
        }.resume()
    }

    
    
    
    static func getReviewsData(id: Int) {
        var reviews : [Review] = []
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
        
        var url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=2d0a12b1276288201fdd33c398e32339")
        //var rrr = url?.absoluteString
        
        let requset = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requset)
        { ( data, response, error) in
            do{
                var jsonRsponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                
                var jsonArray = jsonRsponse!["results"] as! [[String:Any]]
                
                for i in 0..<jsonArray.count
                {
                    var reviewtemp = Review()
                    var dic : Dictionary<String,Any>?
                    dic = jsonArray[i]
                    reviewtemp.setAuthor(author: dic!["author"] as! String)
                    reviewtemp.setcontent(content: dic!["content"] as! String)
                    //reviewtemp.setId(i: dic!["id"] as! Int)
                    //reviewtemp.setOverview(s: dic!["overview"] as! String)
                    
                    reviews.append(reviewtemp)
                }
                
                DispatchQueue.main.async {
                    delegateGetReviews.networkSessionGetReviewData_FinishedLoading(reviews: reviews)
                }
                
            }catch{
                print("Error,,NetworkSessionGetJSONData = \(error)")
            }
            }.resume()
        
        //var rr = reviews
    }
    
    
    static func getVideoData(id: Int) {
        var videos : [Video] = []
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=2d0a12b1276288201fdd33c398e32339")

        //var rrr = url?.absoluteString
        
        let requset = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requset)
        { ( data, response, error) in
            do{
                var jsonRsponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String,Any>
                
                var jsonArray = jsonRsponse!["results"] as! [[String:Any]]
                
                for i in 0..<jsonArray.count
                {
                    var videotemp = Video()
                    var dic : Dictionary<String,Any>?
                    dic = jsonArray[i]
                    videotemp.name = dic!["name"] as! String
                    videotemp.key =  dic!["key"] as! String
                    
                    videos.append(videotemp)
                }
                
                DispatchQueue.main.async {
                    delegateGetReviews.networkSessionGetVideoData_FinishedLoading(videos: videos)
                }
                
            }catch{
                print("Error,,NetworkSessionGetJSONData = \(error)")
            }
            }.resume()
        
        //var rr = reviews
    }
    
    
}
