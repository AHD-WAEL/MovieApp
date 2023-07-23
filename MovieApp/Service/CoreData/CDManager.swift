//
//  CDManager.swift
//  MovieApp
//
//  Created by Mac on 23/07/2023.
//

import Foundation
import UIKit
import CoreData

class CDManager{
    static let instance = CDManager()
    var appDelegate: AppDelegate?
    var manager: NSManagedObjectContext?
    var entity: NSEntityDescription?
    
    private init(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        manager = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: manager!)
    }
    
    func insert(movie: Result){
        let movieDb = NSManagedObject(entity: entity!, insertInto: manager)
        
        movieDb.setValue(movie.posterPath, forKey: "posterPath")
        movieDb.setValue(movie.originalTitle, forKey: "title")
        movieDb.setValue(movie.originalLanguage, forKey: "originalLanguage")
        movieDb.setValue(movie.releaseDate, forKey: "releaseDate")
        movieDb.setValue(movie.overview, forKey: "overview")
        
        do{
            try manager?.save()
            print("saved!")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [Result]{
        var retrivedMovies = [Result]()
        var MovieArr: [NSManagedObject]?
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        
        do{
            MovieArr = try manager?.fetch(fetch)
            for item in MovieArr!{
                var MovieItem = Result(adult: nil, backdropPath: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
                MovieItem.posterPath = item.value(forKey: "posterPath") as? String
                MovieItem.originalTitle = item.value(forKey: "title") as? String
                MovieItem.originalLanguage = item.value(forKey: "originalLanguage") as? String
                MovieItem.releaseDate = item.value(forKey: "releaseDate") as? String
                MovieItem.overview = item.value(forKey: "overview") as? String
                
                retrivedMovies.append(MovieItem)
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
        return retrivedMovies
    }
    
    func deleteAll(){
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        do{
            let moviesArr = try manager?.fetch(fetch)
            for m in moviesArr!{
                manager?.delete(m)
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
        do{
            try manager?.save()
            print("deleted all!")
        }catch let error{
            print(error.localizedDescription)
        }
    }
}
