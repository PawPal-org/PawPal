//
//  PetData.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PetData: Codable {
    @DocumentID var id: String?
    var name: String
    var sex: String
    var breed: String
    var location: String
    var birthday: Timestamp
    var weight: String
    var vaccinations: String
    var descriptions: String
    var email: String?
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
        case email
        case backgroundImageURL = "backgroundImageURL"
        case petImageURL = "petImageURL"
    }

    var birthdayDate: Date {
        return birthday.dateValue()
    }


    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        sex = try values.decode(String.self, forKey: .sex)
        breed = try values.decode(String.self, forKey: .breed)
        location = try values.decode(String.self, forKey: .location)
        birthday = try values.decode(Timestamp.self, forKey: .birthday)
        weight = try values.decode(String.self, forKey: .weight)
        vaccinations = try values.decode(String.self, forKey: .vaccinations)
        descriptions = try values.decode(String.self, forKey: .descriptions)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        backgroundImageURL = try values.decodeIfPresent(String.self, forKey: .backgroundImageURL)
        petImageURL = try values.decodeIfPresent(String.self, forKey: .petImageURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(sex, forKey: .sex)
        try container.encode(breed, forKey: .breed)
        try container.encode(location, forKey: .location)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(weight, forKey: .weight)
        try container.encode(vaccinations, forKey: .vaccinations)
        try container.encode(descriptions, forKey: .descriptions)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(backgroundImageURL, forKey: .backgroundImageURL)
        try container.encodeIfPresent(petImageURL, forKey: .petImageURL)
    }
}
