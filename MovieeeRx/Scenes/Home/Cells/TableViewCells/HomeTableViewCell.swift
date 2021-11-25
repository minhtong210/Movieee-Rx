import UIKit
import Reusable

final class HomeTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }
    
    private func configCollectionView() {
        collectionView.do {
            $0.register(cellType: ImageAndNameCollectionCell.self)
        }
    }
    
    func configCell(category: HomeCellType) {
        titleLabel.text = category.category.title.uppercased()
    }
    
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.do {
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.tag = row
            $0.setContentOffset(collectionView.contentOffset, animated: false)
            $0.reloadData()
        }
    }

}
