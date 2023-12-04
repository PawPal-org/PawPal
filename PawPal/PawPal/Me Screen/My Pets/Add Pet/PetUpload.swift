//
//  PetUpload.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import Foundation
import FirebaseFirestore

struct PetUpload: Codable {
    @DocumentID var id: String?
    var name: String
    var sex: String
    var breed: String
    var location: String
    var birthday: Date
    var weight: String
    var vaccinations: String
    var descriptions: String
    var backgroundImageURL: String?
    var petImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sex
        case breed
        case location
        case birthday
        case weight
        case vaccinations
        case descriptions
        case backgroundImageURL
        case petImageURL
    }

    init(name: String, sex: String, breed: String, location: String, birthday: Date, weight: String, vaccinations: String, descriptions: String, backgroundImageURL: String? = nil, petImageURL: String? = nil) {
        self.name = name
        self.sex = sex
        self.breed = breed
        self.location = location
        self.birthday = birthday
        self.weight = weight
        self.vaccinations = vaccinations
        self.descriptions = descriptions
        self.backgroundImageURL = backgroundImageURL
        self.petImageURL = petImageURL
    }
}
