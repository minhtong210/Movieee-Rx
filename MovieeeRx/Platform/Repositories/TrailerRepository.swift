import RxCocoa
import RxSwift

protocol TrailerRepositoryType {
    func getMovieTrailer(input: TrailerRequest) -> Observable<[Trailer]>
}

final class TrailerRepository: TrailerRepositoryType {
    
    private let api = APIService.share
    
    func getMovieTrailer(input: TrailerRequest) -> Observable<[Trailer]> {
        return api.request(input: input)
            .map { (response: TrailerResponse) in
                return response.results
            }
    }
}
