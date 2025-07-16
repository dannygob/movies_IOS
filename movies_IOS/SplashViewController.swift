import UIKit
import ImageIO

class SplashViewController: UIViewController {

    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aplica el color de fondo de tu aplicación
        view.backgroundColor = .black

        view.addSubview(splashImageView)
        
        // Configura las restricciones del ImageView para que esté centrado
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 350),
            splashImageView.heightAnchor.constraint(equalToConstant: 350)
        ])

        // Cargar y reproducir el GIF
        loadGif(named: "count") // "count" debe ser el nombre de tu archivo GIF en el bundle
        
        // Transición a la vista principal después de 4 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.transitionToMainContent()
        }
    }

    // Función para cargar y reproducir el GIF
    private func loadGif(named name: String) {
        // Asegúrate de que el archivo GIF esté en el bundle y cargado correctamente
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("DEBUG: GIF no encontrado en el bundle: \(name).gif")
            return
        }
        print("DEBUG: GIF encontrado en la URL: \(url.lastPathComponent)")

        // Intentamos cargar los datos del archivo GIF
        guard let imageData = try? Data(contentsOf: url) else {
            print("DEBUG: No se pudo cargar los datos del GIF.")
            return
        }

        // Usamos ImageIO para leer el GIF
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            print("DEBUG: No se pudo crear la fuente de imagen desde el GIF.")
            return
        }

        // Obtenemos el número de frames del GIF
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0

        // Extraemos los frames del GIF y calculamos la duración total
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }

            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
                totalDuration += delayTime
            }
        }

        // Si no se extrajeron imágenes, imprimimos un error
        if images.isEmpty {
            print("DEBUG: No se encontraron imágenes en el GIF.")
            return
        }

        // Configuramos la animación del UIImageView con las imágenes extraídas
        splashImageView.animationImages = images
        splashImageView.animationDuration = totalDuration
        splashImageView.animationRepeatCount = 1 // Reproducir solo una vez
        splashImageView.startAnimating()
    }

    // Función para realizar la transición a la vista principal
    private func transitionToMainContent() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            let navigationController = UINavigationController(rootViewController: listViewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            present(navigationController, animated: true, completion: nil)
        }
    }
}
