
//
//  DiscoverViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

class DiscoverViewController: UIViewController {
    
    var cardStack: [CardView] = []
    var likedCards: [CardView] = []
    var cardView: CardView!
    let db = Firestore.firestore()
    var currentUser: FirebaseAuth.User?
    var bgURL: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColorBeige
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "Discover"
        fetchPetsData()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }
    
    private func fetchPetsData() {
        db.collection("users").getDocuments { [weak self] (usersSnapshot, usersError) in
            if let error = usersError {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let self = self, let usersDocuments = usersSnapshot?.documents else { return }
            
            for userDocument in usersDocuments {
                let userEmail = userDocument.documentID
                self.db.collection("users").document(userEmail).collection("myPets").getDocuments { (petsSnapshot, petsError) in
                    if let error = petsError {
                        print("Error getting pets for user \(userEmail): \(error.localizedDescription)")
                        return
                    }
                        
                    guard let petsDocuments = petsSnapshot?.documents else { return }
        
                    for petDocument in petsDocuments {
                        self.processPetDocument(petDocument)
                    }
                }
            }
        }
    }
    
    func calculateDogAge(fromBirthdayTimestamp birthdayDate: Date) -> String {
        let calendar = Calendar.current
        //let birthdayDate = timestamp.dateValue()
        let currentDate = Date()

        let ageComponents = calendar.dateComponents([.year, .month], from: birthdayDate, to: currentDate)
        if let years = ageComponents.year, let months = ageComponents.month {
            return "\(years) Y \(months) M"
        } else {
            return "Age could not be calculated"
        }
    }
    
    private func processPetDocument(_ document: QueryDocumentSnapshot) {
        let petData = document.data()
        let petName = petData["name"] as? String ?? "Unknown"
        //let petAge = petData["age"] as? String ?? "Unknown"
        var petAge = ""
        let petBreed = petData["breed"] as? String ?? "Unknown"
        let petLocation = petData["location"] as? String ?? "Unknown"
        let petSex = petData["sex"] as? String ?? "Unknown"
        let petWeight = petData["weight"] as? String ?? "Unknown"
        let petDescriptions = petData["descriptions"] as? String ?? "Woof~ Woof~"
        let petVaccinations = petData["vaccinations"] as? String ?? "not uploaded yet"
        let petOwnerEmail = petData["email"] as? String ?? "no email"
        let petImageUrl = petData["backgroundImageURL"] as? String ?? "default"
        bgURL = petImageUrl
        let petIconUrl = petData["petImageURL"] as? String ?? "default"
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
        var petBirthday = "Unknown"
        if let tempBirthday = petData["birthday"] as? Timestamp {
            let date = tempBirthday.dateValue()
            petBirthday = dateFormatter.string(from: date)
            petAge = calculateDogAge(fromBirthdayTimestamp: date)
            
        }
        
        
        // Use the pet data to configure card view
        DispatchQueue.main.async {
            let cardView = self.createNewCardView()
            cardView.configure(with: petImageUrl, name: petName, sex: petSex, breed: petBreed, location: petLocation)
            cardView.configureFlippedState(
                with: petIconUrl,
                name: petName,
                sex: petSex,
                age: petAge,
                breed: petBreed,
                birthday: petBirthday,
                weight: petWeight,
                vaccinations: petVaccinations,
                descriptions: petDescriptions,
                email: petOwnerEmail
            )
            if petOwnerEmail != self.getCurrentUserEmail(){
                self.cardStack.append(cardView)
                self.view.addSubview(cardView)
                self.positionCard(cardView)
                self.setupBackground(for: cardView)
                self.setupGestures(for: cardView)
                cardView.flippedButtonIcon.addTarget(self, action: #selector(self.flippedButtonIconTapped(sender:)), for: .touchUpInside)
            }
                
            // Bring the top card to front after all cards have been added
            if let lastCard = self.cardStack.last {
                self.view.bringSubviewToFront(lastCard)
            }
        }
    }
    
    @objc func flippedButtonIconTapped(sender: UIButton) {
        guard let card = sender.superview as? CardView else {
            print("Card not found")
            return
        }

        guard let ownerEmail = card.ownerEmail.text else {
            print("Owner email not found")
            return
        }
        
        fetchUserName(ownerEmail: ownerEmail) { [weak self] userName in
            guard let strongSelf = self else { return }

            let MyMomentScreen = MyMomentsViewController()
            MyMomentScreen.userEmail = ownerEmail
            MyMomentScreen.userName = userName
            strongSelf.currentUser = Auth.auth().currentUser
            MyMomentScreen.currentUser = strongSelf.currentUser
            strongSelf.navigationController?.pushViewController(MyMomentScreen, animated: true)
        }
    }

    func fetchUserName(ownerEmail: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(ownerEmail).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }

            guard let document = documentSnapshot, document.exists else {
                print("User document not found")
                completion(nil)
                return
            }

            let userName = document.get("name") as? String
            completion(userName)
        }
    }

    
    

    private func createNewCardView() -> CardView {
        let cardSize = CGSize(width: 350, height: 600)
        let cardViewTemp = CardView(frame: CGRect(x: (view.frame.width - cardSize.width) / 2,
                                              y: (view.frame.height - cardSize.height) / 2,
                                              width: cardSize.width,
                                              height: cardSize.height))
        return cardViewTemp
    }

    private func positionCard(_ cardView: CardView) {
        // Optionally, apply slight transformations for a stacked look
    }

    //MARK: Drag and Swipe
    private func setupGestures(for cardView: CardView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cardView.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func setupBackground(for card: CardView){
        guard let url = URL(string: card.petImageURL) else {
                print("Invalid URL")
                return
        }
        print(url)
        
        card.backgroundImageView.kf.setImage(with: url){ result in
            switch result {
            case .success(let value):
                var tempImage = value.image
                print("tempImagetype:\(type(of: tempImage))")
                var tempImageRounded = self.imageWithRoundedCorners(image: tempImage, radius: 40)
                card.layer.contents = tempImageRounded!.withRenderingMode(.alwaysOriginal).cgImage
                
            case .failure(let error):
                print("Error setting background: \(error.localizedDescription)")
            }
        }
    }
    
    func imageWithRoundedCorners(image: UIImage, radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: image.size)

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        context?.addPath(path.cgPath)
        context?.clip()

        image.draw(in: rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return roundedImage
    }

    
    func getCurrentUserEmail() -> String {
        //return pp1@pp.com
        return UserDefaults.standard.string(forKey: "currentUserEmail")!.lowercased()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView else { return }

        let translation = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)

        if sender.state == .ended {
            if translation.x > 100 { // Threshold for right swipe
                animateCard(card: card, translation: 500) // Swipe right
                likedCards.append(card)
                //print(likedCards)
                //MARK: Adding Friends
                let currEmail = getCurrentUserEmail()
                print(getCurrentUserEmail())
                var targetEmail = ""
                if let ownerEmail = card.ownerEmail.text{
                    targetEmail = ownerEmail
                }
                print(targetEmail)
                if currEmail == targetEmail{
                    print("can't send self friend request")
                }else{
                    sendFriendRequest(currentEmail: currEmail, petOwnerEmail: targetEmail)
                }
                
                
            } else if translation.x < -100 { // Threshold for left swipe
                animateCard(card: card, translation: -500) // Swipe left
            } else {
                // Return to original position if not swiped far enough
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                }
            }

            if let topCard = cardStack.popLast() {
                showNextCard()
            }
        }
    }

    func sendFriendRequest(currentEmail: String, petOwnerEmail: String) {
        let usersCollectionRef = Firestore.firestore().collection("users")
        let petOwnerDocRef = usersCollectionRef.document(petOwnerEmail)
            
        // Create a timestamp
        let timestamp = FieldValue.serverTimestamp()

        // First, get the current friend requests
        petOwnerDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var currentRequests = document.get("friendsRequest") as? [String: Any] ?? [:]

                // Check if the user is already a friend or has already sent a request
                if currentRequests[currentEmail] != nil {
                    let alertController = UIAlertController(title: nil, message: "You alreay sent a request", preferredStyle: .alert)
                            self.present(alertController, animated: true) {
                                // 在两秒后自动消失
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    alertController.dismiss(animated: true, completion: nil)
                                }
                            }
                    print("The user is already a friend or request is pending.")
                } else {
                    // Add the new friend request
                    currentRequests[currentEmail] = timestamp

                    // Update the document with the new friend requests
                    petOwnerDocRef.updateData(["friendsRequest": currentRequests]) { error in
                        if let error = error {
                            print("Error adding friend request: \(error.localizedDescription)")
                        } else {
                            let alertController = UIAlertController(title: nil, message: "Request has been sent", preferredStyle: .alert)
                                    self.present(alertController, animated: true) {
                                        // 在两秒后自动消失
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            alertController.dismiss(animated: true, completion: nil)
                                        }
                                    }
                            print("Friend request with timestamp sent successfully.")
                        }
                    }
                }
            } else if let error = error {
                print("Error getting document: \(error.localizedDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }

    
    func checkIfEmailIsAlreadyAFriend(currentEmail: String, petOwnerEmail: String, completion: @escaping (Bool) -> Void) {
        let usersCollectionRef = Firestore.firestore().collection("users")
        let petOwnerDocRef = usersCollectionRef.document(petOwnerEmail)

        petOwnerDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let document = document, document.exists {
                let friendsArray = document.data()?["friends"] as? [String] ?? []
                if friendsArray.contains(currentEmail) {
                    print("\(currentEmail) is already a friend.")
                    completion(true)
                } else {
                    print("\(currentEmail) is not in the friends array.")
                    completion(false)
                }
            } else {
                print("Document does not exist.")
                completion(false)
            }
        }
    }

    
    private func showNextCard() {
        if let nextCard = cardStack.last {
            view.bringSubviewToFront(nextCard)
        } else {
            displayEmptyCard() // Call this when no cards are left
        }
    }

    @objc func flipCard(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view as? CardView else { return }

        UIView.transition(with: card, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews, .preferredFramesPerSecond60], animations: {
            // Change the content of the card to show detailed information
            card.isFlipped.toggle()
            card.clipsToBounds = true
            let showFlipped = card.isFlipped
            card.imageView.isHidden = showFlipped
            card.labelName.isHidden = showFlipped
            card.labelBreed.isHidden = showFlipped
            card.labelSex.isHidden = showFlipped
            card.labelLocation.isHidden = showFlipped
            
            card.flippedButtonIcon.isHidden = !showFlipped
            card.flippedLabelName.isHidden = !showFlipped
            card.flippedLabelAge.isHidden = !showFlipped
            card.flippedLabelSex.isHidden = !showFlipped
            card.flippedLabelBreed.isHidden = !showFlipped
            card.flippedLabelBirthday.isHidden = !showFlipped
            card.flippedLabelWeight.isHidden = !showFlipped
            card.flippedLabelVaccinations.isHidden = !showFlipped
            card.flippedLabelDescriptions.isHidden = !showFlipped
        })
    }

    private func animateCard(card: CardView, translation: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            card.center.x += translation
        }) { _ in
            card.removeFromSuperview()
        }
    }

    private func displayEmptyCard() {
        let emptyCard = createNewCardView()
        emptyCard.backgroundColor = .lightGray // Different background for empty card
        view.addSubview(emptyCard)
        positionCard(emptyCard)

        let resetButton = UIButton(frame: CGRect(x: 75, y: 150, width: 200, height: 50))
        resetButton.setTitle("View Deck Again", for: .normal)
        resetButton.addTarget(self, action: #selector(resetDeck), for: .touchUpInside)
        resetButton.backgroundColor = .systemBlue
        emptyCard.addSubview(resetButton)
        print(likedCards)
        
    }

    @objc func resetDeck() {
        // Remove existing card views from the superview
        for card in cardStack {
            card.removeFromSuperview()
        }
        // Clear the arrays
        cardStack.removeAll()
        likedCards.removeAll()

        // Setup the card stack again
        //setupCardStack()
        fetchPetsData()
    }
}

