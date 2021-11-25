import Foundation

enum URLs {
    
    static let videoUtube = "https://www.youtube.com/embed/"
    
    enum Image {
        static let movie = "https://www.themoviedb.org/t/p/w440_and_h660_face"
        static let person = "https://www.themoviedb.org/t/p/w276_and_h350_face"
    }
    
    enum API {
        private static var apiBaseURL = "https://api.themoviedb.org/3"
        private static let movie = apiBaseURL + "/movie"
        private static let person = apiBaseURL + "/person"
        private static let search = apiBaseURL + "/search"
        //MARK: - Movie
        static let upcoming = movie + "/upcoming"
        static let nowPlaying = movie + "/now_playing"
        static let popular = movie + "/popular"
        static let topRated = movie + "/top_rated"
        
        static let movieDetail = movie + "/%d"
        static let movieCast = movie + "/%d/credits"
        static let movieTrailer = movie + "/%d/videos"
        //MARK: - Person
        static let personDetail = person + "/%d"
        static let personKnownFor = personDetail + "/movie_credits"
        //MARK: - Search
        static let movieSearch = search + "/movie"
        static let personSearch = search + "/person"
        //MARK: - Genre
        static let genreList = apiBaseURL + "genre/movie/list"
        static let moviesByGenre = apiBaseURL + "/discover/movie"
    }
}
