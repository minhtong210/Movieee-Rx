import UIKit
import Reusable

final class GenreCollectionCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var genreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(from genre: Genre) {
        genreNameLabel.text = genre.name
    }
}
