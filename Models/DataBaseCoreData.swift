//
//  DataBaseCoreData.swift
//  swift_Lab6_MovieList_UrlSession_JSON
//
//  Created by Mazen Mohamed on 12/24/19.
//  Copyright © 2019 Mazen Mohamed. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBaseCoreData{
    static var coredata = DataBaseCoreData()
    private init() {}
    
    
        func save(movies: [Movie]){
            if movies.count != 0
            {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Moviecoredata", in: managedContext)
            for item in movies
            {
                if item == nil
                {
                    break
                }
                let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
                movie.setValue(item.getTitle(), forKey: "title")
                movie.setValue(item.getOverview() , forKey: "overview")
                movie.setValue(item.getPoster_path(), forKey: "poster_path")
                movie.setValue(item.getRelease_date(), forKey: "release_date")
                movie.setValue(item.getOriginal_title(), forKey: "original_title")
                movie.setValue(item.getId(), forKey: "id")
                movie.setValue(item.getVote_average(), forKey: "vote_average")
            
                do{
                    try managedContext.save()
                }
                catch let error as NSError
                {
                    print("Error Can't save CoreData = \(error)")
                }
            }
            print("QQ Saved")
            }else{
                print("QQ NOTTTSaved")
            }
        }
    


  
    func fetch() -> [Movie] {
        var movies : [Movie]? = []
        var items : [NSManagedObject]?

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Moviecoredata")
        //let predicate = NSPredicate(format: "title == %@", "Movie 1")
        //fetchRequest.predicate=predicate

        do{
            items = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error Can't Fetch CoreData = \(error)")
        }
        //var item = items!.count
        for i in 0..<items!.count
        {
            var m = Movie()
            m.setTitle(s: items![i].value(forKey: "title") as! String)
            m.setOverview(s: items![i].value(forKey: "overview") as! String)
            m.setPoster_path(s: items![i].value(forKey: "Poster_path") as! String)
            m.setRelease_date(s: items![i].value(forKey: "release_date") as! String)
            m.setOriginal_title(s: items![i].value(forKey: "original_title") as! String)
            m.setId(i: items![i].value(forKey: "id") as! Int)
            m.setVote_average(f: items![i].value(forKey: "vote_average") as! Double)
            movies?.append(m)
        }
        
        print("QQ GET")
        return movies!
    }

    
    
    
    func deleteAll() -> Bool{
        var flag = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Moviecoredata")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let request = try managedContext.fetch(fetchRequest)
            print("@@@@@= \(request.count)")
            for managedObject in request
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                flag = true
            }
        } catch  let error as NSError{
            print(error)
        }
        
        do{
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Error Can't save CoreData = \(error)")
        }
        
        print("QQ DELTETALL")
        return flag
    }
   
    
    /////////////////////////////// Favourate /////////////////////////////
    
    func saveFav(item: Movie){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MoviecoredataFav", in: managedContext)

            let movie = NSManagedObject(entity: entity!, insertInto: managedContext)
            movie.setValue(item.getTitle(), forKey: "title")
            movie.setValue(item.getOverview() , forKey: "overview")
            movie.setValue(item.getPoster_path(), forKey: "poster_path")
            movie.setValue(item.getRelease_date(), forKey: "release_date")
            movie.setValue(item.getOriginal_title(), forKey: "original_title")
            movie.setValue(item.getId(), forKey: "id")
            movie.setValue(item.getVote_average(), forKey: "vote_average")
            
            do{
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Error Can't save CoreData = \(error)")
            }
        
        print("QQ Saved Fav")
    }
    
    
    
    
    func fetchFav() -> [Movie] {
        var movies : [Movie]? = []
        var items : [NSManagedObject]?
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoviecoredataFav")
        //let predicate = NSPredicate(format: "title == %@", "Movie 1")
        //fetchRequest.predicate=predicate
        
        do{
            items = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error Can't Fetch CoreData = \(error)")
        }
        //var item = items!.count
        for i in 0..<items!.count
        {
            var m = Movie()
            m.setTitle(s: items![i].value(forKey: "title") as! String)
            m.setOverview(s: items![i].value(forKey: "overview") as! String)
            m.setPoster_path(s: items![i].value(forKey: "Poster_path") as! String)
            m.setRelease_date(s: items![i].value(forKey: "release_date") as! String)
            m.setOriginal_title(s: items![i].value(forKey: "original_title") as! String)
            m.setId(i: items![i].value(forKey: "id") as! Int)
            m.setVote_average(f: items![i].value(forKey: "vote_average") as! Double)
            movies?.append(m)
        }
        
        print("QQ GET Fav")
        return movies!
    }
    
    
    
    
    func deleteAllFav() -> Bool{
        var flag = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoviecoredataFav")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let request = try managedContext.fetch(fetchRequest)
            for managedObject in request
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                flag = true
            }
        } catch  let error as NSError{
            print(error)
        }
        
        print("QQ DELTETALL Fav")
        return flag
    }
    
    
    func deleteFav(movie: Movie) -> Bool {
        var flag = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviecoredataFav")
        fetchrequest.predicate = NSPredicate(format: "id = %@", String(movie.getId()) as CVarArg)
        let result = try? managedContext.fetch(fetchrequest)
        let resultData = result as! [NSManagedObject]
        for object in resultData {
            managedContext.delete(object)
        }
        do
        {
            try managedContext.save()
            flag = true
        } catch let error as NSError {
            print(error)
        }
        
        print("QQ DELTET Fav")
        return flag
    }
    
}

