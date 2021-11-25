import RxCocoa
import RxSwift

protocol HomeRepositoryType {
    func getMovieList(input: CategoryDetailRequest) -> Observable<[Movie]>
}

final class HomeRepository: HomeRepositoryType {
    
    private let api: APIService = APIService.share
    
    func getMovieList(input: CategoryDetailRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: MoviesResponse) in
                return response.movies
            }
    }
}
