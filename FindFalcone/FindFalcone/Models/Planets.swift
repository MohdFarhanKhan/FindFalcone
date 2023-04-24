//
//  Planets.swift
//  FalconFind
//
//  Created by Najran Emarah on 16/09/1444 AH.
//

import Foundation
enum HTTPError: LocalizedError {
    case statusCode
    case post
}
class Planet:Codable,Equatable{
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var distance: Int
    
    init(name: String, distance: Int) {
        self.name = name
        self.distance = distance
       
    }
   
}
class SuccessPlanet:Codable{
    var planetName:String
    var status: String
    init(planet_name:String, status: String){
        self.planetName = planet_name
        self.status = status
    }
     enum CodingKeys : String, CodingKey {
            case planetName = "planet_name", status = "status"
        }
    
}

