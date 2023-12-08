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
    
    var datePickerBDay: UIDatePicker!
    var textFieldWeight: UITextField!
    var textFieldVac: UITextField!
    var textFieldDescrip: UITextField!
    
    var labelHint: UILabel!
    var labelName: UILabel!
    var labelSex: UILabel!
    var labelBreed: UILabel!
    var labelBDay: UILabel!
    var labelWeight: UILabel!
    var labelCity: UILabel!
    var labelVac: UILabel!
    var labelDescrip: UILabel!


    var isCustomBackgroundImageSet = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColorBeige //set the background color
        
        //MARK: call methods to setup the attributes of UI elements
        setupPetBackgroudButton()
        setupPetPicButton()
        setupDisplayWrapper()
        setupTextFieldName()
        setupTextFieldSex()
        setupTextFieldBreed()
        setupTextFieldCity()
        setupDatePickerBDay()
        setupTextFieldWeight()
        setupTextFieldVac()
        setupTextFieldDescrip()
        
        setupLabelHint()
        setupLabelName()
        setupLabelSex()
        setupLabelBreed()
        setupLabelBDay()
        setupLabelWeight()
        setupLabelCity()
        setupLabelVac()
        setupLabelDescrip()

        
        //initializing the constraints
        initConstraints()
        
    }
    
    //MARK: defining the attributes
    func setupPetBackgroudButton() {
        petBackgroundButton = UIButton(type: .system)
        petBackgroundButton.backgroundColor = themeColor.withAlphaComponent(0.7)
        petBackgroundButton.layer.cornerRadius = 40
        petBackgroundButton.clipsToBounds = true
        petBackgroundButton.showsMenuAsPrimaryAction = true
        petBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(petBackgroundButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isCustomBackgroundImageSet, let image = UIImage(systemName: "pawprint.fill") {
            setButtonBackgroundImage(image: image, tintColor: .systemOrange)
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
        petPicButton.setTitle("", for: .normal)
        petPicButton.setImage(UIImage(systemName: "dog.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        petPicButton.tintColor = .white
        petPicButton.contentHorizontalAlignment = .fill
        petPicButton.contentVerticalAlignment = .fill
        petPicButton.imageView?.contentMode = .scaleAspectFill
        petPicButton.layer.cornerRadius = 75
        petPicButton.clipsToBounds = true
        petPicButton.showsMenuAsPrimaryAction = true
        petPicButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(petPicButton)
    }
    
    func setupDisplayWrapper(){
        displayWrapper = UIScrollView()
        displayWrapper.backgroundColor = .clear
        displayWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(displayWrapper)
    }
    
    func setupTextFieldName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "PawPal"
//        textFieldName.attributedPlaceholder = NSAttributedString(string: "Name",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textFieldName.borderStyle = .roundedRect
//        textFieldName.layer.borderColor = UIColor.white.cgColor // Set border color
//        textFieldName.layer.borderWidth = 2.0 // Set border width
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setupLabelHint(){
        labelHint = UILabel()
        labelHint.font = UIFont(name: secondTitleFont, size: 15)
        labelHint.textAlignment = .center
        labelHint.text = "Tap the background or icon to update the image"
        labelHint.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelHint)
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont(name: titleFont, size: 24)
        labelName.textAlignment = .left
        labelName.attributedText = NSAttributedString(string: "Name:", attributes: strokeTextAttributes)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }

    func setupTextFieldSex(){
        textFieldSex = UITextField()
        textFieldSex.placeholder = "Spayed, Neutered, Female, Male"
        textFieldSex.borderStyle = .roundedRect
        textFieldSex.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldSex)
    }
    
    func setupLabelSex(){
        labelSex = UILabel()
        labelSex.font = UIFont(name: titleFont, size: 20)
        labelSex.textAlignment = .left
        labelSex.text = "Sex:"
        labelSex.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelSex)
    }
    
    func setupTextFieldBreed(){
        textFieldBreed = UITextField()
        textFieldBreed.placeholder = "Husky, Golden Retriever, Mixed Breed, ..."
        textFieldBreed.borderStyle = .roundedRect
        textFieldBreed.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldBreed)
    }
    
    func setupLabelBreed() {
        labelBreed = UILabel()
        labelBreed.font = UIFont(name: titleFont, size: 20)
        labelBreed.textAlignment = .left
        labelBreed.text = "Breed:"
        labelBreed.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelBreed)
    }
    
    func setupTextFieldCity(){
        textFieldCity = UITextField()
        textFieldCity.placeholder = "City"
        textFieldCity.borderStyle = .roundedRect
        textFieldCity.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldCity)
    }
    
    func setupLabelCity() {
        labelCity = UILabel()
        labelCity.font = UIFont(name: titleFont, size: 20)
        labelCity.textAlignment = .left
        labelCity.text = "City:"
        labelCity.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelCity)
    }
    
    func setupDatePickerBDay(){
        datePickerBDay = UIDatePicker()
        datePickerBDay.datePickerMode = .date
        datePickerBDay.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(datePickerBDay)
    }
    
    func setupLabelBDay() {
        labelBDay = UILabel()
        labelBDay.font = UIFont(name: titleFont, size: 20)
        labelBDay.textAlignment = .left
        labelBDay.text = "Birthday:"
        labelBDay.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelBDay)
    }
    
    func setupTextFieldWeight(){
        textFieldWeight = UITextField()
        textFieldWeight.placeholder = "Weight"
        textFieldWeight.borderStyle = .roundedRect
        textFieldWeight.keyboardType = .numberPad
        textFieldWeight.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldWeight)
    }
    
    func setupLabelWeight() {
        labelWeight = UILabel()
        labelWeight.font = UIFont(name: titleFont, size: 20)
        labelWeight.textAlignment = .left
        labelWeight.text = "Weight:"
        labelWeight.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelWeight)
    }
    
    func setupTextFieldVac(){
        textFieldVac = UITextField()
        textFieldVac.placeholder = "Rabies, Distemper (DHPP), Bordetella, Lyme, ..."
        textFieldVac.borderStyle = .roundedRect
        textFieldVac.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldVac)
    }
    
    func setupLabelVac() {
        labelVac = UILabel()
        labelVac.font = UIFont(name: titleFont, size: 20)
        labelVac.textAlignment = .left
        labelVac.text = "Vaccination:"
        labelVac.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelVac)
    }
    
    func setupTextFieldDescrip(){
        textFieldDescrip = UITextField()
        textFieldDescrip.placeholder = "Share a bit about your dog's charms"
        textFieldDescrip.borderStyle = .roundedRect
        textFieldDescrip.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(textFieldDescrip)
    }
    
    func setupLabelDescrip() {
        labelDescrip = UILabel()
        labelDescrip.font = UIFont(name: titleFont, size: 20)
        labelDescrip.textAlignment = .left
        labelDescrip.text = "Description:"
        labelDescrip.translatesAutoresizingMaskIntoConstraints = false
        displayWrapper.addSubview(labelDescrip)
    }
    
        
    //MARK: initializing the constraints
    func initConstraints(){
        NSLayoutConstraint.activate([
            petBackgroundButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 126),
            petBackgroundButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -126),
            petBackgroundButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21),
            petBackgroundButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            petPicButton.topAnchor.constraint(equalTo: petBackgroundButton.topAnchor, constant: 16),
            petPicButton.leadingAnchor.constraint(equalTo: petBackgroundButton.leadingAnchor, constant: 16),
            petPicButton.widthAnchor.constraint(equalToConstant: 150),
            petPicButton.heightAnchor.constraint(equalToConstant: 150),
            
            labelHint.bottomAnchor.constraint(equalTo: displayWrapper.bottomAnchor, constant: 75),
            labelHint.leadingAnchor.constraint(equalTo: petBackgroundButton.leadingAnchor),
            labelHint.trailingAnchor.constraint(equalTo: petBackgroundButton.trailingAnchor),
            
            labelName.bottomAnchor.constraint(equalTo: textFieldName.topAnchor),
            labelName.leadingAnchor.constraint(equalTo: textFieldName.leadingAnchor),
//            labelName.trailingAnchor.constraint(equalTo: petBackgroundButton.trailingAnchor, constant: -16),
            
            textFieldName.bottomAnchor.constraint(equalTo: petPicButton.bottomAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: petPicButton.trailingAnchor, constant: 32),
            textFieldName.trailingAnchor.constraint(equalTo: petBackgroundButton.trailingAnchor, constant: -16),
            
            displayWrapper.topAnchor.constraint(equalTo: petPicButton.bottomAnchor, constant: 32),
            displayWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -212),
            displayWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 37),
            displayWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            
            labelSex.bottomAnchor.constraint(equalTo: textFieldSex.bottomAnchor, constant: -3),
            labelSex.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelSex.trailingAnchor.constraint(equalTo: labelSex.leadingAnchor, constant: 80),
            
            textFieldSex.topAnchor.constraint(equalTo: displayWrapper.topAnchor),
            textFieldSex.leadingAnchor.constraint(equalTo: labelSex.trailingAnchor),
            textFieldSex.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelBreed.bottomAnchor.constraint(equalTo: textFieldBreed.bottomAnchor, constant: -3),
            labelBreed.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelBreed.trailingAnchor.constraint(equalTo: labelBreed.leadingAnchor, constant: 80),
            
            textFieldBreed.topAnchor.constraint(equalTo: textFieldSex.bottomAnchor, constant: 16),
            textFieldBreed.leadingAnchor.constraint(equalTo: labelBreed.trailingAnchor),
            textFieldBreed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelBDay.bottomAnchor.constraint(equalTo: datePickerBDay.bottomAnchor, constant: -3),
            labelBDay.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelBDay.trailingAnchor.constraint(equalTo: labelBDay.leadingAnchor, constant: 80),
            
            datePickerBDay.topAnchor.constraint(equalTo: textFieldBreed.bottomAnchor, constant: 16),
            datePickerBDay.leadingAnchor.constraint(equalTo: labelBDay.trailingAnchor),
//            datePickerBDay.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelWeight.bottomAnchor.constraint(equalTo: textFieldWeight.bottomAnchor, constant: -3),
            labelWeight.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelWeight.trailingAnchor.constraint(equalTo: labelWeight.leadingAnchor, constant: 80),
            
            textFieldWeight.topAnchor.constraint(equalTo: datePickerBDay.bottomAnchor, constant: 16),
            textFieldWeight.leadingAnchor.constraint(equalTo: labelWeight.trailingAnchor),
            textFieldWeight.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelCity.bottomAnchor.constraint(equalTo: textFieldCity.bottomAnchor, constant: -3),
            labelCity.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelCity.trailingAnchor.constraint(equalTo: labelCity.leadingAnchor, constant: 80),
            
            textFieldCity.topAnchor.constraint(equalTo: textFieldWeight.bottomAnchor, constant: 16),
            textFieldCity.leadingAnchor.constraint(equalTo: labelCity.trailingAnchor),
            textFieldCity.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelVac.topAnchor.constraint(equalTo: textFieldCity.bottomAnchor, constant: 16),
            labelVac.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelVac.trailingAnchor.constraint(equalTo: labelVac.leadingAnchor, constant: 120),
            
            textFieldVac.topAnchor.constraint(equalTo: labelVac.bottomAnchor, constant: 16),
            textFieldVac.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            textFieldVac.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
            
            labelDescrip.topAnchor.constraint(equalTo: textFieldVac.bottomAnchor, constant: 16),
            labelDescrip.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            labelDescrip.trailingAnchor.constraint(equalTo: labelDescrip.leadingAnchor, constant: 120),
            
            textFieldDescrip.topAnchor.constraint(equalTo: labelDescrip.bottomAnchor, constant: 16),
            textFieldDescrip.bottomAnchor.constraint(equalTo: displayWrapper.bottomAnchor),
            textFieldDescrip.leadingAnchor.constraint(equalTo: displayWrapper.leadingAnchor),
            textFieldDescrip.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func getTimestamp() {
//        let selectedDate = datePickerBDay.date
//        let timestamp = selectedDate.timeIntervalSince1970
//        print("Selected Timestamp: \(timestamp)")
//    }
    
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

//extension UIImage {
//    func withAlpha(_ alpha: CGFloat) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        defer { UIGraphicsEndImageContext() }
//
//        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return nil }
//
//        context.scaleBy(x: 1, y: -1)
//        context.translateBy(x: 0, y: -size.height)
//
//        context.setBlendMode(.normal)
//        context.setAlpha(alpha)
//
//        let rect = CGRect(origin: .zero, size: size)
//        context.draw(cgImage, in: rect)
//
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//}
