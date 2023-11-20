//
//  CardView.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit

class CardView: UIView {
    
    
    //MARK: Variables for cards' front
    let imageView = UIImageView()
    let labelName = UILabel()
    let labelSex = UILabel()
    let labelBreed = UILabel()
    let labelLocation = UILabel()
    //MARK: Variables for cards' back
    let flippedButtonIcon = UIButton()
    let flippedLabelName = UILabel()
    let flippedLabelSex = UILabel()
    let flippedLabelAge = UILabel()
    let flippedLabelBreed = UILabel()
    let flippedLabelBirthday = UILabel()
    let flippedLabelWeight = UILabel()
    let flippedLabelVaccinations = UILabel()
    let flippedLabelDescriptions = UILabel()
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
        addSubview(labelName)
        addSubview(labelSex)
        addSubview(labelBreed)
        addSubview(labelLocation)
        

        setupImageView()
        setupLabelName()
        setupLabelSex()
        setupLabelBreed()
        setupLabelLocation()
    }
    
    private func setupFlippedStateSubviews(){
        addSubview(flippedButtonIcon)
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
        setupFlippedButtonIcon()
        setupFlippedLabelAge()
        setupFlippedLabelBreed()
        setupFlippedLabelBirthday()
        setupFlippedLabelWeight()
        setupFlippedLabelVaccinations()
        setupFlippedLabelDescriptions()
        
        flippedButtonIcon.isHidden = true
        flippedLabelName.isHidden = true
        flippedLabelSex.isHidden = true
        flippedLabelAge.isHidden = true
        flippedLabelBreed.isHidden = true
        flippedLabelBirthday.isHidden = true
        flippedLabelWeight.isHidden = true
        flippedLabelVaccinations.isHidden = true
        flippedLabelDescriptions.isHidden = true
    }
    
    

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLabelName() {
        labelName.font = UIFont(name: titleFont, size: 30)
        labelName.textAlignment = .center
        labelName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelSex(){
        labelSex.font = UIFont(name: normalFont, size: 25)
        labelSex.textAlignment = .right
        labelSex.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelBreed() {
        labelBreed.font = UIFont(name: normalFont, size: 20)
        labelBreed.numberOfLines = 0
        labelBreed.textAlignment = .left
        labelBreed.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabelLocation() {
        labelLocation.font = UIFont(name: lightFont, size: 16)
        labelLocation.numberOfLines = 0
        labelLocation.textAlignment = .left
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupFlippedButtonIcon(){
        
        flippedButtonIcon.setBackgroundImage(UIImage(systemName: "dog.circle"), for: .normal)
        flippedButtonIcon.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupFlippedLabelName() {
        //flippedLabelName.font = UIFont.boldSystemFont(ofSize: 30)
        flippedLabelName.font = UIFont(name: "Noteworthy-Light", size: 30)
        flippedLabelName.textAlignment = .right
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

    func configure(with image: UIImage, name: String, sex: String, breed: String, location: String) {
        imageView.image = image
        labelName.text = name
        labelSex.text = sex
        labelBreed.text = breed
        labelLocation.text = location
    }
    
    func configureFlippedState(with image: UIImage, name: String, sex: String, age: String, breed: String,
                               birthday: String, weight: String, vaccinations: String, descriptions: String){
        flippedButtonIcon.setImage(image, for: .normal)
        flippedLabelName.text = name
        flippedLabelSex.text = "\(sex)"
        flippedLabelAge.text = "\(age)"
        flippedLabelBreed.text = "Breed: \(breed)"
        flippedLabelBirthday.text = "Birthday: \(birthday)"
        flippedLabelWeight.text = "Weight: \(weight)\n"
        flippedLabelVaccinations.text = "Vaccinations: \n\(vaccinations)"
        flippedLabelDescriptions.text = "\n\(descriptions)"
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
            
            flippedButtonIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            flippedButtonIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            flippedButtonIcon.widthAnchor.constraint(equalToConstant: 150),
            flippedButtonIcon.heightAnchor.constraint(equalToConstant: 150),
            
            flippedLabelName.bottomAnchor.constraint(equalTo: flippedButtonIcon.bottomAnchor, constant: -40),
            flippedLabelName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),

            flippedLabelSex.topAnchor.constraint(equalTo: flippedLabelName.bottomAnchor,constant: 8),
            flippedLabelSex.leadingAnchor.constraint(equalTo: flippedLabelName.leadingAnchor),
            
            flippedLabelAge.topAnchor.constraint(equalTo: flippedLabelSex.topAnchor),
            flippedLabelAge.trailingAnchor.constraint(equalTo: flippedLabelName.trailingAnchor),
            
            flippedLabelBreed.topAnchor.constraint(equalTo: flippedButtonIcon.bottomAnchor, constant: 20),
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
