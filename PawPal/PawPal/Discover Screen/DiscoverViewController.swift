
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
        
    private func processPetDocument(_ document: QueryDocumentSnapshot) {
        let petData = document.data()
        let petName = petData["name"] as? String ?? "Unknown"
        let petAge = petData["age"] as? String ?? "Unknown"
        let petBreed = petData["breed"] as? String ?? "Unknown"
        let petLocation = petData["location"] as? String ?? "Unknown"
        let petSex = petData["sex"] as? String ?? "Unknown"
        let petWeight = petData["weight"] as? String ?? "Unknown"
        let petDescriptions = petData["descriptions"] as? String ?? "Woof~ Woof~"
        let petVaccinations = petData["vaccinations"] as? String ?? "not uploaded yet"
        let petOwnerEmail = petData["email"] as? String ?? "no email"
        let petImageUrl = petData["backgroundImageURL"] as? String ?? "default"
        let petIconUrl = petData["petImageURL"] as? String ?? "default"
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
        var petBirthday = "Unknown"
        if let tempBirthday = petData["birthday"] as? Timestamp {
            let date = tempBirthday.dateValue()
            petBirthday = dateFormatter.string(from: date)
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
            
            self.cardStack.append(cardView)
            self.view.addSubview(cardView)
            self.positionCard(cardView)
            self.setupGestures(for: cardView)
            cardView.flippedButtonIcon.addTarget(self, action: #selector(self.flippedButtonIconTapped(sender:)), for: .touchUpInside)
                
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
    
    func getCurrentUserEmail() -> String {
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
                sendFriendRequest(currentEmail: currEmail, petOwnerEmail: targetEmail)
                
                
                
                
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

        // Create a dictionary with the current email as key and the timestamp as value
        let friendRequestUpdate = ["\(currentEmail)": timestamp]
        // Update the document with the friend request
        checkIfEmailIsAlreadyAFriend(currentEmail: currentEmail, petOwnerEmail: petOwnerEmail) { isFriend in
            if isFriend {
                print("The user is already a friend.")
            } else {
                print("The user is not a friend yet. Sending Request...")
                petOwnerDocRef.updateData([
                    "friendsRequest": friendRequestUpdate]) { error in
                    if let error = error {
                        print("Error adding friend request: \(error.localizedDescription)")
                    } else {
                        print("Friend request with timestamp sent successfully.")
                    }
                }
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

        UIView.transition(with: card, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            // Change the content of the card to show detailed information
            card.isFlipped.toggle()
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

