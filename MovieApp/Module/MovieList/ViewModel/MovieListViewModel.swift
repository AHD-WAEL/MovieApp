//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Mac on 22/07/2023.
//

import Foundation

class MovieListViewModel{
    var bindResultToViewController: (()->()) = {}
    var bindMovieDetails : (() -> ()) = {}
    var netWorkingDataSource: NetworkProtocol!
    
    init(netWorkingDataSource: NetworkProtocol) {
        self.netWorkingDataSource = netWorkingDataSource
    }
    
    var result: [Result]? {
        didSet{
            self.bindResultToViewController()
        }
    }
    
    var movieDetails : [Result]? {
        didSet {
            bindMovieDetails()
        }
    }
    
    func getItems(){
        netWorkingDataSource.getMovieListData{ [weak self] (response : Response?) in
            self?.result = response?.results
        }
    }
    
    func insertIntoCoreData(movie: Result){
        CDManager.instance.insert(movie: movie)
    }
    
    func deleteFromCoreData(){
        CDManager.instance.deleteAll()
    }

    func getMovieDetailsFromCoreData(){
        self.movieDetails = CDManager.instance.fetch()
    }
}
