//
//  MoviePersistenceManager.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import CoreData

class MoviePersistenceManager: CoreDataManager {
    
    internal typealias T = MoviePersistence
    
    static let shared = MoviePersistenceManager()
        
    func createMovie(_ movie: Movie) {
        self.newEntity().fromObject(movie)
        self.saveContext()
        print("Movie inserted with id: \(movie.id ?? 0)")
    }
    
    func movies() -> [Movie]? {
        guard let moviesPersistence = self.fetchData() else { return nil }
        return moviesPersistence.map { Movie(fromPersistence: $0) }
    }
    
    func movie(id: Int) -> Movie? {
        let predicate = NSPredicate(format: "\(#keyPath(MoviePersistence.id)) = %i", id)
        guard let result = self.fetchData(predicate)?.last else { return nil }
        return Movie(fromPersistence: result)
    }
    
    func moviePersistence(id: Int) -> MoviePersistence? {
        let predicate = NSPredicate(format: "\(#keyPath(MoviePersistence.id)) = %i", id)
        guard let result = self.fetchData(predicate)?.last else { return nil }
        return result
    }
    
    func deleteMovie(id: Int) {
        guard let movie = self.moviePersistence(id: id) else { return }
        self.delete(movie)
        print("Movie deleted with id: \(id)")
    }
    
}
