//
//  Moment.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import Foundation
import FirebaseFirestore

struct Moment: Codable {
    @DocumentID var id: String?
    var userEmail: String?
    var name: String?
    var profileImageUrl: String?
    var text: String
    var imageUrls: [String: String]
    var timestamp: Date
    var likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case imageUrls
        case timestamp
        case likes
        // userEmail, name, and profileImageUrl are not in the moment document
    }

    init(userEmail: String?, name: String?, profileImageUrl: String?, text: String, imageUrls: [String: String], timestamp: Date, likes: [String]) {
        self.userEmail = userEmail
        self.name = name
        self.text = text
        self.profileImageUrl = profileImageUrl
        self.imageUrls = imageUrls
        self.timestamp = timestamp
        self.likes = likes
    }
}


