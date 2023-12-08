//
//  MyPetsCollectionViewCell.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/5/23.
//

import UIKit

class MyPetsCollectionViewCell: UICollectionViewCell {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var deleteButtonTapCallback: (() -> Void)?
    
    let myPetsView = MyPetsView()
    let pageIndicator = UIPageControl()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var isDeleteButtonHidden: Bool = false {
        didSet {
            deleteButton.isHidden = isDeleteButtonHidden
        }
    }

     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(myPetsView)
         myPetsView.frame = contentView.bounds
         
         setupPageIndicator()

         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
         self.addGestureRecognizer(tapGesture)
         
         
         setupDeleteButton()


     }

    func setupDeleteButton() {
        self.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func didTapCell() {
        UIView.transition(with: myPetsView, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews, .preferredFramesPerSecond60], animations: {
            self.myPetsView.isFlipped.toggle()
            self.configureFlipState()
        })
    }

    private func configureFlipState() {
        let showFlipped = myPetsView.isFlipped
        myPetsView.imageView.isHidden = showFlipped
        myPetsView.labelName.isHidden = showFlipped
        myPetsView.labelBreed.isHidden = showFlipped
        myPetsView.labelSex.isHidden = showFlipped
        myPetsView.labelLocation.isHidden = showFlipped
        
        myPetsView.flippedImagePet.isHidden = !showFlipped
        myPetsView.flippedLabelName.isHidden = !showFlipped
        myPetsView.flippedLabelAge.isHidden = !showFlipped
        myPetsView.flippedLabelSex.isHidden = !showFlipped
        myPetsView.flippedLabelBreed.isHidden = !showFlipped
        myPetsView.flippedLabelBirthday.isHidden = !showFlipped
        myPetsView.flippedLabelWeight.isHidden = !showFlipped
        myPetsView.flippedLabelVaccinations.isHidden = !showFlipped
        myPetsView.flippedLabelDescriptions.isHidden = !showFlipped
    }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    @objc private func deleteButtonTapped() {
        showDeleteConfirmation()
    }

    private func showDeleteConfirmation() {
        // notify ViewController show confirmation
        deleteButtonTapCallback?()
    }
    
    private func setupPageIndicator() {
        contentView.addSubview(pageIndicator)
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        //disable tapping indicator
        pageIndicator.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            pageIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configureCell(with petData: PetData, pageIndex: Int, totalPages: Int, hideDeleteButton: Bool) {
        
        // Set the visibility of the delete button
        isDeleteButtonHidden = hideDeleteButton

        myPetsView.configure(with: petData.backgroundImageURL ?? "",
                             name: petData.name,
                             sex: petData.sex,
                             breed: petData.breed,
                             location: petData.location)
        

        let birthdayString = MyPetsCollectionViewCell.dateFormatter.string(from: petData.birthdayDate)
        
        let ageString = calculateAge(birthday: petData.birthdayDate)
        
        myPetsView.configureFlippedState(with: petData.petImageURL ?? "",
                                         name: petData.name,
                                         sex: petData.sex,
                                         age: ageString,
                                         breed: petData.breed,
                                         birthday: birthdayString,
                                         weight: petData.weight,
                                         vaccinations: petData.vaccinations,
                                         descriptions: petData.descriptions,
                                         email: petData.email ?? "")
        
        pageIndicator.numberOfPages = totalPages
        pageIndicator.currentPage = pageIndex
    }

    //calculate age from birthday
    private func calculateAge(birthday: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year, .month], from: birthday, to: now)
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        return "\(years) Y \(months) M"
    }
}



