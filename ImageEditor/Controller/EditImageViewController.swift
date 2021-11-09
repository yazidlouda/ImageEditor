//
//  EditImageViewController.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import UIKit
import SDWebImage
import CoreImage
class EditImageViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

}
