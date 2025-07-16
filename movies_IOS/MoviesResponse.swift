//
//  MoviesResponse.swift
//  movies_IOS
//
//  Created by Tardes on 16/7/25.
//

import Foundation

// Modelo para la lista de películas
struct Movie: Decodable {
    let imdbID: String
    let Title: String
    let Year: String
    let Poster: String
    var details: MovieDetail?
}

// Modelo para la información detallada de una película
struct MovieDetail: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Plot: String
    let Runtime: String
    let Director: String
    let Genre: String
    let `Type`: String
    let Country: String
    let Poster: String
    let Ratings: [Rating]
}

// Modelo para las calificaciones
struct Rating: Decodable {
    let Source: String
    let Value: String
}
