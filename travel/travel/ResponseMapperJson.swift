//
//  ResponseMapperJson.swift
//  travel
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONObject]

func ParseArray<A: Mappable>(object: JSONObject) -> A? {
    return A.Map(object)
}

func Parse<A>(object: JSONObject) -> A? {
    return object as? A
}


extension String: Mappable {
    static func Map(json: JSONObject) -> String? {
        return json as? String
    }
}

extension Bool: Mappable {
    static func Map(json: JSONObject) -> Bool? {
        return json as? Bool
    }
}

extension Int: Mappable {
    static func Map(json: JSONObject) -> Int? {
        return json as? Int
    }
}
