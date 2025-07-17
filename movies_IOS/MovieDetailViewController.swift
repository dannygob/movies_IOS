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
        
        // Style the poster image view
        posterImageView.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0) // Dark Red
        posterImageView.layer.borderColor = UIColor.gray.cgColor
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        // Create a container view that acts as a full-screen border
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .clear
        borderView.layer.borderColor = UIColor.gray.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
        view.addSubview(borderView)

        // Create a stack view to hold the detail labels
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        view.addSubview(stackView)
        
        // --- REORDER & STYLE LABELS IN STACK VIEW ---
        let orderedLabels: [UILabel] = [plotLabel, yearLabel, runtimeLabel, directorLabel, genreLabel, countryLabel, typeLabel, ratedLabel, rottenTomatoesLabel]
        
        orderedLabels.forEach { label in
            label.removeFromSuperview() // Remove from storyboard hierarchy
            label.textColor = .white
            label.textAlignment = .left
            label.numberOfLines = 0 // Allow text wrapping
            stackView.addArrangedSubview(label)
        }
        
        // Style and align the main title label
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // --- LAYOUT CONSTRAINTS ---
        NSLayoutConstraint.activate([
            // Border constraints to frame the entire screen
            borderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            borderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            // Title label constraints (below poster, centered)
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Stack view constraints (below title)
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: borderView.bottomAnchor, constant: -20)
        ])
        
        // --- LOAD DATA ---
        guard let imdbID = imdbID else { return }
        
        APIManager.shared.getMovieDetails(imdbID: imdbID) { [weak self] movieDetail in
            DispatchQueue.main.async {
                if let movieDetail = movieDetail {
                    self?.titleLabel.text = movieDetail.Title
                    self?.plotLabel.text = "Synopsis: \(movieDetail.Plot)"
                    self?.yearLabel.text = "Year: \(movieDetail.Year)"
                    self?.runtimeLabel.text = "Duration: \(movieDetail.Runtime)"
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
