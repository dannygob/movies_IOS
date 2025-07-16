//
//  MovieDetailViewController.swift
//  movies_IOS
//
//  Created by Tardes on 16/7/25.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var imdbID: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var rottenTomatoesLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        titleLabel.textColor = .white
        yearLabel.textColor = .white
        plotLabel.textColor = .white
        runtimeLabel.textColor = .white
        directorLabel.textColor = .white
        genreLabel.textColor = .white
        countryLabel.textColor = .white
        
        guard let imdbID = imdbID else { return }
        
        APIManager.shared.getMovieDetails(imdbID: imdbID) { [weak self] movieDetail in
            DispatchQueue.main.async {
                if let movieDetail = movieDetail {
                    self?.titleLabel.text = movieDetail.Title
                    self?.yearLabel.text = movieDetail.Year
                    self?.plotLabel.text = movieDetail.Plot
                    self?.runtimeLabel.text = movieDetail.Runtime
                    self?.directorLabel.text = "Director: \(movieDetail.Director)"
                    self?.genreLabel.text = "Genre: \(movieDetail.Genre)"
                    self?.countryLabel.text = "Country: \(movieDetail.Country)"
                    self?.typeLabel.text = "Type: \(movieDetail.Type)"
                    self?.ratedLabel.text = "Rated: \(movieDetail.Rated)"
                    
                    if let rottenTomatoesRating = movieDetail.Ratings.first(where: { $0.Source == "Rotten Tomatoes" }) {
                        self?.rottenTomatoesLabel.text = "Rotten Tomatoes: \(rottenTomatoesRating.Value)"
                    } else {
                        self?.rottenTomatoesLabel.text = "Rotten Tomatoes: N/A"
                    }
                    
                    self?.posterImageView.loadImage(from: movieDetail.Poster)
                }
            }
        }
    }
}
