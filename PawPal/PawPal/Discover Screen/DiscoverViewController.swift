//
//  DiscoverViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/19/23.
//

import UIKit
import FirebaseFirestore

class DiscoverViewController: UIViewController {
    
    var cardStack: [CardView] = []
    var likedCards: [CardView] = []
    var cardView: CardView!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColorBeige
        title = "Discover"
        //setupCardStack()
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
            cardView.configure(with: UIImage(systemName: "pawprint.fill")!, name: petName, sex: petSex, breed: petBreed, location: petLocation)
            cardView.configureFlippedState(
                with: UIImage(systemName: "dog.circle")!,
                name: petName,
                sex: petSex,
                age: petAge,
                breed: petBreed,
                birthday: petBirthday,
                weight: petWeight,
                vaccinations: petVaccinations,
                descriptions: petDescriptions
            )
            
            self.cardStack.append(cardView)
            self.view.addSubview(cardView)
            self.positionCard(cardView)
            self.setupGestures(for: cardView)
                
            // Bring the top card to front after all cards have been added
            if let lastCard = self.cardStack.last {
                self.view.bringSubviewToFront(lastCard)
            }
        }
    }
    
    //A loop for creating random puppy info just for testing
    private func setupCardStack() {
        for i in 1...5 {
            let cardView = createNewCardView()
            var tempSexArray = ["He","She"]
            var tempBreedArray = ["Sibreian Husky", "Golden Retriver", "Border Collie", "Unknown"]
            
            cardView.configure(
                with: ((UIImage(systemName: "pawprint.fill") ?? UIImage(systemName: "cross"))!),
                name: "Puppy No.\(i)",
                sex: "\(tempSexArray[i%2])",
                breed: "\(tempBreedArray[i%4])",
                location: "San Jose"
            )
            cardView.configureFlippedState(
                with: ((UIImage(systemName: "dog.circle") ?? UIImage(systemName: "cross"))!),
                name: "Puppy No.\(i)",
                sex: "\(tempSexArray[i%2])",
                age: "3 yrs",
                breed: "\(tempBreedArray[i%4])",
                birthday: "July 24, 2021",
                weight: "80 lbs",
                vaccinations: "Bordetella Bronchiseptica\nCanine Distemper\nCanine Hepatitis\nCanine Parainfluenza",
                descriptions: "I would love to play with any other dogs!")
            
            cardStack.append(cardView)
            view.addSubview(cardView)
            positionCard(cardView)
            setupGestures(for: cardView)
        }
        view.bringSubviewToFront(cardStack.last!) // Bring the top card to front
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
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView else { return }

        let translation = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)

        if sender.state == .ended {
            if translation.x > 100 { // Threshold for right swipe
                animateCard(card: card, translation: 500) // Swipe right
                likedCards.append(card)
                print(likedCards)
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

