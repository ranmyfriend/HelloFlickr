//
//  ViewController.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/4/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import FlickrKit

class ViewController: UIViewController {

    //MARK: - iVars
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            let albumNib:UINib = UINib.init(nibName: AlbumCell.reuseIdentifier(), bundle: nil)
            self.collectionView.register(albumNib, forCellWithReuseIdentifier: AlbumCell.reuseIdentifier())
            let albumDetailNib:UINib = UINib.init(nibName: AlbumDetailCell.reuseIdentifier(), bundle: nil)
            self.collectionView.register(albumDetailNib, forCellWithReuseIdentifier: AlbumDetailCell.reuseIdentifier())
            self.collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier())
        }
    }
    
    fileprivate lazy var photos:[Photo] = []
    fileprivate var tappedRowItem:Int = -1
    fileprivate var loadingView: LoadingView?
    fileprivate var currentPage:Int = 1
    fileprivate var hasMorePages:Bool = false
    fileprivate let itemsPerRow = 4

    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader()
        self.getRandomFotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private functions
    fileprivate func getRandomFotos() {
        let flickrInteresting = FKFlickrInterestingnessGetList()
        flickrInteresting.per_page = "15"
        flickrInteresting.extras = "description,date_upload,geo,views"
        flickrInteresting.page = currentPage.description
        FlickrKit.shared().call(flickrInteresting) { (response, error) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingView()
                if (error != nil) {
                    self.hasMorePages = false
                    let alert = self.buildAlert(with: "Hello Flickr", message: error?.localizedDescription ?? "Error while Loading Random Photos")
                    self.present(alert, animated: true, completion: nil)
                }else {
                    let topPhotos = response?["photos"] as! [String: Any]
                    let photoArray = topPhotos["photo"] as! [[String: Any]]
                    if photoArray.count == 15 {
                        self.hasMorePages = true
                    }else {
                        self.hasMorePages = false
                    }

                    for photoDictionary in photoArray {
                        let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.largeSquare150, fromPhotoDictionary: photoDictionary)
                        var copied:[String:Any] = photoDictionary
                        copied["url"] = photoURL
                        let photo = Photo.init(inputDictionary: copied)
                        self.photos.append(photo)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    private func showLoader(_ message:String="Loading...") {
        self.loadingView = LoadingView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        self.loadingView?.backgroundColor = UIColor.rgba(fromHex: 0xFFFFFF, alpha: 0.5)
        if (UIApplication.shared.keyWindow?.subviews.contains(self.loadingView!))! == false {
            UIApplication.shared.keyWindow?.addSubview(self.loadingView!)
        }
        UIApplication.shared.keyWindow?.bringSubview(toFront: self.loadingView!)
        self.loadingView?.lblLoadingMessage?.text = message
        self.loadingView?.startAnimatingLoader()
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            // Safer zone to find the loading view and remove it from SuperView
            var found = false
            for subview in (UIApplication.shared.keyWindow?.subviews)! {
                if subview is LoadingView {
                    found = true
                    subview.removeFromSuperview()
                    break
                }
            }
            if !found {
                debugPrint("self.loading does not contain any superview")
            }
            
            self.loadingView?.removeFromSuperview()
            self.loadingView?.stopAnimatingLoader()
        }
    }

    private func buildAlert(with title:String,message:String)->UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        return alert
    }
}

//MARK: - Extension|UICollectionViewDelegate&DataSource
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasMorePages == true {
            return self.photos.count+1
        }
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.hasMorePages && photos.count == indexPath.row {
            let cell:LoadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier(), for: indexPath) as! LoadingCell
            cell.showLoader()
            return cell
        }else if indexPath.row == tappedRowItem {
            let cell:AlbumDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailCell.reuseIdentifier(), for: indexPath) as! AlbumDetailCell
            let photo = self.photos.filter({ p in
                p.selected == true
            }).first
            cell.populateCell(with: photo!)
            return cell
        }else {
            let cell:AlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier(), for: indexPath) as! AlbumCell
            let url = self.photos[indexPath.row]
            cell.populateCell(with: url)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.photos.count == indexPath.row {
            return
        }
        let photo = self.photos[indexPath.row]
        if photo.selected == true {
            photo.selected = false
            self.tappedRowItem = -1
        }else {
            let row = indexPath.item/itemsPerRow
            if row == 0 {
                self.tappedRowItem = itemsPerRow
            }else {
                self.tappedRowItem = row*itemsPerRow+itemsPerRow
            }
            self.photos.forEach { (p) in
                p.selected = false
            }
            photo.selected = true
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((UIScreen.main.bounds.size.width/CGFloat(itemsPerRow)))
        if self.hasMorePages && self.photos.count == indexPath.row {
            return CGSize(width:width,height:width)
        }else if indexPath.row == self.tappedRowItem {
            return CGSize(width:UIScreen.main.bounds.size.width,height:150)
        }else {
            return CGSize(width: width, height: width)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photos.count && self.hasMorePages == true){
            self.currentPage += 1
            self.getRandomFotos()
        }
    }
}

