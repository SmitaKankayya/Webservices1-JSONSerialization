//
//  ViewController.swift
//  JSON_Serialization_Assignment
//
//  Created by Smita Kankayya on 19/12/23.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var secondViewController : SecondViewController?
    
    
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var photosTableView: UITableView!
    
    private let albumsTableViewCellIdentifier = "AlbumsTableViewCell"
    private let photosTableViewCellIdentifier = "PhotosTableViewCell"
    
    var jsonPlaceHolderAlbums : [Albums] = []
    var jsonPlaceHolderPhotos : [Photos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        registerXIBWithTableView()
        albumFetchData()
        photosFetchData()
    }
    
    func initializeTableView(){
        albumsTableView.dataSource = self
        albumsTableView.delegate = self
        photosTableView.dataSource = self
        photosTableView.delegate = self
    }
    
    func registerXIBWithTableView(){
        let uiNib = UINib(nibName: albumsTableViewCellIdentifier, bundle: nil)
        self.albumsTableView.register(uiNib, forCellReuseIdentifier: albumsTableViewCellIdentifier)
        let uiNib1 = UINib(nibName: photosTableViewCellIdentifier, bundle: nil)
        self.photosTableView.register(uiNib1, forCellReuseIdentifier: photosTableViewCellIdentifier)
    }
    
    func albumFetchData(){
        let albumUrl = URL(string: "https://jsonplaceholder.typicode.com/albums")
        var albumUrlRequest = URLRequest(url: albumUrl!)
        albumUrlRequest.httpMethod = "GET"
        
        let albumUrlSession = URLSession(configuration: .default)
        let dataTask = albumUrlSession.dataTask(with: albumUrlRequest) {
            albumData, albumUrlResponse, albumError in
        let albumResponse = try! JSONSerialization.jsonObject(with:albumData!) as! [[String:Any]]
            print(albumResponse)
            
            for eachAlbumResponse in albumResponse{
                let albumDictionary = eachAlbumResponse as! [String:Any]
                let albumUserId = albumDictionary["userId"] as! Int
                let albumId = albumDictionary["id"] as! Int
                let albumTitle = albumDictionary["title"] as! String
                
                let albumObject = Albums(userId: albumUserId,id: albumId,title: albumTitle)
                self.jsonPlaceHolderAlbums.append(albumObject)
            }
            
            DispatchQueue.main.async {
                self.albumsTableView.reloadData()
            }
        }
        
        dataTask.resume()
    }
    
    func photosFetchData(){
        let photosUrl = URL(string: "https://jsonplaceholder.typicode.com/photos")
        var photosUrlRequest = URLRequest(url: photosUrl!)
        photosUrlRequest.httpMethod = "GET"
        
        let photosUrlSession = URLSession(configuration: .default)
        let dataTask1 = photosUrlSession.dataTask(with: photosUrlRequest) { photosData, photosUrlResponse, photosError in
        let photosResponse = try! JSONSerialization.jsonObject(with:photosData!) as! [[String:Any]]
            print(photosResponse)
            
            for eachPhotosResponse in photosResponse{
                let photosDictionary = eachPhotosResponse as!  [String:Any]
                let photosAlbumId = photosDictionary["albumId"] as! Int
                let photosId = photosDictionary["id"] as! Int
                let photosTitle = photosDictionary["title"] as! String
                let photosUrl = photosDictionary["url"] as! String
                let photosthumbnailURL = photosDictionary["thumbnailUrl"] as! String
                
                let photosObject = Photos(id: photosId,
                                          title: photosTitle,
                                          url: photosUrl)
                self.jsonPlaceHolderPhotos.append(photosObject)
            }
            
            DispatchQueue.main.async {
                self.photosTableView.reloadData()
            }
        }
        
        dataTask1.resume()
    }
    
    @IBAction func btnClick(_ sender: Any) {
        secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
}

//MARK : UITableViewDataSource
extension ViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == albumsTableView){
            return jsonPlaceHolderAlbums.count
        }else if(tableView == photosTableView){
            return jsonPlaceHolderPhotos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == albumsTableView){
            let albumsTableViewCell = self.albumsTableView.dequeueReusableCell(withIdentifier: albumsTableViewCellIdentifier, for: indexPath) as! AlbumsTableViewCell
            albumsTableViewCell.albumLabel.text = String(jsonPlaceHolderAlbums[indexPath.row].userId) + ("\n\(String(jsonPlaceHolderAlbums[indexPath.row].id))") + ("\n\(String(jsonPlaceHolderAlbums[indexPath.row].title))")
            return albumsTableViewCell
        }else if (tableView == photosTableView){
            let photosTableViewCell = self.photosTableView.dequeueReusableCell(withIdentifier: photosTableViewCellIdentifier, for: indexPath) as! PhotosTableViewCell
            photosTableViewCell.photosIdLabel.text = String(jsonPlaceHolderPhotos[indexPath.row].id)
            photosTableViewCell.photosTitleLabel.text = jsonPlaceHolderPhotos[indexPath.row].title
            photosTableViewCell.photosImage.kf.setImage(with: URL(string: jsonPlaceHolderPhotos[indexPath.row].url))
            return photosTableViewCell
        }
        return UITableViewCell()
    }
}

//MARK : UITableViewDelegate
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
