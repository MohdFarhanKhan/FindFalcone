//
//  Velocity.swift
//  FalconFind
//
//  Created by Najran Emarah on 11/09/1444 AH.
//

import Foundation
import Combine
class Velocity:Codable,Equatable{
    
    static func == (lhs: Velocity, rhs: Velocity) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var total_no: Int
    var max_distance: Int
    var speed: Int
   
    init(name: String, total_no: Int, max_distance: Int, speed: Int) {
        self.name = name
        self.total_no = total_no
        self.max_distance = max_distance
        self.speed = speed
    }
   
}

struct AuthToken : Decodable {
    let token: String
}



