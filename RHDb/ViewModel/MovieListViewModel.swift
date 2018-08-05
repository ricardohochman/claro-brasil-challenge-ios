//
//  MovieViewModel.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Foundation

class MovieListViewModel {
    
    private let movieAPI: MovieAPI
    private var movies: [Movie] = [Movie]()
    var selectedMovie: MovieCellViewModel?
    private var selectedPrivateMovie: Movie?
    
    init(movieAPI: MovieAPI = MovieAPI()) {
        self.movieAPI = movieAPI
    }
    
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    private var cellViewModels: [MovieCellViewModel] = [MovieCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }

    // MARK: - API methods

    func getMovie(title: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.movieAPI.getMovie(title: title, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            switch result {
            case .success(let page):
                if let movies = page.results {
                    strongSelf.processMovies(movies: movies)
                    completion(true)
                } else {
                    completion(false)
                }
            case .error:
                completion(false)
            }
        })
        
    }
        
    private func processMovies(movies: [Movie]) {
        self.movies = movies
        let moviesVM = movies.map({ createCellViewModel(movie: $0) })
        self.cellViewModels = moviesVM
    }
    
    private func createCellViewModel(movie: Movie) -> MovieCellViewModel {
        let posterPath = ImageEndpoint(.original, movie.posterPath ?? "").url
        let backdropPath = ImageEndpoint(.original, movie.backdropPath ?? "").url

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        var releaseYear: String = ""
        if let date = dateFormatterGet.date(from: movie.releaseDate ?? "") {
            releaseYear = dateFormatterPrint.string(from: date)
        } else {
            releaseYear = movie.releaseDate ?? ""
        }

        return MovieCellViewModel(title: movie.title ?? "",
                                  releaseYear: releaseYear,
                                  posterPath: posterPath,
                                  backdropPath: backdropPath,
                                  overview: movie.overview ?? "")
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createTrailerViewModel() -> TrailerListViewModel? {
        guard let movie = selectedPrivateMovie, let id = movie.id else { return nil }
        return TrailerListViewModel(movieId: id)
    }

}

extension MovieListViewModel {
    func movieSelected(at indexPath: IndexPath) {
        selectedPrivateMovie = movies[indexPath.row]
        selectedMovie = cellViewModels[indexPath.row]
    }
}

// MARK: - CoreData

extension MovieListViewModel {
    func initWithPersistence() {
        guard let movies = MoviePersistenceManager.shared.movies() else {
            return
        }
        processMovies(movies: movies)
    }
    
    func saveMovie() {
        guard let movie = selectedPrivateMovie else { return }
        MoviePersistenceManager.shared.createMovie(movie)
    }
    
    func removeMovie() {
        guard let movie = selectedPrivateMovie, let id = movie.id else { return }
        MoviePersistenceManager.shared.deleteMovie(id: id)
    }
    
    func isFavorite() -> Bool {
        return MoviePersistenceManager.shared.movie(id: selectedPrivateMovie?.id ?? -1) != nil
    }

}

struct MovieCellViewModel {
    let title: String
    let releaseYear: String
    let posterPath: URL
    let backdropPath: URL
    let overview: String
}
