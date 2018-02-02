//
//  ViewController.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/4/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import FlickrKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView_Albums: UICollectionView! {
        didSet {
            self.collectionView_Albums.delegate = self
            self.collectionView_Albums.dataSource = self
            let albumNib:UINib = UINib.init(nibName: AlbumCell.reuseIdentifier(), bundle: nil)
            self.collectionView_Albums.register(albumNib, forCellWithReuseIdentifier: AlbumCell.reuseIdentifier())
            let albumDetailNib:UINib = UINib.init(nibName: AlbumDetailCell.reuseIdentifier(), bundle: nil)
            self.collectionView_Albums.register(albumDetailNib, forCellWithReuseIdentifier: AlbumDetailCell.reuseIdentifier())
            self.collectionView_Albums.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier())
        }
    }
    
    lazy var photos:[Photo] = []
    var tappedRowItem:Int = -1
    var albumCellMidValue:CGFloat = 0
    internal var loadingView: LoadingView?
    fileprivate var currentPage:Int = 1
    fileprivate var hasMorePages:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingViewWithMessage(message: "Loading...")
        self.getRandomFotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private functions
    fileprivate func getRandomFotos() {
        let flickrInteresting = FKFlickrInterestingnessGetList()
        flickrInteresting.per_page = "15"
        flickrInteresting.extras = "description,date_upload,geo"
        flickrInteresting.page = currentPage.description
        FlickrKit.shared().call(flickrInteresting) { (response, error) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingView()
                if (response != nil) {
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
                    self.collectionView_Albums.reloadData()
                }
            }
        }
    }
    
    public func showLoadingViewWithMessage(message:String) {
        self.loadingView = LoadingView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
        self.loadingView?.backgroundColor = UIColor.rgba(fromHex: 0xFFFFFF, alpha: 0.5)
        if (UIApplication.shared.keyWindow?.subviews.contains(self.loadingView!))! == false {
            UIApplication.shared.keyWindow?.addSubview(self.loadingView!)
        }
        UIApplication.shared.keyWindow?.bringSubview(toFront: self.loadingView!)
        
        if(message.isEmpty == false) {
            self.loadingView?.lblLoadingMessage?.text = message
        }
        self.loadingView?.startAnimatingLoader()
    }
    
    public func hideLoadingView() {
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
    func fetchPhotoLocation(for photo:Photo) {

        guard let latitude = photo.geo_latitude,
            let longitude = photo.geo_longitude else { return  }

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.places.findByLatLon&api_key=46606a4138ae73154f81868e904c1617&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"

        self.showLoadingViewWithMessage(message: "Loading...")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            self.hideLoadingView()
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                let response = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                let root = response?["places"] as! [String: Any]
                let places = root["place"] as! [[String:Any]]
                let place = Place.init(object: places.first!)
                photo.place = place
                DispatchQueue.main.async {
                    self.collectionView_Albums.reloadData()
                }
            }
        })

        dataTask.resume()
    }
}

extension ViewController {
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
            cell.startAnimatingCell()
            return cell
        }else if indexPath.row == tappedRowItem {
            let cell:AlbumDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailCell.reuseIdentifier(), for: indexPath) as! AlbumDetailCell
            cell.populateCell(with: self.photos[indexPath.row])
            cell.lc_upwardImgeViewLeading.constant = albumCellMidValue
            cell.layoutIfNeeded()
            return cell
        }else {
            let cell:AlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier(), for: indexPath) as! AlbumCell
            let url = self.photos[indexPath.row]
            cell.populateCell(with: url)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        if tappedRowItem != -1 {
            photo.selected = false
            let item = self.photos[tappedRowItem]
            item.selected = false
            self.photos.remove(at: tappedRowItem)
            tappedRowItem = -1
            self.collectionView_Albums.reloadData()
            return
        }else if indexPath.row == 0 {
            photo.selected = true
            self.tappedRowItem = indexPath.row + 2
            self.photos.insert(photo, at: self.tappedRowItem)
            let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? AlbumCell
            albumCellMidValue = (cell?.contentView.frame.midX)!
        }else if indexPath.row == self.photos.count-1{
            photo.selected = true
            self.tappedRowItem = indexPath.row + 1
            self.photos.insert(photo, at: self.tappedRowItem)
            albumCellMidValue = UIScreen.main.bounds.width/2
        }else {
            photo.selected = true
            let index = indexPath.row + 1
            if index%2 == 0 {
                self.tappedRowItem = indexPath.row + 1
                let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? AlbumCell
                albumCellMidValue = (cell?.contentView.frame.midX)!+UIScreen.main.bounds.width/2
            }else {
                self.tappedRowItem = indexPath.row + 2
                let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? AlbumCell
                albumCellMidValue = (cell?.contentView.frame.midX)!
            }
            self.photos.insert(photo, at: self.tappedRowItem)
        }
        
        self.collectionView_Albums.reloadData()
        if self.photos[self.tappedRowItem].place == nil {
            self.fetchPhotoLocation(for: self.photos[self.tappedRowItem])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.hasMorePages && self.photos.count == indexPath.row {
            return CGSize(width:UIScreen.main.bounds.size.width,
                          height:LoadingCell.getHeight())
        }else if indexPath.row == self.tappedRowItem {
            return CGSize(width:UIScreen.main.bounds.size.width,height:150)
        }else {
            let width = ((UIScreen.main.bounds.size.width / 2))
            return CGSize(width: width , height: width)
        }
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

extension Dictionary {
    subscript(string key: Key) -> String? {
        get {
            return self[key] as? String
        }
    }
    subscript(json key: Key) -> [String:Any]? {
        get {
            return self[key] as? [String:Any]
        }
    }
    subscript(double key: Key) -> Double? {
        get {
            return self[key] as? Double
        }
    }
    subscript(int key: Key) -> Int? {
        get {
            return self[key] as? Int
        }
    }
    
}
