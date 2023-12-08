//
//  MyPetsView.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit
import FirebaseFirestore
import Kingfisher

class MyPetsView: UIView {
    
    
    //MARK: Variables for cards' front
    let imageView = UIImageView()
    let labelName = UILabel()
    let labelSex = UILabel()
    let labelBreed = UILabel()
    let labelLocation = UILabel()
    let backgroundImageView = UIImageView()

    //MARK: Variables for cards' back
    //change pet profile icon from button to image
    var flippedImagePet = UIImageView()
    let flippedLabelName = UILabel()
    let flippedLabelSex = UILabel()
    let flippedLabelAge = UILabel()
    let flippedLabelBreed = UILabel()
    let flippedLabelBirthday = UILabel()
    let flippedLabelWeight = UILabel()
    let flippedLabelVaccinations = UILabel()
    let flippedLabelDescriptions = UILabel()
    var isFlipped = false
    var petImageURL: String!

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
        self.backgroundColor = themeColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
    }
    
    

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(labelName)
        addSubview(labelSex)
        addSubview(labelBreed)
        addSubview(labelLocation)
        

        setupImageView()
        setupLabelName()
        setupLabelSex()
        setupLabelBreed()
        setupLabelLocation()
        setupBackgroundImageView()
        
    }
    
    private func setupFlippedStateSubviews(){
        addSubview(flippedImagePet)
        addSubview(flippedLabelName)
        addSubview(flippedLabelSex)
        addSubview(flippedLabelAge)
        addSubview(flippedLabelBreed)
        addSubview(flippedLabelBirthday)
        addSubview(flippedLabelWeight)
        addSubview(flippedLabelVaccinations)
        addSubview(flippedLabelDescriptions)
        
        setupFlippedLabelName()
        setupFlippedLabelSex()
        setupFlippedImagePet()
        setupFlippedLabelAge()
        setupFlippedLabelBreed()
        setupFlippedLabelBirthday()
        setupFlippedLabelWeight()
        setupFlippedLabelVaccinations()
        setupFlippedLabelDescriptions()
        
        flippedImagePet.isHidden = true
        flippedLabelName.isHidden = true
        flippedLabelSex.isHidden = true
        flippedLabelAge.isHidden = true
        flippedLabelBreed.isHidden = true
        flippedLabelBirthday.isHidden = true
        flippedLabelWeight.isHidden = true
        flippedLabelVaccinations.isHidden = true
        flippedLabelDescriptions.isHidden = true
    }
    

    private func setupBackgroundImageView() {
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill // maintain aspect ratio
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.layer.cornerRadius = self.layer.cornerRadius
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

            // Constraints for backgroundImageView
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = pawColor
    }

    private func setupLabelName() {
        labelName.font = UIFont(name: titleFont, size: 30)
        labelName.textAlignment = .center
        labelName.attributedText = NSAttributedString(string: " ", attributes: strokeTextAttributes)
        labelName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelSex(){
        labelSex.font = UIFont(name: normalFont, size: 25)
        labelSex.textAlignment = .right
        //labelSex.attributedText = NSAttributedString(string: "LabelName", attributes: strokeTextAttributes)
        labelSex.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelBreed() {
        labelBreed.font = UIFont(name: normalFont, size: 20)
        labelBreed.numberOfLines = 0
        labelBreed.textAlignment = .left
        //labelBreed.attributedText = NSAttributedString(string: "LabelName", attributes: strokeTextAttributes)
        labelBreed.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelLocation() {
        labelLocation.font = UIFont(name: lightFont, size: 16)
        labelLocation.numberOfLines = 0
        labelLocation.textAlignment = .left
        //labelLocation.attributedText = NSAttributedString(string: "LabelName", attributes: strokeTextAttributes)
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupFlippedImagePet(){
        
        flippedImagePet.image = UIImage(systemName: "dog.circle")
        flippedImagePet.translatesAutoresizingMaskIntoConstraints = false
        flippedImagePet.tintColor = backgroundColorBeige
        flippedImagePet.contentMode = .scaleAspectFill
        flippedImagePet.layer.cornerRadius = 75
        flippedImagePet.clipsToBounds = true
        flippedImagePet.translatesAutoresizingMaskIntoConstraints = false

        // To add a border
        flippedImagePet.layer.borderWidth = 8.0
        flippedImagePet.layer.borderColor = pawColor.cgColor // Specify the color you want here
        
    }
 
    
    private func setupFlippedLabelName() {
        //flippedLabelName.font = UIFont.boldSystemFont(ofSize: 30)
        flippedLabelName.font = UIFont(name: "Noteworthy-Light", size: 40)
        flippedLabelName.textAlignment = .center
        flippedLabelName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupFlippedLabelSex() {
        flippedLabelSex.font = UIFont(name: normalFont, size: 20)
        flippedLabelSex.numberOfLines = 0
        flippedLabelSex.textAlignment = .left
        flippedLabelSex.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelAge() {
        flippedLabelAge.font = UIFont(name: normalFont, size: 20)
        flippedLabelAge.numberOfLines = 0
        flippedLabelAge.textAlignment = .left
        flippedLabelAge.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelBreed() {
        flippedLabelBreed.font = UIFont(name: normalFont, size: 20)
        flippedLabelBreed.numberOfLines = 0
        flippedLabelBreed.textAlignment = .left
        flippedLabelBreed.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelBirthday() {
        flippedLabelBirthday.font = UIFont(name: normalFont, size: 20)
        flippedLabelBirthday.numberOfLines = 0
        flippedLabelBirthday.textAlignment = .left
        flippedLabelBirthday.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelWeight() {
        flippedLabelWeight.font = UIFont(name: normalFont, size: 20)
        flippedLabelWeight.numberOfLines = 0
        flippedLabelWeight.textAlignment = .left
        flippedLabelWeight.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelVaccinations() {
        flippedLabelVaccinations.font = UIFont(name: normalFont, size: 20)
        flippedLabelVaccinations.numberOfLines = 0
        flippedLabelVaccinations.textAlignment = .left
        flippedLabelVaccinations.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFlippedLabelDescriptions() {
        flippedLabelDescriptions.font = UIFont(name: normalFont, size: 20)
        flippedLabelDescriptions.numberOfLines = 0
        flippedLabelDescriptions.textAlignment = .left
        flippedLabelDescriptions.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupBackgroundImageView(with url: URL) {
        backgroundImageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.backgroundImageView.image = value.image
                self.applyBlurEffect()

                self.backgroundImageView.layer.cornerRadius = self.layer.cornerRadius
                self.backgroundImageView.clipsToBounds = true

            case .failure(let error):
                print("Error setting background image: \(error.localizedDescription)")
            }
        }
    }

    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }

    
    func configure(with imageUrl: String, name: String, sex: String, breed: String, location: String) {
        if let url = URL(string: imageUrl), imageUrl != "default" {
            imageView.kf.setImage(with: url)
            setupBackgroundImageView(with: url)
        } else {
            //set default image
            let defaultImage = UIImage(systemName: "pawprint.fill")
            imageView.image = defaultImage
//            imageView.backgroundColor = themeColor
            imageView.clipsToBounds = true

            backgroundImageView.image = nil
            backgroundImageView.backgroundColor = themeColor
            backgroundImageView.clipsToBounds = imageView.clipsToBounds
        }
        petImageURL = imageUrl
        labelName.text = name
        labelSex.text = sex
        labelBreed.text = breed
        labelLocation.text = location
    }
    
    func configureFlippedState(with iconURL: String, name: String, sex: String, age: String, breed: String,
                               birthday: String, weight: String, vaccinations: String, descriptions: String, email: String){
       
        //set pet profile image
        if iconURL == "default"{
            flippedImagePet.image = UIImage(systemName: "dog.circle")
        }else{
            if let url = URL(string: iconURL) {
                flippedImagePet.kf.setImage(with: url)
                
            }
        }
        flippedLabelName.text = name
        flippedLabelSex.text = "\(sex)"
        flippedLabelAge.text = "\(age)"
        flippedLabelBreed.text = "Breed: \(breed)"
        flippedLabelBirthday.text = "Birthday: \(birthday)"
        flippedLabelWeight.text = "Weight: \(weight)\n"
        let tempVacc = vaccinations.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let vacc = tempVacc.joined(separator: "\n")
        flippedLabelVaccinations.text = "Vaccinations: \n\(vacc)"
        flippedLabelDescriptions.text = "\n\(descriptions)"
    }
    
    func convertTimestampToString(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Change to the desired format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    

    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            
            labelSex.bottomAnchor.constraint(equalTo: labelName.bottomAnchor),
            labelSex.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -8),
            
            labelBreed.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 3),
            labelBreed.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelBreed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            labelBreed.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
            
            labelLocation.topAnchor.constraint(equalTo: labelBreed.bottomAnchor, constant: 2),
            labelLocation.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            flippedImagePet.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            flippedImagePet.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            flippedImagePet.widthAnchor.constraint(equalToConstant: 150),
            flippedImagePet.heightAnchor.constraint(equalToConstant: 150),
            
            flippedLabelName.bottomAnchor.constraint(equalTo: flippedImagePet.bottomAnchor, constant: -45),
            flippedLabelName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),

            flippedLabelSex.topAnchor.constraint(equalTo: flippedLabelName.bottomAnchor,constant: 8),
            flippedLabelSex.leadingAnchor.constraint(equalTo: flippedImagePet.trailingAnchor,constant: 20),
            
            flippedLabelAge.topAnchor.constraint(equalTo: flippedLabelSex.topAnchor),
            flippedLabelAge.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            flippedLabelBreed.topAnchor.constraint(equalTo: flippedImagePet.bottomAnchor, constant: 20),
            flippedLabelBreed.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            flippedLabelBirthday.topAnchor.constraint(equalTo: flippedLabelBreed.bottomAnchor, constant: 8),
            flippedLabelBirthday.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            flippedLabelWeight.topAnchor.constraint(equalTo: flippedLabelBirthday.bottomAnchor, constant: 8),
            flippedLabelWeight.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            flippedLabelVaccinations.topAnchor.constraint(equalTo: flippedLabelWeight.bottomAnchor, constant: 8),
            flippedLabelVaccinations.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            flippedLabelDescriptions.topAnchor.constraint(equalTo: flippedLabelVaccinations.bottomAnchor, constant: 8),
            flippedLabelDescriptions.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            flippedLabelDescriptions.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
}


