//
//  LogOutTableViewCell.swift
//  sketch
//
//  Created by Cynthia Zhang on 11/19/23.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var imageIcon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelTitle()
        setupImageIcon()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
//        wrapperCellView.layer.cornerRadius = 4.0
//        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
//        wrapperCellView.layer.shadowRadius = 2.0
//        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 20)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    
    func setupImageIcon(){
        imageIcon = UIImageView()
//        imageIcon.image = UIImage(systemName: "person.fill")
        imageIcon.contentMode = .scaleToFill
        imageIcon.clipsToBounds = true
//        imageIcon.layer.cornerRadius = 10
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageIcon)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 2),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 12),
            labelTitle.heightAnchor.constraint(equalToConstant: 30),
            labelTitle.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            imageIcon.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            imageIcon.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
//            imageIcon.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            imageIcon.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -16),
            imageIcon.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -16),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 46)
            
        ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
