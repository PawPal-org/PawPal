//
//  AddPetView.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit

class AddPetView: UIView {

    //MARK: declaring the UI elements
    var petBackgroundButton: UIButton!
    var petPicButton: UIButton!
    var displayWrapper:UIScrollView!
    
    var textFieldName: UITextField!
    var textFieldSex: UITextField!
    var textFieldBreed: UITextField!
    var textFieldCity: UITextField!
    
    var textFieldBDay: UITextField!
    var textFieldWeight: UITextField!
    var textFieldVac: UITextField!
    var textFieldDescrip: UITextField!

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white //set the background color
        
        //MARK: call methods to setup the attributes of UI elements
        setupPetBackgroudButton()
        setupPetPicButton()
        setupDisplayWrapper()
        setupTextFieldName()
        setupTextFieldSex()
        setupTextFieldBreed()
        setupTextFieldCity()
        setupTextFieldBDay()
        setupTextFieldWeight()
        setupTextFieldVac()
        setupTextFieldDescrip()

        
        //initializing the constraints
        initConstraints()
        
    }
    
    //MARK: defining the attributes
    func setupPetBackgroudButton() {
        petBackgroundButton = UIButton(type: .system)
        petBackgroundButton.backgroundColor = .systemOrange
        petBackgroundButton.layer.cornerRadius = 40
        petBackgroundButton.clipsToBounds = true
        petBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(petBackgroundButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = UIImage(systemName: "pawprint.fill") {
            setButtonBackgroundImage(image: image, tintColor: .white)
        }
    }

    func setButtonBackgroundImage(image: UIImage, tintColor: UIColor) {
        let coloredImage = image.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        let buttonSize = petBackgroundButton.bounds.size // obtain button size
        if let resizedImage = coloredImage.resizedImageForButtonBackground(newSize: buttonSize) {
            petBackgroundButton.setBackgroundImage(resizedImage, for: .normal)
        }
    }


    func setupPetPicButton() {
        petPicButton = UIButton(type: .system)
        petPicButton.setBackgroundImage(UIImage(systemName: "dog.circle"), for: .normal)
        petPicButton.tintColor = .systemOrange
        petPicButton.translatesAutoresizingMaskIntoConstraints = false
        petBackgroundButton.addSubview(petPicButton)
    }
    
    func setupDisplayWrapper(){
        displayWrapper = UIScrollView()
        displayWrapper.backgroundColor = .clear
        displayWrapper.translatesAutoresizingMaskIntoConstraints = false
        petBackgroundButton.addSubview(displayWrapper)
    }
    
    func setupTextFieldName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldName)
    }

    func setupTextFieldSex(){
        textFieldSex = UITextField()
        textFieldSex.placeholder = "Sex"
        textFieldSex.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldSex)
    }
    
    func setupTextFieldBreed(){
        textFieldBreed = UITextField()
        textFieldBreed.placeholder = "Breed"
        textFieldBreed.borderStyle = .roundedRect
        textFieldBreed.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldBreed)
    }
    
    func setupTextFieldCity(){
        textFieldCity = UITextField()
        textFieldCity.placeholder = "City"
        textFieldCity.borderStyle = .roundedRect
        textFieldCity.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldCity)
    }
    
    func setupTextFieldBDay(){
        textFieldBDay = UITextField()
        textFieldBDay.placeholder = "Birthday"
        textFieldBDay.borderStyle = .roundedRect
        textFieldBDay.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldBDay)
    }
    
    func setupTextFieldWeight(){
        textFieldWeight = UITextField()
        textFieldWeight.placeholder = "Weight"
        textFieldWeight.borderStyle = .roundedRect
        textFieldWeight.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldWeight)
    }
    
    func setupTextFieldVac(){
        textFieldVac = UITextField()
        textFieldVac.placeholder = "Vac"
        textFieldVac.borderStyle = .roundedRect
        textFieldVac.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldVac)
    }
    
    func setupTextFieldDescrip(){
        textFieldDescrip = UITextField()
        textFieldDescrip.placeholder = "Description"
        textFieldDescrip.borderStyle = .roundedRect
        textFieldDescrip.keyboardType = .numberPad
        textFieldDescrip.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldDescrip)
    }
    
    
    
        
    //MARK: initializing the constraints
    func initConstraints(){
        NSLayoutConstraint.activate([
            petBackgroundButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 126),
            petBackgroundButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -126),
            petBackgroundButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21),
            petBackgroundButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            petPicButton.topAnchor.constraint(equalTo: petBackgroundButton.topAnchor, constant: 32),
            petPicButton.leadingAnchor.constraint(equalTo: petBackgroundButton.leadingAnchor, constant: 23),
            petPicButton.widthAnchor.constraint(equalToConstant: 130),
            petPicButton.heightAnchor.constraint(equalToConstant: 130),

            
            
            
            
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage {
    func resizedImageForButtonBackground(newSize: CGSize) -> UIImage? {
        let widthRatio = newSize.width / self.size.width
        let heightRatio = newSize.height / self.size.height
        
        let scaleFactor = max(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: self.size.width * scaleFactor,
            height: self.size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(
                x: (newSize.width - scaledImageSize.width) / 2,
                y: (newSize.height - scaledImageSize.height) / 2,
                width: scaledImageSize.width,
                height: scaledImageSize.height
            ))
        }
    }
}
