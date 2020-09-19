//
//  Review.swift
//  Movies App
//
//  Created by Mazen Mohamed on 1/7/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import Foundation

class Review {
    private var author = ""
    private var content = ""
    private var id = ""
    private var url = ""
    
    init() {}
    
    init(auther: String, content: String) {
        self.author = auther
        self.content = content
    }
    
    public func setAuthor(author: String){
        self.author = author
    }
    
    public func getAuthor()->String{
        return author
    }
    
    public func setcontent(content: String){
        self.content = content
    }
    
    public func getcontent()->String{
        return content
    }
    
}
