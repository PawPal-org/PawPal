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
    var name: String?
    var profileImageUrl: String?
    var text: String
    var imageUrls: [String: String]
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl
        case text
        case imageUrls
        case timestamp
        // name is not in the moment document
    }

    init(name: String?, text: String, profileImageUrl: String?, imageUrls: [String: String], timestamp: Date) {
        self.name = name
        self.text = text
        self.profileImageUrl = profileImageUrl
        self.imageUrls = imageUrls
        self.timestamp = timestamp
    }
}

