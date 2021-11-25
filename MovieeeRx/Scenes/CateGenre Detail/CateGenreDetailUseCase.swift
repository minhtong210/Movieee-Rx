import RxCocoa
import RxSwift

protocol CateGenreUseCaseType {
    func getMovies(from category: CategoryType?,or genreId: Int?) -> Observable<[Movie]>
    func getTitle(from category: CategoryType?,or genre: Genre?) -> Observable<String>
}

struct CateGenreUseCase: CateGenreUseCaseType {
    
    private let repository = CateGenreRepository()
    
    func getMovies(from category: CategoryType?,or genreId: Int?) -> Observable<[Movie]> {
        if let category = category {
            let request = CategoryDetailRequest(category: category)
            return repository.getMovieFromCategory(input: request)
        }
        
        if let genreId = genreId {
            let request = GenreDetailRequest(genreId: genreId)
            return repository.getMovieFromGenre(input: request)
        }
        fatalError("Error: There is no list of movies")
    }
    
    func getTitle(from category: CategoryType?,or genre: Genre?) -> Observable<String> {
        if let category = category {
            return Observable.just(category.title)
        }
        
        if let genre = genre {
            return Observable.just(genre.name)
        }
        fatalError("Error: There is no title")
    }
}
