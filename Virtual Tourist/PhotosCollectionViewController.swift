//
//  PhotosCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Fernando Geraldo Mantoan on 03/04/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import MapKit

class PhotosCollectionViewController: UIViewController {
    // MARK: Attributes
    // IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    // Pin
    var selectedPin: Pin?
    // FlickrPhotos
    var photos: [Photo] = [Photo]()
    
    var stack: CoreDataStack?
    
    var flowLayout: UICollectionViewFlowLayout {
        return self.photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = delegate.stack
        
        initMap()
        
        if (self.selectedPin?.photos?.count)! <= 0 {
            debugPrint("Load from network")
            loadPhotos()
        } else {
            debugPrint("Load from CoreData")
            self.photos = (self.selectedPin?.photos)!.allObjects as! [Photo]
        }
    }
    
    // MARK: Initializers
    func initMap() {
        mapView.delegate = self
        mapView.addAnnotation(self.selectedPin!)
        mapView.centerCoordinate = self.selectedPin!.coordinate
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
    }
    
    // MARK: Fetch Photos
    func loadPhotos() {
        FlickrClient.sharedInstance().getLocationPhotos(pin: selectedPin!, latitude: selectedPin!.latitude, longitude: selectedPin!.longitude) { (_ result: [Photo]?, _ error: NSError?) in
            self.photos = result!
            performUIUpdatesOnMain {
                self.photosCollectionView.reloadData()
                debugPrint("Photos Loaded \(result?.count) \(error)")
            }
        }
    }
    
    @IBAction func newCollection(_ sender: Any) {
        for photo in self.photos {
            self.stack?.context.delete(photo)
        }
        self.photos = [Photo]()
        self.photosCollectionView.reloadData()
        self.loadPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = floor(self.photosCollectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        self.photosCollectionView.collectionViewLayout = layout
    }
}

// MARK: MKMapViewDelegate
extension PhotosCollectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}

// MARK: CollectionDelegate
extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoViewCell
        let flickrPhoto = self.photos[indexPath.row]
        let photoUrl = flickrPhoto.flickrUrl
        cell.photo.image = UIImage(named: "placeholder")
        
        if let data = flickrPhoto.data {
            debugPrint("Load Data offline")
            let image = UIImage(data: data as Data)
            cell.photo.image = image
            cell.hideLoading()
        } else {
            debugPrint("Load Data online")
            cell.showLoading()
            let _ = FlickrClient.sharedInstance().taskForGETImage(filePath: photoUrl!, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain {
                        cell.hideLoading()
                        debugPrint("Image Loaded")
                        flickrPhoto.data = imageData as! NSData
                        self.stack?.save()
                        cell.photo.image = image
                    }
                } else {
                    print(error)
                }
            })

        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        self.stack?.context.delete(photo)
        self.photos.remove(at: indexPath.row)
        self.photosCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("Flickr Photos Count \(self.photos.count)")
        return self.photos.count
    }
}
