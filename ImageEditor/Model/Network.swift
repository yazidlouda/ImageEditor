//
//  Network.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import Foundation
import Alamofire


protocol ImageDataDelegate {
    func didUpdateImages(allImages : [ImageModel])
}

struct NetworkHandler{
    
    var imageDelegate: ImageDataDelegate?
    let urlString = "https://eulerity-hackathon.appspot.com/image"
    func GetAllImages()  {

        performRequest(urlString: urlString)
        
       
    }
    func performRequest(urlString: String) {
        // create URL
        if let url = URL(string: urlString){
        //Create URLSession
        let session = URLSession(configuration: .default)
        //Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let image = self.parseJSON(ImageData: safeData){
                        self.imageDelegate?.didUpdateImages(allImages: image)
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }
    func parseJSON(ImageData: Data) -> [ImageModel]? {
        var images: [ImageModel] = []
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode([Image].self, from: ImageData)
            
            for i in 0...decodedData.count - 1{
                let url = decodedData[i].url
                let created = decodedData[i].created
                let updated = decodedData[i].updated
                 images.append(ImageModel(url: url!, created: created!, updated: updated!))
            }
            
            
            
            
            return images
            
        } catch{
            print("failed with error:",error)
            
            return nil
        }
        
    }
   
    
    
}
