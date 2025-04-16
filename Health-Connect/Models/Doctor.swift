//
//  Doctor.swift
//  Health-Connect
//

//

import Foundation


struct TimeSlot {
    let time: String
    var isAvailable: Bool
}

typealias DoctorList = [DoctorModel]

// Individual doctor model
struct DoctorModel: Codable {
    let id: String
       let name: String
       let avatar: String
       let specialization: String
       let hospital: String
       let location: String
       let photo: String
       let createdAt: String
    
    
}



