//
//  TrailerListViewModel.swift
//  RHDb
//
//  Created by Ricardo Hochman on 05/08/18.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Foundation

class TrailerListViewModel {
    
    private let movieAPI: MovieAPI
    private var trailers: [Trailer] = [Trailer]()
    var selectedTrailer: TrailerCellViewModel?
    private var selectedPrivateTrailer: Trailer?
    private var movieId: Int
    
    init(movieId: Int, movieAPI: MovieAPI = MovieAPI()) {
        self.movieId = movieId
        self.movieAPI = movieAPI
    }
    
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
    private var cellViewModels: [TrailerCellViewModel] = [TrailerCellViewModel]() {
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
    
    func getTrailer(completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.movieAPI.getTrailer(id: movieId, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            switch result {
            case .success(let page):
                if let trailers = page.results, !trailers.isEmpty {
                    strongSelf.processTrailers(trailers: trailers)
                    completion(true)
                } else {
                    completion(false)
                }
            case .error:
                completion(false)
            }
        })
    }
    
    private func processTrailers(trailers: [Trailer]) {
        self.trailers = trailers
        self.cellViewModels = trailers.map({ createCellViewModel(trailer: $0) })
    }
    
    private func createCellViewModel(trailer: Trailer) -> TrailerCellViewModel {
        return TrailerCellViewModel(title: trailer.name ?? "", key: trailer.key ?? "")
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> TrailerCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
}

extension TrailerListViewModel {
    func trailerSelected(at indexPath: IndexPath) {
        selectedPrivateTrailer = trailers[indexPath.row]
        selectedTrailer = cellViewModels[indexPath.row]
    }
}

struct TrailerCellViewModel {
    let title: String
    let key: String
}
