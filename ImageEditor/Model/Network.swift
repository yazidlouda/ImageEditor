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

protocol ImageUploadURLDataDelegate {
    func didUpdateImageUploadURLs(allImages : ImageUploadURL)
}

struct NetworkHandler{
    var imageDelegate: ImageDataDelegate?
    var imageUploadURLDelegate : ImageUploadURLDataDelegate?
    let urlString = "https://eulerity-hackathon.appspot.com/image"
    let imageUploadURLString = "https://eulerity-hackathon.appspot.com/upload"
    func GetAllImages()  {
        performRequest(urlString: urlString)
        performRequestForImageUploadURL(urlString: imageUploadURLString)
       
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
    func performRequestForImageUploadURL(urlString: String) {
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
                    if let image = self.parseImageUploadURLJSON(ImageData: safeData){
                        self.imageUploadURLDelegate?.didUpdateImageUploadURLs(allImages: image)
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

    func parseImageUploadURLJSON(ImageData: Data) -> ImageUploadURL? {
        
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(ImageUpload.self, from: ImageData)
            
                let url = decodedData.url
                let images = ImageUploadURL(url: url)
                // images.append(ImageUploadURL(url: url!))
           
            return images
        } catch{
            print("failed with error:",error)
            
            return nil
        }
    }
}
