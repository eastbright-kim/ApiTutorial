//
//  Photo.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/29.
//

import Foundation

struct Photo: Codable {
    
    var thumb: String
    var username: String
    var likescount: Int
    var createdAt: String
    
}
