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

        // Configurar la imagen de marca de agua
        let watermarkImageView = UIImageView()
        watermarkImageView.translatesAutoresizingMaskIntoConstraints = false
        watermarkImageView.image = UIImage(named: "pngegg") // Asegúrate de que "pngegg" sea el nombre correcto en tus assets
        watermarkImageView.contentMode = .scaleAspectFit
        watermarkImageView.alpha = 0.3 // Ajusta la opacidad para el efecto de marca de agua

        view.addSubview(watermarkImageView)
        view.addSubview(splashImageView)
        
        // Configura las restricciones del ImageView para que esté centrado
        NSLayoutConstraint.activate([
            watermarkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watermarkImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            watermarkImageView.widthAnchor.constraint(equalToConstant: 200), // Ajusta el tamaño según sea necesario
            watermarkImageView.heightAnchor.constraint(equalToConstant: 200),

            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 350),
            splashImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        // Transición a la vista principal después de 4 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.transitionToMainContent()
        }
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
