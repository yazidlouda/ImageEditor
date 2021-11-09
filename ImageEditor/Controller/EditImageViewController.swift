//
//  EditImageViewController.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import UIKit
import SDWebImage
import CoreImage
import Alamofire
//import SwiftyJSON

class EditImageViewController: UIViewController {
    @IBOutlet weak var smallView: UIView!
    
    struct Filter{
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init (filterName: String, filterEffectValue: Any?, filterEffectValueName: String?){
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
      
    }
    
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        guard let cgImage = image.cgImage,
              let openGLContext = EAGLContext(api: .openGLES3) else{
            return nil
        }
        let context = CIContext(eaglContext : openGLContext)
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filterEffectValue = filterEffect.filterEffectValue,
           let filterEffectValueName = filterEffect.filterEffectValueName{
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        var filteredImage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
           let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        return filteredImage
    }
    
    @IBOutlet weak var image: UIImageView!
    private var originalImage: UIImage?
    var currentImage: ImageModel?
    var myImage: Image?
    var email = "yazidlouda15@gmail.com"
    var file = "photo1"
    override func viewDidLoad() {
        super.viewDidLoad()
        smallView.layer.cornerRadius = 10
        image.sd_setImage(with: URL(string: (currentImage?.url)!), placeholderImage:UIImage(named: "image1"))
        originalImage = image.image
        // Do any additional setup after loading the view.
    }
    @IBAction func applySepia(_ sender: Any) {
        guard let imageView = image.image else{
            return
        }
        image.image = applyFilterTo(image: imageView, filterEffect: Filter(filterName: "CISepiaTone",filterEffectValue: 0.70 , filterEffectValueName: kCIInputIntensityKey))
    }
    @IBAction func applyTransferEffect(_ sender: Any) {
        guard let imageView = image.image else{
            return
        }
        image.image = applyFilterTo(image: imageView, filterEffect: Filter(filterName: "CIPhotoEffectProcess",filterEffectValue: nil , filterEffectValueName: nil))
    }
    @IBAction func applyBlackEffect(_ sender: Any) {
        guard let imageView = image.image else{
            return
        }
        image.image = applyFilterTo(image: imageView, filterEffect: Filter(filterName: "CIPhotoEffectNoir",filterEffectValue: nil , filterEffectValueName: nil))
    }
    @IBAction func applyBlur(_ sender: Any) {
        guard let imageView = image.image else{
            return
        }
        image.image = applyFilterTo(image: imageView, filterEffect: Filter(filterName: "CIGaussianBlur",filterEffectValue: 8.0 , filterEffectValueName: kCIInputRadiusKey))
    }
    @IBAction func clearFilters(_ sender: Any) {
        image.image = originalImage
    }
    @IBAction func saveAndSendImage(_ sender: Any) {
        uploadImage(image: image.image!)
    }
    func uploadImage( image: UIImage) {
       let url = "https://eulerity-hackathon.appspot.com/_ah/upload/AMmfu6aqB5GMdgY4bFSFU2TTAQ5lD1SXmIsMvZ1Jjvnb5HPn1mWgt2i0tvORSQIhC0elt8jq85vpYZtsbzZ_3SHlmOuDCzl_aL4ANEQHUfFWjaeXoDbl7ueIcn3hhtXIoD3sX9PUQgOtBOpyHQKnJ_H8S64idIunpVGtrC7eqzq6YuabWYYO-oWPLW3j55SFbR2hbtjvpmo3q9EGeVaWY1lzTG-Vx39r7g/ALBNUaYAAAAAYYr9ZvPPhJYdNcBMl4aMTYdLvU39DCxT"
        guard let endpoint = URL(string: url) else {
                    print("Error creating endpoint")
                    return
            }
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        // generate boundary string using a unique per-app string
        let boundary = "Boundary-\(UUID().uuidString)"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mimeType = "image/jpg"
        let params: [String : String?] = ["appid" : "yazidlouda15@gmail.com", "url": currentImage?.url]
        let session = URLSession.shared
        let filename = "image1"
        var data = Data()
        for (key, value) in params{
            data.append("Content-Disposition: form-data; name=\"\(key)\"r\n\r\n".data(using: .utf8)!)
            data.append("\(value ?? "")\r\n".data(using: .utf8)!)
        }
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1.0)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(data)
        data.append("\r\n".data(using: .utf8)!)
        data.append(" — ".appending(boundary.appending(" — ")).data(using: .utf8)!)


        // Send a POST request to the URL, with the data we created
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                  print(json)
                }
            }
        }).resume()
    }

}