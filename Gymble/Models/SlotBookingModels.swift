//
//  SlotBookingModels.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
struct CheckForbooking: Codable {
    let is_active: Bool
    let booked: Bool
    let already_booked: SlotDetails?
}

struct SlotDetails: Codable {
    let _id: String?
    let user_id: String?
    let customer_name: String?
    let gym_id: String?
    let gym_name: String?
    let date: String?
    let slot_id: String?
    let time: String?
    let booking_status: Bool?
    let check_in_status: Bool?
}

struct ShowSlotBookingSlots: Codable {
    let is_active: Bool?
    let booked: Bool?
    let days_left: Int?
    let slots: ShowSlots?
}

struct ShowSlots: Codable {
    let _id: String?
    let gym_id: String?
    let gym_name: String?
    let day: Int?
    let slots: [SlotsData]?
}

struct SlotsData: Codable {
    let _id: String?
    let start_time: String?
    let available_slots: Int?
}
