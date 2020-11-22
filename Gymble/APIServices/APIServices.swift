//
//  APIServices.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("Users")
class APIServices: NSObject {
    static let sharedInstance = APIServices()
    let currentUID = Auth.auth().currentUser?.uid
    func fetchGymsListOnHome(completionHandler: @escaping ([GymsList]) -> Void){
        let url = "http://13.233.119.231:3000/getAllGyms"
        guard let safeURL = URL(string: url) else {return}
        URLSession.shared.dataTask(with: safeURL) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else{return}
            do{
                let jsonData = try JSONDecoder().decode([GymsList].self, from: safeData)
                DispatchQueue.main.async {
                    completionHandler(jsonData)
                }
                
            }catch let jsonErr{
                print(jsonErr.localizedDescription)
                return
            }
            
        }.resume()
        
        
    }
    
    func getGymDetails(gymID: String ,completionHandler: @escaping (GymDetails) -> Void){
        let urlString = "http://13.233.119.231:3000/getAllGyms/\(gymID)"
        guard let safeURL = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: safeURL) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            do{
                let jsonData = try JSONDecoder().decode(GymDetails.self, from: safeData)
                DispatchQueue.main.async {
                    completionHandler(jsonData)
                }
            }catch let jsonErr{
                print(jsonErr.localizedDescription)
                return
            }
        }.resume()
    }
    
    func fetchUserData(uid: String, completionHandler: @escaping(User) -> Void){
//        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictonary = snapshot.value as? [String: Any] else {return}
//            let userData = User(dictionary: dictonary)
//            DispatchQueue.main.async {
//                completionHandler(userData)
//            }
//
//        }
        let dataRef = Firestore.firestore().collection("Users").document(uid)
        dataRef.getDocument { (snapshot, err) in
            if err != nil{
                return
            }else{
                guard let dictonary = snapshot?.data() else {return}
                let userData = User(dictionary: dictonary)
                completionHandler(userData)
            }
        }
        
    }
    
//    func getUserData(uid: String, completionHandler: @escaping(User) -> Void){
//        let dataRef = Firestore.firestore().collection("Users").document(uid)
//        dataRef.getDocument { (snapshot, err) in
//            if err != nil{
//                return
//            }else{
//                guard let dictonary = snapshot?.data() else {return}
//                let userData = User(dictionary: dictonary)
//                completionHandler(userData)
//            }
//        }
//    }
    
    func checkForSlotBooking(date: String, userID: String, completionHandler: @escaping(CheckForbooking) -> Void){
        let url = "http://13.233.119.231:3000/getSlotsByDate2?user_id=\(userID)&date=\(date)"
        guard let safeURL = URL(string: url) else {return}
        URLSession.shared.dataTask(with: safeURL) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            DispatchQueue.main.async {
                do{
                    let jsonData = try JSONDecoder().decode(CheckForbooking.self, from: safeData)
                    completionHandler(jsonData)
                }catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
            }
        }.resume()
        
    }
    
    func fetchGymSlots(date: String, userID: String, completionHandler: @escaping(ShowSlotBookingSlots) -> Void){
        let url = "http://13.233.119.231:3000/getSlotsByDate2?user_id=\(userID)&date=\(date)"
        guard let safeURL = URL(string: url) else {return}
        URLSession.shared.dataTask(with: safeURL) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            DispatchQueue.main.async {
                do{
                    let jsondata = try JSONDecoder().decode(ShowSlotBookingSlots.self, from: safeData)
                    completionHandler(jsondata)
                }catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
            }
            
        }.resume()
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if let error = err{
                onError(error.localizedDescription)
                return
            }else{
                onSuccess()
            }
        }
    }
    
    func getTimeLineData(uid: String, completionHandler: @escaping([TimelineModel]) -> Void){
        guard let url = URL(string: "http://13.233.119.231:3000/timeline2?user_id=\(uid)") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            DispatchQueue.main.async {
                do{
                    let jsonData = try JSONDecoder().decode([TimelineModel].self, from: safeData)
                    completionHandler(jsonData)
                }catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
            }
        }.resume()
        
    }
    
    func getGymMembershipPrices(gymID: String, completionHandler: @escaping(GymMembershipPrices) -> Void){
        guard let url = URL(string: "http://13.233.119.231:3000/getGymSubcriptionDetails?gym_id=\(gymID)") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else {return}
            DispatchQueue.main.async {
                do{
                    let jsonData = try JSONDecoder().decode(GymMembershipPrices.self, from: safeData)
                    completionHandler(jsonData)
                }catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
            }
        }.resume()
        
    }
    
    
}
