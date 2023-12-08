//
//  MyPetsViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Kingfisher

class MyPetsViewController: UIViewController{
    
    var collectionView: UICollectionView!
    var pageIndicator = UIPageControl()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var petsData: [PetData] = []
    var currentUser: FirebaseAuth.User?
    var userEmail: String?
    
    var hideAddBarButton: Bool = false
    
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
            image: UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
        
        navigationItem.rightBarButtonItem?.isHidden = hideAddBarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCollectionView()
        configurePageIndicator()
        fetchPetsData()
        collectionView.delegate = self
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
//        layout.minimumLineSpacing = 40
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
                var pet = try? document.data(as: PetData.self)
                pet?.id = document.documentID
                return pet
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func deletePetAndImages(at indexPath: IndexPath) {
        let petToDelete = petsData[indexPath.row]

        guard let petId = petToDelete.id, !petId.isEmpty else {
            print("Error: Pet ID is empty.")
            return
        }
        
        //delete images from storage
        deleteImageFromStorage(url: petToDelete.petImageURL) { [weak self] in
            self?.deleteImageFromStorage(url: petToDelete.backgroundImageURL) {
                //delete pet info from firestore
                self?.deletePetFromFirestore(petId: petId, indexPath: indexPath)
            }
        }
    }

    func deleteImageFromStorage(url: String?, completion: @escaping () -> Void) {
        guard let urlString = url, let imageURL = URL(string: urlString) else {
            completion()
            return
        }

        let storageRef = Storage.storage().reference(forURL: imageURL.absoluteString)
        storageRef.delete { error in
            if let error = error {
                print("Error deleting image from storage: \(error)")
            } else {
                print("Image deleted successfully from storage")
            }
            completion()
        }
    }

    func deletePetFromFirestore(petId: String, indexPath: IndexPath) {
        let currentUserEmail = userEmail ?? Auth.auth().currentUser?.email ?? ""
        let userDocument = db.collection("users").document(currentUserEmail)
        userDocument.collection("myPets").document(petId).delete { [weak self] error in
            if let error = error {
                print("Error removing pet document: \(error)")
            } else {
                print("Pet document successfully removed!")
                // renew data and collectionView
                self?.petsData.remove(at: indexPath.row)
                self?.collectionView.deleteItems(at: [indexPath])
            }
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
