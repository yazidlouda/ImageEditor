//
//  Image.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import Foundation

struct Images: Codable {
    let images: [Image]
}


struct Image: Codable {
    let url: String?
    let created: String?
    let updated: String?
   
    
}
