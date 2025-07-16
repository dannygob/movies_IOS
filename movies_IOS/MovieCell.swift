import UIKit

class MovieCell: UITableViewCell {

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rottenTomatoesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        // Add a gray border to the cell
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(ratedLabel)
        contentView.addSubview(rottenTomatoesLabel)
        contentView.addSubview(ratingIconImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            ratedLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            ratedLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5),
            ratedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            rottenTomatoesLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            rottenTomatoesLabel.topAnchor.constraint(equalTo: ratedLabel.bottomAnchor, constant: 5),
            rottenTomatoesLabel.trailingAnchor.constraint(equalTo: ratingIconImageView.leadingAnchor, constant: -10),
            
            ratingIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            ratingIconImageView.widthAnchor.constraint(equalToConstant: 30),
            ratingIconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.Title
        yearLabel.text = movie.Year
        posterImageView.loadImage(from: movie.Poster)
        
        // Reset icon before setting
        ratingIconImageView.image = nil
        
        if let details = movie.details {
            genreLabel.text = "Genre: \(details.Genre)"
            ratedLabel.text = "Rated: \(details.Rated)"
            
            if let rottenTomatoesRating = details.Ratings.first(where: { $0.Source == "Rotten Tomatoes" }) {
                rottenTomatoesLabel.text = "Rotten Tomatoes: \(rottenTomatoesRating.Value)"
                
                // Parse the score and set the icon
                let scoreString = rottenTomatoesRating.Value.replacingOccurrences(of: "%", with: "")
                if let score = Int(scoreString) {
                    if score >= 65 {
                        ratingIconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                        ratingIconImageView.tintColor = .green
                    } else if score >= 45 {
                        ratingIconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                        ratingIconImageView.tintColor = .yellow
                    } else {
                        ratingIconImageView.image = UIImage(systemName: "xmark.circle.fill")
                        ratingIconImageView.tintColor = .red
                    }
                }
                
            } else {
                rottenTomatoesLabel.text = "Rotten Tomatoes: N/A"
            }
        } else {
            genreLabel.text = "Genre: N/A"
            ratedLabel.text = "Rated: N/A"
            rottenTomatoesLabel.text = "Rotten Tomatoes: N/A"
        }
    }
}
