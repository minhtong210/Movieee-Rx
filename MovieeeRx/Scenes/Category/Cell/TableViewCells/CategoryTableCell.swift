import UIKit
import Reusable

final class CategoryTableCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    func configCell(category: CategoryType) {
        categoryLabel.text = category.title.uppercased()
    }
}
