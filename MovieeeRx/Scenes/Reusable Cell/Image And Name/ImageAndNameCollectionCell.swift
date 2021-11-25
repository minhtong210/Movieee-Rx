import UIKit
import Reusable
import SDWebImage

final class ImageAndNameCollectionCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configPersonCellMovieDetail(from cast: Person) {
        widthImageView(100)
        imageView.sd_setImage(with: URL(string: URLs.Image.person + cast.image),
                              completed: nil)
        nameLabel.text = cast.name
    }
    
    func configMovieCellPersonDetail(from movie: Movie) {
        widthImageView(100)
        imageView.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                              completed: nil)
        nameLabel.text = movie.title
    }
    
    func configMovieCellHome(from movie: Movie) {
        widthImageView(150)
        imageView.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                              completed: nil)
        nameLabel.text = movie.title
    }
    
    func configMovieCateGenre(from movie: Movie) {
        widthImageView(175)
        imageView.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                              completed: nil)
        nameLabel.text = movie.title
    }
    
    private func widthImageView(_ width: Float) {
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
    }
}
