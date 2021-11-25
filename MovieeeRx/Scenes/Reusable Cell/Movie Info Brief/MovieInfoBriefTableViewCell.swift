import UIKit
import Reusable
import SDWebImage
import Cosmos

final class MovieInfoBriefTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingStars: CosmosView!

    func configFavoriteCell(from movie: FavoriteMovie) {
        movieNameLabel.text = movie.name
        rateLabel.text = String(movie.rate)
        descriptionLabel.text = movie.overview
        posterImageView.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                                    completed: nil)
        ratingStars.rating = movie.rate / 2
    }
    
    func configSearchCell(from movie: MovieSearch) {
        movieNameLabel.text = movie.title
        rateLabel.text = String(movie.rate)
        descriptionLabel.text = movie.overview
        posterImageView.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                                    completed: nil)
        ratingStars.rating = movie.rate / 2
    }
}
