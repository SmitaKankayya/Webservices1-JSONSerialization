//
//  JsonPlaceHolder.swift
//  JSON_Serialization_Assignment
//
//  Created by Smita Kankayya on 19/12/23.
//

import Foundation
struct Albums{
    var userId, id : Int
    var title : String
}

struct Photos{
    var id : Int
    var title : String
    var url : String
}

struct Todos{
    var id : Int
    var title : String
    var completed : Bool
    
}

struct Comments{
    var id : Int
    var name, email, body : String
}

