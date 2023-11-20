//
//  MomentsTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import UIKit

class MomentsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelText: UILabel!
    var labelTimestamp: UILabel!
    var collectionView: UICollectionView!
    
    var userImageButton: UIButton!
    var likeButton: UIButton!
    
    var images: [UIImage] = [
        UIImage(named: "Test1")!,
        UIImage(named: "Test2")!,
        UIImage(named: "Test3")!
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelText()
        setupLabelTimestamp()
        setupCollectionView()
        
        setupLikeButton()
        setupUserImageButton()

        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
//        wrapperCellView.backgroundColor = .white
//        wrapperCellView.layer.cornerRadius = 6.0
//        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
//        wrapperCellView.layer.shadowOffset = .zero
//        wrapperCellView.layer.shadowRadius = 4.0
//        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.backgroundColor = .clear
        wrapperCellView.layer.cornerRadius = 0
        wrapperCellView.layer.shadowOpacity = 0
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 14)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont.systemFont(ofSize: 14)
        labelText.textColor = .darkGray
        labelText.numberOfLines = 0         // Allows multi-line text
        labelText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelText)
    }
    
    func setupLabelTimestamp(){
        labelTimestamp = UILabel()
        labelTimestamp.font = UIFont.systemFont(ofSize: 10)
        labelTimestamp.textColor = .darkGray
        labelTimestamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTimestamp)
    }
    
    func setupLikeButton() {
        likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .systemGray
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(onLikeButtonTapped), for: .touchUpInside)
        wrapperCellView.addSubview(likeButton)
    }
    
    func setupUserImageButton() {
        userImageButton = UIButton()
        userImageButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        userImageButton.tintColor = .gray
        userImageButton.contentMode = .scaleAspectFill
        userImageButton.clipsToBounds = true
        userImageButton.layer.cornerRadius = 10
        userImageButton.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(userImageButton)
    
        userImageButton.clipsToBounds = true

        userImageButton.addTarget(self, action: #selector(userImageButtonTapped), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // layout.itemSize = CGSize(width: 200, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        wrapperCellView.addSubview(collectionView)
        
        collectionView.contentInsetAdjustmentBehavior = .never
     }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            userImageButton.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: -2),
            userImageButton.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 0),
            userImageButton.widthAnchor.constraint(equalToConstant: 20),
            userImageButton.heightAnchor.constraint(equalToConstant: 20),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 0),
            labelName.leadingAnchor.constraint(equalTo: userImageButton.trailingAnchor, constant: 8),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            labelText.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            labelText.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelTimestamp.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 8),
            labelTimestamp.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            labelTimestamp.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTimestamp.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            likeButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc func onLikeButtonTapped() {
        // toggle the like status
    }
    
    @objc func userImageButtonTapped() {
        // go to a single user's moments
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


