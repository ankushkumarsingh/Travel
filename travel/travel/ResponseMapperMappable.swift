//
//  ResponseMapperMappable.swift
//  travel
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

protocol Mappable{
    typealias MappableType = Self
    static func Map(json: JSONObject) -> Self?
}

extension Mappable{
    static func parsingFailNotification(){
        print("Unable to parse \"\(self)\" as few required values are missing in JSON")
    }
}
