import RxCocoa
import RxSwift

protocol CateGenreRepositoryType {
    func getMovieFromCategory(input: CategoryDetailRequest) -> Observable<[Movie]>
    func getMovieFromGenre(input: GenreDetailRequest) -> Observable<[Movie]>
}

final class CateGenreRepository: CateGenreRepositoryType {
    
    private let api: APIService = APIService.share
    
    func getMovieFromCategory(input: CategoryDetailRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: MoviesResponse) in
                return response.movies
            }
    }
    
    func getMovieFromGenre(input: GenreDetailRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: MoviesResponse) in
                return response.movies
            }
    }
}
