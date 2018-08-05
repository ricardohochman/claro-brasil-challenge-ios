//
//  MovieCollectionViewCell.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
}

extension MovieCollectionViewCell: ViewConfiguration {
    func setupViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        imageView
            .topAnchor(equalTo: self.topAnchor, constant: 8)
            .centerXAnchor(equalTo: self.centerXAnchor)
            .heightAnchor(equalTo: 120)
            .widthAnchor(equalTo: imageView.heightAnchor, multiplier: 0.66)
        
        titleLabel
            .topAnchor(equalTo: self.imageView.bottomAnchor, constant: 8)
            .leadingAnchor(equalTo: self.leadingAnchor, constant: 8)
            .trailingAnchor(equalTo: self.trailingAnchor, constant: -8)
    }
    
    func configureViews() {

    }
}

// MARK: - Setup View Model

extension MovieCollectionViewCell {
    func setup(_ viewModel: MovieCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.imageView.setImageWithPlaceholder(with: viewModel.posterPath)
    }
}
