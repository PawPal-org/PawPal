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
    var city: String
    var birthday: Date
    var weight: String
    var vaccinations: String
    var description: String
    var backgroundImageURL: String?
    var petImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sex
        case breed
        case city
        case birthday
        case weight
        case vaccinations
        case description
        case backgroundImageURL
        case petImageURL
    }

    init(name: String, sex: String, breed: String, city: String, birthday: Date, weight: String, vaccinations: String, description: String, backgroundImageURL: String? = nil, petImageURL: String? = nil) {
        self.name = name
        self.sex = sex
        self.breed = breed
        self.city = city
        self.birthday = birthday
        self.weight = weight
        self.vaccinations = vaccinations
        self.description = description
        self.backgroundImageURL = backgroundImageURL
        self.petImageURL = petImageURL
    }
}
