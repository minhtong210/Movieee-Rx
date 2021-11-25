import Foundation
import RealmSwift

class FavoriteMovie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var rate: Double = 0.0
    @objc dynamic var overview: String = ""
}
