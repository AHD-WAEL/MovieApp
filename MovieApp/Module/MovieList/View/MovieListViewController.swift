//
//  ViewController.swift
//  MovieApp
//
//  Created by Mac on 22/07/2023.
//

import UIKit
import Kingfisher

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movieViewModel: MovieListViewModel!
    var movie: [Result] = []
    var timer = Timer()
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieViewModel = MovieListViewModel(netWorkingDataSource: Network())
        
        callingData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 14400, repeats: true, block: { _ in
            self.callingData()
        })
        
        let layout = UICollectionViewCompositionalLayout{ index, environment in
            return self.MovieCollectionImage()
        }
        movieCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func callingData(){
        self.movieViewModel.deleteFromCoreData()
        insertInCore()
    }
    
    func insertInCore(){
        self.movieViewModel.bindResultToViewController = {[weak self] in
            for movieIndex in self!.movieViewModel.result!.indices{
                self?.movieViewModel.insertIntoCoreData(movie: (self?.movieViewModel.result![movieIndex])!)
            }
            self?.showDataFromCore()
        }
        self.movieViewModel.getItems()
    }
    
    func showDataFromCore(){
        movieViewModel.bindMovieDetails = {[weak self] in
            self?.movie = self?.movieViewModel.movieDetails ?? []
            self?.movieCollectionView.reloadData()
        }
        movieViewModel.getMovieDetailsFromCoreData()
    }
    
    func MovieCollectionImage() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize (widthDimension:
                .fractionalWidth(1), heightDimension: .fractionalHeight (1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize (widthDimension:
                .fractionalWidth(1), heightDimension: .absolute (700))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                        groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs ((item.frame.minX  - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max (maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.img.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(movie[indexPath.row].posterPath ?? "")"))
        
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 5.0
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "details") as! MovieDetailsViewController
        details.movieItem = movie[indexPath.row]
        navigationController?.pushViewController(details, animated: true)
    }
}
