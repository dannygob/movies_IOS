//
//  UIImageView+Extensions.swift
//  movies_IOS
//
//  Created by Tardes on 16/7/25.
//

import UIKit

// Esta es la extensión para UIImageView
extension UIImageView {
    // Función para cargar una imagen desde una URL
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            // If the URL string is invalid, set the placeholder and return.
            self.image = UIImage(named: "Placeholder")
            // As a fallback, set a background color in case the image asset fails to load.
            if self.image == nil {
                self.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0) // Dark Red
            }
            return
        }
        
        // Usamos URLSession para descargar la imagen en segundo plano
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil, let image = UIImage(data: data) {
                // Si la imagen se descarga correctamente, la ponemos en el UIImageView
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                // If there's an error or data is invalid, set the placeholder
                DispatchQueue.main.async {
                    self.image = UIImage(named: "Placeholder")
                    // As a fallback, set a background color in case the image asset fails to load.
                    if self.image == nil {
                        self.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0) // Dark Red
                    }
                }
            }
        }.resume()
    }
}
