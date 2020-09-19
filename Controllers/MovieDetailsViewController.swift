//
//  MovieDetailsViewController.swift
//  swift_Lab6_MovieList_UrlSession_JSON
//
//  Created by Mazen Mohamed on 12/23/19.
//  Copyright © 2019 Mazen Mohamed. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import BTNavigationDropdownMenu
import ReachabilitySwift

class MovieDetailsViewController: UIViewController, NetworkSessionGetReviewsDataDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labYear: UILabel!
    @IBOutlet weak var rateCosmos: CosmosView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var textOverview: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    
    
    var coredata = DataBaseCoreData.coredata
    
    var reviewView : ReviewViewController!
    
    var flagFav = false
    var movies = [Movie]()
    
    var moiveDetails = Movie()
    var moiveReviews = [Review]()
    var moiveVideos = [Video]()
    
    func setmovieDetails(m : Movie)
    {
        moiveDetails = m
        print("**** \(m.getTitle())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(moiveDetails!.getTitle())
        self.tabBarController?.tabBar.isHidden = true;
        movies = coredata.fetchFav()
        for item in movies {
            if moiveDetails.getId() == item.getId()
            {
                flagFav = true
                btnFavourite.setImage(UIImage(named:"star2"), for: .normal)
                break
            }
        }
        
        labTitle.text = moiveDetails.getTitle()
        labYear.text = moiveDetails.getRelease_date()
        //labMin.text =
        textOverview.text = moiveDetails.getOverview()
        rateCosmos.rating = (moiveDetails.getVote_average()/2)
        rateCosmos.settings.updateOnTouch = false
        let urlString = "https://image.tmdb.org/t/p/w185/\(moiveDetails.getPoster_path())"
        imageView.sd_setImage(with: URL(string:urlString), placeholderImage: UIImage(named: "ioslogo.png"))
        
        //tableView.reloadData()
        print("**** didLoad")
        
        // Reachability //////////////////////////////
        let reachability = try! Reachability()
        
        reachability?.whenReachable = { reachability in
            NetworkSessionGetJSONData.delegateGetReviews = self
            NetworkSessionGetJSONData.getReviewsData(id: self.moiveDetails.getId())
            NetworkSessionGetJSONData.getVideoData(id: self.moiveDetails.getId())
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
        reachability?.whenUnreachable = { _ in
            let alert = UIAlertController.init(title: "NO Internet", message: "Can't download Reivews and Trailers as no internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {

        }
        reachability?.stopNotifier()
        ////////////////////////////////////
        
        
        reviewView = (self.storyboard?.instantiateViewController(withIdentifier: "review_view") as! ReviewViewController)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "Trailers"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return moiveVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_genre", for: indexPath)

        cell.textLabel?.text = moiveVideos[indexPath.row].name
        cell.imageView?.image = UIImage(named: "play.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let youtubeId = moiveVideos[indexPath.row].key
        var url = URL(string:"youtube://\(youtubeId!)")!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else{
            var sss = "https://www.youtube.com/watch?v=\(youtubeId!)"
            print(sss)
            if let url = URL(string: sss){
            UIApplication.shared.open(url)
            }
        }
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return moiveReviews.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_review", for: indexPath) as! ReviewCollectionViewCell
        
        //print("@@@= \(movies[indexPath.row].getTitle())")
        
        cell.usernameLable.text = moiveReviews[indexPath.row].getAuthor()
        cell.textReview.text = moiveReviews[indexPath.row].getcontent()
        //cell.imageView.image =
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        reviewView.setReview(r: moiveReviews[indexPath.row])
        self.navigationController?.pushViewController(reviewView, animated: true)
        
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    
    
    
    
    func networkSessionGetReviewData_FinishedLoading(reviews: [Review]){
        //var deletedAll = coredata.deleteAll()
        /*if(deletedAll)
         {
         movie?.removeAll()
         }*/
        
        
        /*for movie in movies {
         print("!!!= \(movie.getTitle())")
         }*/
        
        self.moiveReviews = reviews
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        //coredata.save(movies: movie!)
        //var xx = coredata.fetch()
    }
    
    
    func networkSessionGetVideoData_FinishedLoading(videos: [Video]){
        //var deletedAll = coredata.deleteAll()
        /*if(deletedAll)
         {
         movie?.removeAll()
         }*/
        
        
        /*for movie in movies {
         print("!!!= \(movie.getTitle())")
         }*/
        
        self.moiveVideos = videos
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        //coredata.save(movies: movie!)
        //var xx = coredata.fetch()
        print("VVVVVVV GetVideos")
        
    }
    
    
    @IBAction func btnFavouriteSave(_ sender: Any) {
        
        if flagFav == false
        {
            btnFavourite.setImage(UIImage(named:"star2"), for: .normal)
            coredata.saveFav(item: moiveDetails)
            flagFav = true
        }else{
            if coredata.deleteFav(movie: moiveDetails)
            {
                btnFavourite.setImage(UIImage(named:"star"), for: .normal)
                flagFav = false
                print("DDdddddddd")
            }
        }
        
    }
    
    
   
}
