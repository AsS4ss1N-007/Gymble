//
//  GymbleModels.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

struct GymsList: Codable {
    let _id: String?
    let gym_name: String?
    let gym_image: String?
    let subscription_fees: String?
    let address: String?
}

struct GymDetails: Codable {
    let _id: String?
    let gym_name: String?
    let gym_image: String?
    let subscription_fees: String?
    let description: String?
    let address: String?
    let images_array: [HeroImagesData]?
    let Amenities: [AmenityData]?
    let Trainers: [TrainersData]?
    let morning_slots: [MorningSlotsData]?
    let evening_slots: [EveningSlotsData]?
}

struct HeroImagesData: Codable {
    let _id: String?
    let image: String?
}

struct AmenityData: Codable {
    let _id: String?
    let amenity: String?
    let amenity_image: String?
}

struct TrainersData: Codable {
    let _id: String?
    let trainer_name: String?
    let trainer_description: String?
    let trainer_image: String?
}

struct MorningSlotsData: Codable {
    let _id: String?
    let start_time: String?
}

struct EveningSlotsData: Codable {
    let _id: String?
    let start_time: String?
}

struct SlotBooking: Codable {
    let _id: String?
    let gym_id: String
    let gym_name: String?
    let date: String?
    let morning_slots: [GymMorningSlots]?
    let evening_slots: [GymEveningSlots]?
}
struct GymMorningSlots: Codable {
    let _id: String?
    let start_time: String?
    let end_time: String?
    let available_slots: Int?
}

struct GymEveningSlots: Codable {
    let _id: String?
    let start_time: String?
    let end_time: String?
    let available_slots: Int?
}

