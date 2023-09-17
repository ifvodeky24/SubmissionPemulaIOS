//
//  RestaurantModel.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 11/06/23.
//

import Foundation
import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class Restaurant {
    let id: String
    let name: String
    let description: String
    let pictureId: URL
    let city: String
    let rating: Double
    var image : UIImage?
    var state: DownloadState = .new
    
    init(id: String, name: String, description: String, pictureId: URL, city: String, rating: Double, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.pictureId = pictureId
        self.city = city
        self.rating = rating
        self.image = image
    }
}

struct RestaurantResponses: Codable {
    let error: Bool
    let message: String
    let count: Int
    let restaurants: [RestaurantResponse]
    
    init(error: Bool, message: String, count: Int, restaurants: [RestaurantResponse]) {
        self.error = error
        self.message = message
        self.count = count
        self.restaurants = restaurants
    }
}

struct RestaurantResponse: Codable {
    let id: String
    let name: String
    let description: String
    let pictureId: URL
    let city: String
    let rating: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Menentukan alamat gambar
        let path = try container.decode(String.self, forKey: .pictureId)
        pictureId = URL(string: "https://restaurant-api.dicoding.dev/images/medium/\(path)")!
        
        // Untuk properti lainnya, cukup disesuaikan saja.
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        city = try container.decode(String.self, forKey: .city)
        rating = try container.decode(Double.self, forKey: .rating)
    }
}

struct RestaurantDetailResponses: Codable {
    let error: Bool
    let message: String
    let restaurant: RestaurantDetailResponse
    
    init(error: Bool, message: String, restaurant: RestaurantDetailResponse) {
        self.error = error
        self.message = message
        self.restaurant = restaurant
    }
}

struct RestaurantDetailResponse: Codable {
    let id: String
    let name: String
    let description: String
    let city: String
    let address: String
    let pictureId: URL
    let categories: [Categories]
    let rating: Double
    let customerReviews: [CustomerReviews]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.city = try container.decode(String.self, forKey: .city)
        self.address = try container.decode(String.self, forKey: .address)
        let path = try container.decode(String.self, forKey: .pictureId)
        pictureId = URL(string: "https://restaurant-api.dicoding.dev/images/medium/\(path)")!
        self.categories = try container.decode([Categories].self, forKey: .categories)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.customerReviews = try container.decode([CustomerReviews].self, forKey: .customerReviews)
    }
}

class RestaurantDetail{
    let id: String
    let name: String
    let description: String
    let city: String
    let address: String
    let pictureId: URL
    let categories: [Categories]
    let rating: Double
    let customerReviews: [CustomerReviews]
    var image : UIImage?
    var state: DownloadState = .new
    
    init(id: String, name: String, description: String, city: String, address: String, pictureId: URL, categories: [Categories], rating: Double, customerReviews: [CustomerReviews], image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.city = city
        self.address = address
        self.pictureId = pictureId
        self.categories = categories
        self.rating = rating
        self.customerReviews = customerReviews
        self.image = image
    }
}

struct Categories: Codable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct CustomerReviews: Codable {
    let name: String
    let review: String
    let date: String
    
    init(name: String, review: String, date: String){
        self.name = name
        self.review = review
        self.date = date
    }
}
