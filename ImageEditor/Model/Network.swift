//
//  Network.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import Foundation
import Alamofire


protocol ImageDataDelegate {
    func didUpdateImages(allImages : [Image])
}

struct NetworkHandler{
    
    var imageDelegate: ImageDataDelegate?
    
    func GetAllImages() {
        var arr: [Image] = []
        let urlString = "https://eulerity-hackathon.appspot.com/image"
        let request = AF.request(urlString)
        request.responseDecodable(of: Image.self){ (response) in
            if let data = response.value{
               
                    arr.append(data)
                
                
                
                
            }
            self.imageDelegate?.didUpdateImages(allImages: arr)
            print("array = ", arr)
        }
        
    }
    
    
}
