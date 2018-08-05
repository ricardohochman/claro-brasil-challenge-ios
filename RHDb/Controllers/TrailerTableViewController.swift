//
//  TrailerTableViewController.swift
//  RHDb
//
//  Created by Ricardo Hochman on 05/08/18.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

class TrailerTableViewController: UITableViewController {

    var viewModel: TrailerListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.trailerCell, for: indexPath) else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.getCellViewModel(at: indexPath).title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let youtubeId = viewModel.getCellViewModel(at: indexPath).key

        var finalUrl: URL!
        guard let url = URL(string: "youtube://\(youtubeId)") else { return }
        finalUrl = url
        if !UIApplication.shared.canOpenURL(finalUrl) {
            guard let url = URL(string: "http://www.youtube.com/watch?v=\(youtubeId)") else { return }
            finalUrl = url
        }
        UIApplication.shared.open(finalUrl, options: [:], completionHandler: nil)

    }
}
