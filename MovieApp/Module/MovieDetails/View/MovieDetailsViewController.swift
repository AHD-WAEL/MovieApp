//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Mac on 22/07/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var movieItem: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieData()
    }
    
    func setMovieData(){
        movieImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(movieItem.posterPath ?? "")"))
        movieTitleLabel.text = movieItem.originalTitle
        movieLanguageLabel.text = movieItem.originalLanguage
        movieDateLabel.text = movieItem.releaseDate
        movieDescriptionLabel.text = movieItem.overview
    }
}
