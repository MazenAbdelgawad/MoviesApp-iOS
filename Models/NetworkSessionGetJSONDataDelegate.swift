//
//  NetworkSessionGetJSONDataDelegate.swift
//  swift_Lab6_MovieList_UrlSession_JSON
//
//  Created by Mazen Mohamed on 12/24/19.
//  Copyright © 2019 Mazen Mohamed. All rights reserved.
//

import Foundation

protocol NetworkSessionGetJSONDataDelegate {
    
    func networkSessionGetJSONData_FinishedLoading(movies : [Movie])
    
}
