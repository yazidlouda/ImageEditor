//
//  DisplayImageViewController.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import UIKit
import SDWebImage
class DisplayImageViewController: UIViewController, ImageDataDelegate , UICollectionViewDelegate, UICollectionViewDataSource{
    func didUpdateImages(allImages: [ImageModel]) {
        DispatchQueue.main.async {
            Model.imageModel = allImages
            self.imageCollectionView.reloadData()
        }
    }
    
     var arr : [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // arr.count
        Model.imageModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DisplayImageCollectionViewCell
        let sp = Model.imageModel[indexPath.row]
        cell.image.sd_setImage(with: URL(string: sp.url), placeholderImage:UIImage(named: "image1"))
        cell.layer.cornerRadius = 15
        cell.image.layer.cornerRadius = 15
        return cell
    }
    
   
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var networkHandler = NetworkHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.reloadData()
        networkHandler.imageDelegate = self
        print("Images",Model.imageModel.count)
        networkHandler.GetAllImages()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    


}
