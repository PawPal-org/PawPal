//
//  MyPetsTableViewCell.swift
//  PawPal
//
//  Created by Cynthia Zhang on 11/20/23.
//

import UIKit

class MyPetsTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelSex: UILabel!
    var labelAge: UILabel!
    var labelWeight: UILabel!
    //MARK: declaring the ImageView for contact image
    var imagePet: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelName()
        setupLabelSex()
        setupLabelAge()
        setupLabelWeight()
        //MARK: defining the ImageView for contact image
        setupImagePet()
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.borderColor = UIColor.gray.cgColor
        wrapperCellView.layer.borderWidth = 1.0
        wrapperCellView.layer.cornerRadius = 5.0
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    func setupLabelSex(){
        labelSex = UILabel()
        labelSex.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelSex)
    }
    func setupLabelAge(){
        labelAge = UILabel()
        labelAge.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelAge)
    }
    func setupLabelWeight(){
        labelWeight = UILabel()
        labelWeight.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelWeight)
    }

    func setupImagePet(){
        imagePet = UIImageView()
        imagePet.image = UIImage(systemName: "dog")
        imagePet.contentMode = .scaleToFill
        imagePet.clipsToBounds = true
        imagePet.layer.cornerRadius = 10
        imagePet.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imagePet)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            imagePet.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            imagePet.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            //MARK: set the height and width of an ImageView with constraints
            imagePet.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            imagePet.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            labelName.leadingAnchor.constraint(equalTo: imagePet.trailingAnchor, constant: 8),
            labelName.heightAnchor.constraint(equalToConstant: 32),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelSex.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
            labelSex.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            //labelSex.heightAnchor.constraint(equalToConstant: 32),
            labelSex.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelAge.topAnchor.constraint(equalTo: labelSex.bottomAnchor, constant: 2),
            labelAge.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            //labelAge.heightAnchor.constraint(equalToConstant: 32),
            labelAge.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelWeight.topAnchor.constraint(equalTo: labelAge.bottomAnchor, constant: 2),
            labelWeight.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            //labelWeight.heightAnchor.constraint(equalToConstant: 32),
            labelWeight.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 104)
        ])
    }
    
    //MARK: unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
