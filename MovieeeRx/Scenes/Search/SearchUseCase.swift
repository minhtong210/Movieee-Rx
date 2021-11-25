import RxCocoa
import RxSwift

protocol SearchUseCaseType {
    func getMoviesSearch(query: String) -> Observable<[MovieSearch]>
}

struct SearchUseCase: SearchUseCaseType {
    
    private let repository = SearchRepository()
    
    func getMoviesSearch(query: String) -> Observable<[MovieSearch]> {
        let request = SearchRequest(query: query)
        return repository.getMoviesSearch(input: request)
    }
}
