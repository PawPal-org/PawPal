//
//  CardView.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit

class CardView: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    let flippedTitleLabel = UILabel()
    let flippedDetailView = UILabel()
    var isFlipped = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
        setupSubviews()
        setupFlippedStateSubviews()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCard() {
        self.backgroundColor = .systemOrange // Customize as needed
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
    }

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        setupImageView()
        setupTitleLabel()
        setupDetailLabel()
    }
    
    private func setupFlippedStateSubviews(){
        addSubview(flippedTitleLabel)
        addSubview(flippedDetailView)
        
        setupFlippedTitleLabel()
        setupFlippedDetailLabel()
        flippedDetailView.isHidden = true
        flippedTitleLabel.isHidden = true
    }
    
    func configureFlippedState(title: String, details: String){
        flippedTitleLabel.text = title
        flippedDetailView.text = details
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupFlippedTitleLabel() {
        flippedTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        flippedTitleLabel.textAlignment = .center
        flippedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDetailLabel() {
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedDetailLabel() {
        flippedDetailView.font = UIFont.systemFont(ofSize: 16)
        flippedDetailView.numberOfLines = 0
        flippedDetailView.textAlignment = .center
        flippedDetailView.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with image: UIImage, title: String, details: String) {
        imageView.image = image
        titleLabel.text = title
        detailLabel.text = details
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
            
            flippedTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            flippedTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            flippedDetailView.topAnchor.constraint(equalTo: flippedTitleLabel.bottomAnchor, constant: 40),
            flippedDetailView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
