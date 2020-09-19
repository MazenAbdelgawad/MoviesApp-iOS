//
//  FavouriteCollectionViewController.swift
//  Movies App
//
//  Created by Mazen Mohamed on 1/8/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift
import BTNavigationDropdownMenu
import RevealingSplashView

private let reuseIdentifier = "cellFav"

class FavouriteCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width) / 2)
        let height = ((collectionView.frame.height - 120) / 2)
        print("cell width : \(width)")
        print("cell height : \(height)")
        return CGSize(width: width, height: height)
    }
    
    var movies: [Movie] = []
    var movieDetailsView : MovieDetailsViewController!
    //let items = ["Most Popular", "Most Ratting"]
    //var menuView : BTNavigationDropdownMenu? = nil
    //let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=2d0a12b1276288201fdd33c398e32339")
    
    var coredata = DataBaseCoreData.coredata
    //var moviesCount:Int=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getDataFromCoredata()
        //print("OOOOOPEN")
        
        movieDetailsView = (self.storyboard?.instantiateViewController(withIdentifier: "viewdetails") as! MovieDetailsViewController)
        
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellviewFav", for: indexPath) as! CollectionViewCell
        
        //print("@@@= \(movies[indexPath.row].getTitle())")
        
        let urlString = "https://image.tmdb.org/t/p/w185/\(movies[indexPath.row].getPoster_path())"
        cell.imageview.sd_setImage(with: URL(string:urlString), placeholderImage: UIImage(named: "ioslogo.png"))
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        movieDetailsView.setmovieDetails(m: movies[indexPath.row])
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
        
        return true
    }
    
    
    
    func getDataFromCoredata()
    {
        movies = coredata.fetchFav()
        //var x =  coredata.fetch()
        self.collectionView.reloadData()
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
