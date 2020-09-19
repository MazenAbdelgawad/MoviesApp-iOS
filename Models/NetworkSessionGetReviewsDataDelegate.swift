//
//  NetworkSessionGetReviewsDataDelegate.swift
//  Movies App
//
//  Created by Mazen Mohamed on 1/7/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import Foundation

protocol NetworkSessionGetReviewsDataDelegate {
    
    func networkSessionGetReviewData_FinishedLoading(reviews: [Review])
    
    func networkSessionGetVideoData_FinishedLoading(videos: [Video])
    
}
