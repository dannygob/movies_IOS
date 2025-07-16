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
        guard let url = URL(string: urlString) else { return }
        
        // Usamos URLSession para descargar la imagen en segundo plano
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                // Si la imagen se descarga correctamente, la ponemos en el UIImageView
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

