import RxCocoa
import RxSwift

protocol SearchRepositoryType {
    func getMoviesSearch(input: SearchRequest) -> Observable<[MovieSearch]>
}

final class SearchRepository: SearchRepositoryType {
    
    private let api: APIService = APIService.share
    
    func getMoviesSearch(input: SearchRequest) -> Observable<[MovieSearch]> {
        return api.request(input: input)
            .map { (response: MoviesSearchResponse) in
                return response.movies
            }
    }
}
