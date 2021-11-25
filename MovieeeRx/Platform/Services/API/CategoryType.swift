import Foundation

enum CategoryType {
    case nowPlaying
    case popular
    case upcoming
    case topRated
    
    
    var url: String {
        switch self {
        case .nowPlaying:
            return URLs.API.nowPlaying
        case .popular:
            return URLs.API.popular
        case .upcoming:
            return URLs.API.upcoming
        case .topRated:
            return URLs.API.topRated
        }
    }
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        }
    }
}
