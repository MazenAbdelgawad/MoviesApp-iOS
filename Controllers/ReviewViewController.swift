//
//  ReviewViewController.swift
//  Movies App
//
//  Created by Mazen Mohamed on 1/7/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var authorLable: UILabel!
    @IBOutlet weak var contentText: UITextView!
    var review = Review()
    
    func setReview(r: Review){
        review = r
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        authorLable.text = review.getAuthor()
        contentText.text = review.getcontent()
    }
    
    
    

}
