//
//  MyPetsViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit

class MyPetsViewController: UIViewController {
    
    //MARK: creating instance of DisplayView
    let myPetScreen = MyPetsView()
    
    var pets = [Pet]()

    //MARK: patch the view of the controller to the DisplayView
    override func loadView() {
        view = myPetScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "My Pets"

        myPetScreen.tableViewPet.separatorStyle = .none
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
        
        //MARK: patching the table view delegate and datasource to controller...
        myPetScreen.tableViewPet.delegate = self
        myPetScreen.tableViewPet.dataSource = self
        
        pets.append(Pet(name:"Sprite", sex: "Male, Neutered", age: "3 yrs", weight: "80 lbs"))
        pets.append(Pet(name:"Sprite", sex: "Male, Neutered", age: "3 yrs", weight: "80 lbs"))
    }
    
    @objc func onAddBarButtonTapped(){
        //navigationController?.pushViewController(, animated: <#T##Bool#>)
    }

}

extension MyPetsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pet", for: indexPath) as! MyPetsTableViewCell
        cell.labelName.text = pets[indexPath.row].name
        cell.labelSex.text = pets[indexPath.row].sex
        cell.labelAge.text = pets[indexPath.row].age
        cell.labelWeight.text = pets[indexPath.row].weight
        
        return cell
    }
    
    //MARK: deal with user interaction with a cell...
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
}
