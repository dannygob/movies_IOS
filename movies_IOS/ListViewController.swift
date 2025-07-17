//
//  ViewController.swift
//  movies_IOS
//
//  Created by Tardes on 16/7/25.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        // Add watermark
        let watermark = UIImageView(image: UIImage(named: "Placeholder"))
        watermark.contentMode = .scaleAspectFit
        watermark.alpha = 0.1
        watermark.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(watermark, at: 0)
        
        NSLayoutConstraint.activate([
            watermark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watermark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            watermark.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            watermark.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        tableView.backgroundColor = .clear
        
        // Style the search bar for a permanent dark theme
        searchBar.barStyle = .black
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        
        if let placeholder = searchBar.searchTextField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        // Change search icon color to white
        if let searchIcon = searchBar.searchTextField.leftView as? UIImageView {
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
            searchIcon.tintColor = .white
        }
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        // Cargar una cadena aleatoria de 3 letras al iniciar
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString = ""
        for _ in 0..<3 {
            let randomLetter = alphabet.randomElement()!
            randomString.append(randomLetter)
        }
        searchBar.text = randomString
        searchMovies(query: randomString)
    }
    
    func searchMovies(query: String) {
        APIManager.shared.searchMovies(query: query) { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            
            let group = DispatchGroup()
            var detailedMovies = movies
            
            for i in 0..<detailedMovies.count {
                group.enter()
                APIManager.shared.getMovieDetails(imdbID: detailedMovies[i].imdbID) { movieDetail in
                    detailedMovies[i].details = movieDetail
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.movies = detailedMovies
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchMovies(query: query)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.section]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.section]
        performSegue(withIdentifier: "showMovieDetail", sender: selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5 // Espacio entre celdas
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .darkGray
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail", let movieDetailVC = segue.destination as? MovieDetailViewController, let movie = sender as? Movie {
            movieDetailVC.imdbID = movie.imdbID
        }
    }
}
