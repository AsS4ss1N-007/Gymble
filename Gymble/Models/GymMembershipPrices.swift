//
//  GymMembershipPrices.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 02/10/20.
//

import UIKit
struct GymMembershipPrices: Codable {
    let _id: String?
    let gym_name: String?
    let subscriptions: [Prices]
}

struct Prices: Codable {
    let _id: String?
    let duration: Int?
    let price: String?
}
