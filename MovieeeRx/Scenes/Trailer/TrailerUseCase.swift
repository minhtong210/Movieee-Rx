import RxCocoa
import RxSwift

protocol TrailerUseCaseType {
    func getMovieTrailers(from movieId: Int) -> Observable<[Trailer]>
}

struct TrailerUseCase: TrailerUseCaseType {
    
    private let repository = TrailerRepository()
    
    func getMovieTrailers(from movieId: Int) -> Observable<[Trailer]> {
        let request = TrailerRequest(movieId: movieId)
        return repository.getMovieTrailer(input: request)
    }
}
