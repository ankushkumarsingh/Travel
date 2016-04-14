//
//  ResponseMapperOperator.swift
//  travel
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation


infix operator >>> { associativity left precedence 150 } // bind
infix operator <^> { associativity left } // Functor's fmap (usually <^>)
infix operator <?> { associativity left } // Applicative's apply

infix operator <-  { associativity left precedence 150 } // Map direct values
infix operator <-? { associativity left precedence 150 } // Map optional Values
infix operator <<-? { associativity left precedence 150 } // Map optional Values - Neasted level

infix operator <-- { associativity left precedence 150 } // Map Array Values
infix operator <--? { associativity left precedence 150 } // Map Array Values
infix operator <<--? { associativity left precedence 150 } // Map Array Values - Neasted level

infix operator <-> { associativity left precedence 150 } // Map Modal object
infix operator <->? { associativity left precedence 150 } // Map Modal object
infix operator <<->? { associativity left precedence 150 } // Map Modal object - Neasted level

infix operator <|> { associativity left precedence 150 } // Map Modal object
infix operator <|>? { associativity left precedence 150 } // Map Modal object
infix operator <<|>? { associativity left precedence 150 } // Map Modal object - Neasted level


infix operator <> { associativity left precedence 150 } // Map Modal object
infix operator <>? { associativity left precedence 150 } // Map Modal object

/// Functor map
func <^><A, B>(f: A -> B, a: A?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

/// Functor Apply
func <?><A, B>(f: (A -> B)?, a: A?) -> B? {
    if let x = a, let function = f {
        return function(x)
    }
    return .None
}

/// Bind
func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    }
    return .None
}

/// Purify the value
func pure<A>(a: A) -> A? {
    return .Some(a)
}


/// Map Individual Values
func <-<A>(object: JSONDictionary, key: String) -> A? {
    return object[key] >>> Parse
}

/// Map Individual Values
func <-?<A>(object: JSONDictionary, key: String) -> A?? {
    return pure(object[key] >>> Parse)
}


/// Map Individual Optional Values
func <<-?<A>(object: JSONDictionary?, key: String) -> A?? {
    if let value = object {
        return pure(value[key] >>> Parse)
    } else {
        return object as? A
    }
}

/// Map Array of Modal object
func <--<A: Mappable>(object: JSONDictionary, key: String) -> [A]? {
    return object <- key >>> { (array: JSONArray) in
        array.map { $0 >>> ParseArray }
        } >>> { flatten($0) }
}

/// Map Array of Modal object
func <--?<A: Mappable>(object: JSONDictionary, key: String) -> [A]?? {
    return pure(object <- key >>> { (array: JSONArray) in
        array.map { $0 >>> ParseArray }
        } >>> { flatten($0) })
}

/// Map optional Array of Modal object
func <<--?<A: Mappable>(object: JSONDictionary?, key: String) -> [A]?? {
    if let value = object {
        return pure(value <- key >>> { (array: JSONArray) in
            array.map { $0 >>> ParseArray }
            } >>> { flatten($0) })
    } else {
        return object as? [A]
    }
}


/// Map Dictionary to Modal Object
func <-><A: Mappable>(object: JSONDictionary, key: String) -> A? {
    return object[key] >>> ParseArray
}

/// Map Dictionary to Modal Object
func <->?<A: Mappable>(object: JSONDictionary, key: String) -> A?? {
    return pure(object[key] >>> ParseArray)
}

/// Map Optional Dictionary to Modal Object
func <<->?<A: Mappable>(object: JSONDictionary?, key: String) -> A?? {
    if let value = object {
        return pure(value[key] >>> ParseArray)
    } else {
        return object as? A
    }
}


/// Map value from an Array
func <|><A>(object: JSONArray, key: Int) -> A? {
    if object.count <= key {
        return object as? A
    } else {
        return object[key] >>> Parse
    }
}

/// Map unwrapped value from an Array
func <|>?<A>(object: JSONArray, key: Int) -> A?? {
    if object.count <= key {
        return object as? A
    }else {
        return pure(object[key] >>> Parse)
    }
}

/// Map value from an optional Array
func <<|>?<A>(object: JSONArray?, key: Int) -> A?? {
    if let value = object {
        if value.count <= key {
            return object as? A
        }else {
            return pure(value[key] >>> Parse)
        }
    } else {
        return object as? A
    }
}


/// Assign Static Values
func <><A, T>(object: JSONDictionary, key: T) -> A? {
    return key as? A
}

/// Assign Static Values
func <>?<A, T>(object: JSONDictionary?, key: T) -> A?? {
    return pure(key as? A)
}


func flatten<A>(array: [A?]) -> [A] {
    var list: [A] = []
    for item in array {
        if let i = item {
            list.append(i)
        }
    }
    return list
}

