//
//  MovieDetailViewController.swift
//  RHDb
//
//  Created by Ricardo Hochman on 05/08/18.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var viewModel: MovieListViewModel! {
        didSet {
            guard let movie = viewModel.selectedMovie else {
                fatalError("No movie selected!")
            }
            selectedMovie = movie
        }
    }
    
    private var trailerViewModel: TrailerListViewModel?
    private var selectedMovie: MovieCellViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setFavImage()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let rightItem: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteIcon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(favoriteTapped))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func favoriteTapped(sender: UIBarButtonItem) {
        if viewModel.isFavorite() {
            viewModel.removeMovie()
        } else {
            viewModel.saveMovie()
        }
        setFavImage()
    }
    
    private func setFavImage() {
        if viewModel.isFavorite() {
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "favoriteFilledIcon").withRenderingMode(.alwaysOriginal)
        } else {
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "favoriteIcon").withRenderingMode(.alwaysOriginal)
        }
    }
    
    private func setupLayout() {
        backdropImageView.setImageWithPlaceholder(with: selectedMovie.backdropPath)
        coverImageView.setImageWithPlaceholder(with: selectedMovie.posterPath)
        titleLabel.text = selectedMovie.title
        releaseYearLabel.text = "(\(selectedMovie.releaseYear))"
        overviewLabel.text = selectedMovie.overview
    }
    
    @IBAction func seeTrailers(_ sender: Any) {
        initVM()
    }
    
    private func initVM() {
        self.trailerViewModel = viewModel.createTrailerViewModel()
        guard let viewModel = trailerViewModel else { return }
        
        viewModel.updateLoadingStatus = { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    strongSelf.showActivityIndicator()
                } else {
                    strongSelf.removeActivityIndicator()
                }
            }
        }
        
        viewModel.getTrailer { success in
            if success {
                self.performSegue(withIdentifier: R.segue.movieDetailViewController.showTrailerTableViewController, sender: nil)
            } else {
                let alertController = UIAlertController(title: R.string.movies.noTrailerAlertTitle(), message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Navigation

extension MovieDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueTrailers = R.segue.movieDetailViewController.showTrailerTableViewController(segue: segue) {
            segueTrailers.destination.viewModel = trailerViewModel
        }
    }
}
