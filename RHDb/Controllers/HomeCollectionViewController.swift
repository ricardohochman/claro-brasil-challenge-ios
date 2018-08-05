//
//  HomeCollectionViewController.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let itemSize = CGSize(width: 110, height: 165)

    private var searchTerms = ""
    private var searchWasCancelled = false

    private lazy var spacing: CGFloat = {
        self.view.layoutIfNeeded()
        let numberOfColuns = (self.view.frame.width / itemSize.width).rounded(.towardZero)
        let space = self.view.frame.width.truncatingRemainder(dividingBy: itemSize.width)
        return space / (numberOfColuns + 1)
    }()

    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupSearchBar()
        initVM()
    }
    
    private func registerCells() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: R.string.movies.movieCollectionViewCell())
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initVM() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    strongSelf.showActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.collectionView?.alpha = 0.0
                    })
                } else {
                    strongSelf.removeActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.collectionView?.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        
        fetchMovie(with: "vingadores")
        
        viewModel.initWithPersistence()
    }
    
    private func fetchMovie(with title: String) {
        viewModel.getMovie(title: title) { success in
            print(success)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.string.movies.movieCollectionViewCell(), for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Could not find correct cell")
        }
                
        cell.setup(viewModel.getCellViewModel(at: indexPath))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.movieSelected(at: indexPath)
        self.performSegue(withIdentifier: R.segue.homeCollectionViewController.showMovieDetailViewController, sender: indexPath)
    }
}

// MARK: - Navigation

extension HomeCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueDetail = R.segue.homeCollectionViewController.showMovieDetailViewController(segue: segue) {
            segueDetail.destination.viewModel = viewModel
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }

}

// MARK: - Search Bar
extension HomeCollectionViewController {
    
    private func setupSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.placeholder = R.string.movies.search()
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return self.searchController.isActive && !self.searchBarIsEmpty()
    }
    
}

// MARK: - UISearchResultsUpdating Delegate
extension HomeCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(HomeCollectionViewController.reload), object: nil)
        self.perform(#selector(HomeCollectionViewController.reload), with: nil, afterDelay: 0.5)
    }
    
    @objc private func reload() {
        if !searchBarIsEmpty() {
            fetchMovie(with: searchTerms)
        }
    }
}

extension HomeCollectionViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchWasCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchWasCancelled = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerms = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !searchWasCancelled {
            searchBar.text = self.searchTerms
        } else {
            viewModel.initWithPersistence()
        }
    }
}
