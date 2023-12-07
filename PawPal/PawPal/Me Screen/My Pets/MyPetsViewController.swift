//
//  MyPetsViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

class MyPetsViewController: UIViewController{
    
    var collectionView: UICollectionView!
    var pageIndicator = UIPageControl()
    let db = Firestore.firestore()
    var petsData: [PetData] = []
    var currentUser: FirebaseAuth.User?
    
    //MARK: creating instance of DisplayView
    let myPetScreen = MyPetsView()
    

    //MARK: patch the view of the controller to the DisplayView
    override func loadView() {
        view = myPetScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureCollectionView()
        configurePageIndicator()
        fetchPetsData()
        collectionView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "My Pets"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(onAddBarButtonTapped)
        )
        
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // make sure layout has been loaded
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let horizontalInset = (view.frame.width - layout.itemSize.width) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        layout.minimumLineSpacing = 40

        collectionView.collectionViewLayout.invalidateLayout()
    }

    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 350, height: 600)
//        layout.minimumLineSpacing = 50
//        let horizontalInset = (view.frame.width - layout.itemSize.width) / 2
//        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        
        collectionView.register(MyPetsCollectionViewCell.self, forCellWithReuseIdentifier: "MyPetsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
    }
    
    @objc func onAddBarButtonTapped(){
        let addPetController = AddPetViewController()
        navigationController?.pushViewController(addPetController, animated: true)
    }
    
    private func fetchPetsData() {
        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
        

        db.collection("users").document(currentUserEmail).collection("myPets").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching pets: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No pets found")
                return
            }
            
            self?.petsData = documents.compactMap { document -> PetData? in
                // Assuming the document can be directly decoded into PetData
                try? document.data(as: PetData.self)
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
    
    private func configurePageIndicator() {
        pageIndicator.numberOfPages = petsData.count
        pageIndicator.currentPage = 0
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        //disable tapping indicator
        pageIndicator.isUserInteractionEnabled = false
        view.addSubview(pageIndicator)
        
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    

}
