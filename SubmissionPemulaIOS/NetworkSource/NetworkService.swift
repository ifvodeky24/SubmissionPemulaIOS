//
//  NetworkSrevice.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 11/06/23.
//

import Foundation

class NetworkService {
    func getRestaurants() async throws -> [Restaurant] {
        let components = URLComponents(string: "https://restaurant-api.dicoding.dev/list")!
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(RestaurantResponses.self, from: data)
        
        return restaurantMapper(input: result.restaurants)
    }
    
    func getRestaurantDetail(id: String) async throws -> RestaurantDetail {
        let components = URLComponents(string: "https://restaurant-api.dicoding.dev/detail/\(id)")!
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(RestaurantDetailResponses.self, from: data)
        
        let restaurantDetail = RestaurantDetail(id: result.restaurant.id, name: result.restaurant.name, description: result.restaurant.description, city: result.restaurant.city, address: result.restaurant.address, pictureId: result.restaurant.pictureId, categories: result.restaurant.categories, rating: result.restaurant.rating, customerReviews: result.restaurant.customerReviews)
        
        return restaurantDetail
    }
}

extension NetworkService {
    fileprivate func restaurantMapper(
        input restaurantResponses: [RestaurantResponse]
    ) -> [Restaurant] {
        return restaurantResponses.map { result in
            return Restaurant(
                id: result.id,
                name: result.name,
                description: result.description,
                pictureId: result.pictureId,
                city: result.city,
                rating: result.rating)
        }
    }
}
