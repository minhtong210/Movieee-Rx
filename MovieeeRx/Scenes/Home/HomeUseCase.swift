import RxCocoa
import RxSwift

protocol HomeUseCaseType {
    func getUpcomingMovies() -> Observable<[Movie]>
    func getTopRatedMovies() -> Observable<[Movie]>
    func getPopularMovies() -> Observable<[Movie]>
    func getNowPlayingMovies() -> Observable<[Movie]>
    func mergeItems(nowPlayingMovies: [Movie],
                    topRatedMovies: [Movie],
                    popularMovies: [Movie],
                    upcomingMovies: [Movie]) -> [HomeCellType]
}

struct HomeUseCase: HomeUseCaseType {
    
    private let repository = HomeRepository()
    
    func getUpcomingMovies() -> Observable<[Movie]> {
        let request = CategoryDetailRequest(category: .upcoming)
        return repository.getMovieList(input: request)
    }
    
    func getTopRatedMovies() -> Observable<[Movie]> {
        let request = CategoryDetailRequest(category: .topRated)
        return repository.getMovieList(input: request)
    }
    
    func getPopularMovies() -> Observable<[Movie]> {
        let request = CategoryDetailRequest(category: .popular)
        return repository.getMovieList(input: request)
    }
    
    func getNowPlayingMovies() -> Observable<[Movie]> {
        let request = CategoryDetailRequest(category: .nowPlaying)
        return repository.getMovieList(input: request)
    }
    
    func mergeItems(nowPlayingMovies: [Movie],
                    topRatedMovies: [Movie],
                    popularMovies: [Movie],
                    upcomingMovies: [Movie]) -> [HomeCellType] {
        
        let nowPlayingMovies = HomeCellType(category: .nowPlaying,
                                            movies: nowPlayingMovies)
    
        let topRatedMovies = HomeCellType(category: .topRated,
                                          movies: topRatedMovies)
        
        let popularMovies = HomeCellType(category: .popular,
                                         movies: popularMovies)
        
        let upcomingMovies = HomeCellType(category: .upcoming,
                                          movies: upcomingMovies)
        
        return [popularMovies, nowPlayingMovies, upcomingMovies, topRatedMovies]
    }
}
