//
//  FlightModal.swift
//  travel
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

struct FlightModal {
    var airlineMap : Dictionary<String,String>?
    var airportMap : Dictionary<String,String>?
    var flightsData : [FlightsDataModal]?
}


extension FlightModal: Mappable{
    static func create(airlineMap : Dictionary<String,String>?)(airportMap : Dictionary<String,String>?)(flightsData: [FlightsDataModal]?) -> FlightModal{
        let airlineMap = airlineMap ?? nil
        let airportMap = airportMap ?? nil
        let flightsData = flightsData ?? []
        return FlightModal(airlineMap : airlineMap,airportMap : airportMap, flightsData : flightsData)
    }
    
    static func Map(json: JSONObject) -> FlightModal?{
        return Parse(json) >>> { d in
            FlightModal.create
                <?> d <-?  AIRLINE_MAP
                <?> d <-?  AIRPORT_MAP
                <?> d <--?  FLIGHTS_DATA
        }
    }
}

