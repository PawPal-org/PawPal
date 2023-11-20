//
//  DiscoverViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var cardStack: [CardView] = []
    var likedCards: [CardView] = []
    var cardView: CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 233/255, alpha: 1.0)
        title = "Discover"
        setupCardStack()
        
    }

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

    private func setupGestures(for cardView: CardView) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        cardView.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        cardView.addGestureRecognizer(swipeLeft)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
        cardView.addGestureRecognizer(tapGesture)

    }

    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        guard let topCard = cardStack.popLast(), let senderView = sender.view as? CardView else { return }

        switch sender.direction {
        case .right:
            likedCards.append(senderView)
            print(likedCards)
            animateCard(card: topCard, translation: 500) // Swipe right
        case .left:
            animateCard(card: topCard, translation: -500) // Swipe left
        default:
            break
        }

        showNextCard()
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

        UIView.transition(with: card, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
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
        setupCardStack()
    }
}

