//
//  Movie.swift
//  swift_Lab6_MovieList_UrlSession_JSON
//
//  Created by Mazen Mohamed on 12/23/19.
//  Copyright © 2019 Mazen Mohamed. All rights reserved.
//

import Foundation

class Movie {
    
    private var id : Int = 0
    private var title : String = ""
    private var original_title : String = ""
    private var poster_path : String = ""
    private var vote_average : Double = 0.0
    private var release_date: String = ""
    private var overview : String = ""
    
    
    //var genre_ids : [Int] = [0]
/*
    let popularity : Double?
    let video : Bool?
    let vote_count : Int?
    let backdrop_path : String?
    let adult : Bool?
*/
    
    
    
    init(){}
    
    init(id:Int, title:String, poster_path:String, original_title:String, vote_average:Double, release_date:String, overview:String){
        self.title = title
        self.poster_path = poster_path
        self.id = id
        self.original_title = original_title
        self.vote_average = vote_average
        self.release_date = release_date
        self.overview = overview
    }
    
    func setId(i: Int){ id = i}
    func setTitle(s: String){ title = s }
    func setPoster_path(s: String){ poster_path = s }
    func setVote_average(f: Double){ vote_average = f }
    func setRelease_date(s: String){ release_date = s }
    func setOriginal_title(s: String){ original_title = s }
    func setOverview(s: String){ overview = s }
    
    func getId()->Int{return id}
    func getTitle()->String{return title}
    func getPoster_path()->String{return poster_path}
    func getVote_average()->Double{return vote_average}
    func getRelease_date()->String{return release_date}
    func getOriginal_title()-> String{return original_title}
    func getOverview()->String{return overview}
    
}
