//
//  APIManager.swift
//  movies_IOS
//
//  Created by Tardes on 16/7/25.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private let apiKey = "6ea7eac4"  // Coloca tu clave de API de OMDB aquí
    
    func searchMovies(query: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "https://www.omdbapi.com/?s=\(query)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                let decoder = JSONDecoder()
                do {
                    let jsonResponse = try decoder.decode(OMDBResponse.self, from: data)
                    completion(jsonResponse.Search)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func getMovieDetails(imdbID: String, completion: @escaping (MovieDetail?) -> Void) {
        let urlString = "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                let decoder = JSONDecoder()
                do {
                    let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                    completion(movieDetail)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

// Respuesta de OMDB API
struct OMDBResponse: Decodable {
    let Search: [Movie]
}
