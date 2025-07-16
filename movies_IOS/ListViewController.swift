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
        tableView.backgroundColor = .black
        
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
        tableView.rowHeight = 180
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail", let movieDetailVC = segue.destination as? MovieDetailViewController, let movie = sender as? Movie {
            movieDetailVC.imdbID = movie.imdbID
        }
    }
}
