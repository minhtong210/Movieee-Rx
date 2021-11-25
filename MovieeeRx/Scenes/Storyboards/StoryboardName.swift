import UIKit

enum StoryboardName: String {
    case welcome = "Welcome"
    case main = "Main"
    case home = "Home"
    case category = "Category"
    case favorite = "Favorite"
    case movieDetail = "MovieDetail"
    case personDetail = "PersonDetail"
    case trailer = "Trailer"
    case cateGenre = "CateGenre"
    case search = "Search"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
