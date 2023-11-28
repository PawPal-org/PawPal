//
//  MomentsTableViewCell.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import UIKit
import FirebaseStorage

class MomentsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelText: UILabel!
    var labelTimestamp: UILabel!
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    var userImageButton: UIButton!
    var likeButton: UIButton!
    
    var delegate: MomentsTableViewCellDelegate?
    
    var momentID: String?
    var currentProfileImageLoadTask: URLSessionDataTask?
    var userEmail: String?
    
    var imageUrls: [String: String] = [:] {
        didSet {
            fetchImages()
        }
    }

    var images: [UIImage] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelText()
        setupLabelTimestamp()
        setupCollectionView()
        setupPageControl()
        setupLikeButton()
        setupUserImageButton()

        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with moment: Moment) {
        momentID = moment.id
        labelName.text = moment.name
        labelText.text = moment.text
        imageUrls = moment.imageUrls
        labelTimestamp.text = DateFormatter.localizedString(from: moment.timestamp, dateStyle: .short, timeStyle: .short)
        fetchProfileImage(for: moment)
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .clear
        wrapperCellView.layer.cornerRadius = 0
        wrapperCellView.layer.shadowOpacity = 0
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont(name: titleFont, size: 16)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont(name: normalFont, size: 14)
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
        userImageButton.setImage(UIImage(systemName: "person.crop.circle")!, for: .normal)
        userImageButton.tintColor = .gray
        userImageButton.contentMode = .scaleAspectFill
        userImageButton.clipsToBounds = true
        userImageButton.layer.cornerRadius = 11.5
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
    
    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        pageControl.transform = scale
        wrapperCellView.addSubview(pageControl)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            userImageButton.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: -10),
            userImageButton.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 0),
            userImageButton.widthAnchor.constraint(equalToConstant: 23),
            userImageButton.heightAnchor.constraint(equalToConstant: 23),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 0),
            labelName.leadingAnchor.constraint(equalTo: userImageButton.trailingAnchor, constant: 8),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: wrapperCellView.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            labelText.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
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
        delegate?.didTapLikeButton(on: self)
    }
    
    @objc func userImageButtonTapped() {
        delegate?.didTapUserImageButton(on: self)
    }
    
    func setLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = isLiked ? UIColor.orange : UIColor.systemGray
    }
    
    func updatePageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width - (scrollView.contentInset.left*2)
        let currentPage = collectionView.contentOffset.x / width
        if 0.0 <= currentPage && currentPage < Double(pageControl.numberOfPages) {
            pageControl.currentPage = Int(currentPage)
        }
    }
    
    func fetchImages() {
        images.removeAll()
        let storage = Storage.storage()
        
        // Sort the dictionary based on keys to maintain order
        let sortedUrls = imageUrls.sorted { $0.key < $1.key }.map { $0.value }
        
        for urlString in sortedUrls {
            if let url = URL(string: urlString) {
                let imageName = url.lastPathComponent

                // Check cache first
                if let cachedImage = ImageCache.shared.getImage(for: imageName) {
                    self.images.append(cachedImage)
                    continue
                }

                // Fetch from storage if not in cache
                let storageRef = storage.reference().child("post_images").child(imageName)
                fetchImage(storageRef, imageName: imageName)
            }
        }

        self.collectionView.reloadData()
        self.updatePageControl()
    }
    
    func fetchImage(_ storageRef: StorageReference, imageName: String, isProfileImage: Bool = false) {
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error downloading image: \(error)")
                } else if let data = data, let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, for: imageName)
                    if isProfileImage {
                        self.userImageButton.setImage(image, for: .normal)
                    } else {
                        self.images.append(image)
                        self.collectionView.reloadData()
                        self.updatePageControl()
                    }
                }
            }
        }
    }
    
    func fetchProfileImage(for moment: Moment) {
        guard let profileImageUrl = moment.profileImageUrl, let url = URL(string: profileImageUrl) else {
            // Set default profile image if no URL is provided
            self.userImageButton.setImage(UIImage(systemName: "person.crop.circle")!, for: .normal)
            return
        }
        let imageName = url.lastPathComponent

        // Use cached image if available
        if let cachedImage = ImageCache.shared.getImage(for: imageName) {
            self.userImageButton.setImage(cachedImage, for: .normal)
            return
        }

        // Fetch from storage if not in cache
        let storageRef = Storage.storage().reference().child("user_images").child(imageName)

        // Cancel any existing image load task
        currentProfileImageLoadTask?.cancel()

        storageRef.downloadURL { [weak self] (url, error) in
            guard let url = url, error == nil else {
                print("Error getting download URL: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            // Fetch the image from the download URL
            self?.currentProfileImageLoadTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    print("Error downloading image: \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                DispatchQueue.main.async {
                    // Check if the cell is still displaying content related to the same moment
                    if self?.momentID == moment.id {
                        ImageCache.shared.setImage(image, for: imageName)
                        self?.userImageButton.setImage(image, for: .normal)
                    }
                }
            }
            self?.currentProfileImageLoadTask?.resume()
        }
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


