//
//  HomeCollectionViewController.swift
//  Movies App
//
//  Created by Mazen Mohamed on 1/4/20.
//  Copyright © 2020 Mazen Mohamed. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift
import BTNavigationDropdownMenu
import RevealingSplashView

private let reuseIdentifier = "cell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NetworkSessionGetJSONDataDelegate {
    
    @IBOutlet weak var navOptionView: UIBarButtonItem!
    
    var movies: [Movie] = []
    var movieDetailsView : MovieDetailsViewController!
    let items = ["Most Popular", "Most Ratting"]
    var menuView : BTNavigationDropdownMenu? = nil
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=2d0a12b1276288201fdd33c398e32339")
    
    var coredata = DataBaseCoreData.coredata
    //var moviesCount:Int=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "movieslogo")!,iconInitialSize: CGSize(width: 170, height: 1200), backgroundColor: UIColor.white)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        
        
        
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        menuView = BTNavigationDropdownMenu(title: "",  items: items)
        menuView?.arrowImage = UIImage(named: "menu.png")
        menuView?.arrowTintColor = UIColor.black
        menuView?.shouldChangeTitleText = false
        self.navOptionView.customView = menuView
        menuView!.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.navigationItem.title = self!.items[indexPath]
            if indexPath == 0
            {
                NetworkSessionGetJSONData.getJSONData(url: URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=2d0a12b1276288201fdd33c398e32339")!)
            }
            if indexPath == 1
            {
                NetworkSessionGetJSONData.getJSONData(url: URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=2d0a12b1276288201fdd33c398e32339")!)
            }
        }
        
        
        // Reachability //////////////////////////////
        let reachability = try! Reachability()
        
        reachability?.whenReachable = { reachability in
            if reachability.isReachableViaWiFi {
                print("5555 is Reachable Via WiFi")
            } else {
                print("5555 Reachable is Via DataPhone")
            }
            NetworkSessionGetJSONData.delegate = self
            NetworkSessionGetJSONData.getJSONData(url: self.url!)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            //var nn = NetWorkModel.netWorkModel.getMovieDetails();
        }
        
        reachability?.whenUnreachable = { _ in
            print("5555 Unreachable") //Work
            
            self.getDataFromCoredata()
            DispatchQueue.main.async {
                self.menuView?.isUserInteractionEnabled = false
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            //print("Unable to start notifier")
        }
        reachability?.stopNotifier()
        ////////////////////////////////////
    }

    
    override func viewWillAppear(_ animated: Bool) {
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
       var xc = movies.count
        return movies.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellview", for: indexPath) as! CollectionViewCell
    
        //print("@@@= \(movies[indexPath.row].getTitle())")
        
        let urlString = "https://image.tmdb.org/t/p/w185/\(movies[indexPath.row].getPoster_path())"
        cell.imageview.sd_setImage(with: URL(string:urlString), placeholderImage: UIImage(named: "ioslogo.png"))
        
        var ind = indexPath.row
        return cell
    }

    
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        movieDetailsView.setmovieDetails(m: movies[indexPath.row])
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
        
     return true
     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width) / 2)
        let height = ((collectionView.frame.height - 120) / 2)
        print("cell width : \(width)")
        print("cell height : \(height)")
        return CGSize(width: width, height: height)
    }
    
    
    
    func networkSessionGetJSONData_FinishedLoading(movies : [Movie]) {
        let deletedAll = coredata.deleteAll()
        if(deletedAll)
        {
            self.movies.removeAll()
        }
        
        self.movies = movies
        /*for item in movies {
            self.movies.append(item)
            self.movies.append(item)
        }
        for i in 1..<200 {
            self.movies.append(movies[0])
            self.movies.append(movies[1])
        }
        var xx = self.movies*/
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        coredata.save(movies: movies)
    }
    
    
    
    func getDataFromCoredata()
    {
        movies = coredata.fetch()
        if movies.count == 0
        {
            let alert = UIAlertController.init(title: "NO Internet", message: "No internet connection and No movies Saved, Please open Internet and reopen tha App", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    /*
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        if indexPath.row == movies.count-4
        {
            print("Dispaly END = \(indexPath.row)")
            //movies.append(movies[0])
            for i in 0..<20 {
                self.movies.append(movies[i])
                self.movies.append(movies[i])
            }
            print("count= \(movies.count)")
            collectionView.reloadData()
        }
    }
    */
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//    targetContentOffset.pointee = scrollView.contentOffset
//    let pageWidth:Float = Float(self.view.bounds.width)
//    let minSpace:Float = 10.0
//    var cellToSwipe:Double = Double(Float((scrollView.contentOffset.x))/Float((pageWidth+minSpace))) + Double(0.5)
//    if cellToSwipe < 0 {
//    cellToSwipe = 0
//    } else if cellToSwipe >= Double(self.articles.count) {
//    cellToSwipe = Double(self.articles.count) - Double(1)
//    }
//    let indexPath:IndexPath = IndexPath(row: Int(cellToSwipe), section:0)
//    self.collectionView.scrollToItem(at:indexPath, at: UICollectionViewScrollPosition.left, animated: true)
//
//
//    }
 
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
