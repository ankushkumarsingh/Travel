//
//  FlightsDataModal.swift
//  travel
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

struct FlightsDataModal {
    var originCode : String = ""
    var destinationCode : String = ""
    var takeoffTime : String = ""
    var landingTime : String = ""
    var price : String = ""
    var airlineCode : String  = ""
    var planeClass :String = ""
}

extension FlightsDataModal : Mappable {
    
    static func create(originCode : String?)(destinationCode : String?)(takeoffTime : String?)(landingTime : String?)(price : String?)(airlineCode : String?)(planeClass : String?) -> FlightsDataModal {
        
        let originCode = originCode ?? ""
        let destinationCode = destinationCode ?? ""
        let takeoffTime = takeoffTime ?? ""
        let landingTime = landingTime ?? ""
        let price = price ?? ""
        let airlineCode  = airlineCode ?? ""
        let planeClass  = planeClass ?? ""
        
        return FlightsDataModal(originCode : originCode, destinationCode : destinationCode, takeoffTime : takeoffTime,landingTime : landingTime,price : price, airlineCode : airlineCode, planeClass: planeClass)
    }
    
    static func Map(json: JSONObject) -> FlightsDataModal? {
        return Parse(json) >>> { d in
            FlightsDataModal.create
                <?> d <-?  ORIGIN_CODE
                <?> d <-?  DESTINATION_CODE
                <?> d <-?  TAKEOFF_TIME
                <?> d <-?  LANDING_TIME
                <?> d <-?  PRICE
                <?> d <-?  AIRLINE_CODE
                <?> d <-?  CLASS
        }
    }
    
}
