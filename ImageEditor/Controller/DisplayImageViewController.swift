//
//  DisplayImageViewController.swift
//  ImageEditor
//
//  Created by Home on 11/8/21.
//

import UIKit
import SDWebImage
class DisplayImageViewController: UIViewController, ImageDataDelegate , UICollectionViewDelegate, UICollectionViewDataSource{
    
    func didUpdateImages(allImages: [Image]) {
        DispatchQueue.main.async {
            Model.images = allImages
            self.imageCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("images = ", Model.images.count)
//        return Model.images.count
        Model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DisplayImageCollectionViewCell
        let sp = Model.images[indexPath.row]
        cell.image.sd_setImage(with: URL(string: sp.url!), placeholderImage:UIImage(named: "image1"))
        cell.name.text = "Yazid"
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
        networkHandler.GetAllImages()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    


}
