//
//  Movie.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

struct Movie: Codable {
	var adult: Bool?
	var backdropPath: String?
	var genreIds: [Int]?
	var id: Int?
	var originalLanguage: String?
	var originalTitle: String?
	var overview: String?
	var releaseDate: String?
	var posterPath: String?
	var popularity: Double?
	var title: String?
	var video: Bool?
	var voteAverage: Double?
	var voteCount: Int?
}

extension Movie {
    init(fromPersistence movie: MoviePersistence) {
        self.init(adult: nil, backdropPath: nil, genreIds: nil, id: Int(movie.id), originalLanguage: nil, originalTitle: nil, overview: movie.overview, releaseDate: movie.releaseYear, posterPath: nil, popularity: nil, title: movie.title, video: nil, voteAverage: nil, voteCount: nil)
    }
}

extension MoviePersistence {
    func fromObject(_ movie: Movie) {
        self.id = Int64(movie.id ?? 0)
        self.title = movie.title
        self.overview = movie.overview
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        var releaseYear: String = ""
        if let date = dateFormatterGet.date(from: movie.releaseDate ?? "") {
            releaseYear = dateFormatterPrint.string(from: date)
        }
        
        self.releaseYear = releaseYear
        
        let posterPathUrl = ImageEndpoint(.original, movie.posterPath ?? "").url
        let backdropPathUrl = ImageEndpoint(.original, movie.backdropPath ?? "").url

        let movieAPI = MovieAPI()
        movieAPI.getImage(url: posterPathUrl) { posterImage in
            self.posterPathData = UIImageJPEGRepresentation(posterImage, 1)
        }
        
        movieAPI.getImage(url: backdropPathUrl) { backdropImage in
            self.backdropPathData = UIImageJPEGRepresentation(backdropImage, 1)
        }
        
    }
}
