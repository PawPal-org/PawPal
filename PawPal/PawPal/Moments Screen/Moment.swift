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
    var text: String
    var timestamp: Date
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case timestamp
        // name is not included (not in the moment document)
    }

    init(text: String, timestamp: Date, name: String?) {
        self.text = text
        self.timestamp = timestamp
        self.name = name
    }
}

