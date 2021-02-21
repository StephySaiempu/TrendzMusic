//
//  IndividualAlbumscreen.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
import UIKit

class IndividualAlbumViewController: UIViewController{
    
    
    var selectedModel: SingleAlbumModel!
    var trackModel: TrackModel?
    var scrollView: UIScrollView!
    var albumImageView: UIImageView!
    var songsContainerView: BaseView!
    var layout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!
    var numberOfSongs: Int!
    var vc = PlayerController()
    convenience init(albumModel: SingleAlbumModel){
        self.init()
        selectedModel = albumModel
        numberOfSongs = albumModel.total_tracks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playSong), name: NSNotification.Name("playSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopSong), name: NSNotification.Name("stopPlaying"), object: nil)
    }
    
    
    @objc func playSong(_ userInfo: NSNotification){
        if let value = userInfo.userInfo?["item"] as? String{
            if value == ""{
                self.showAlert(with: "Preview for this song is not available")
            } else{
                let url = URL.init(string: value)!
                AudioPlayer.shared.downloadFileFromURL(url: url)
            }
        }
    }
    
    @objc func stopSong(){
        AudioPlayer.shared.player.stop()
    }
    
    func initViews(){
        let guide = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
         scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
         scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)].forEach({ $0.isActive = true })
        
        albumImageView = UIImageView()
        scrollView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        [albumImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
         albumImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
         albumImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
         albumImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
         albumImageView.heightAnchor.constraint(equalToConstant: 300)].forEach({$0.isActive = true})
        albumImageView.contentMode = .scaleAspectFill
        if let imagesArray = selectedModel?.images {
            for image in imagesArray {
                if image.height == 300 {
                    albumImageView.kf.setImage(
                        with: URL.init(string:image.url ?? ""),
                        placeholder: UIImage.init(named: "albumArt"),
                        options: [.transition(.fade(0)), .loadDiskFileSynchronously],
                        progressBlock: { receivedSize, totalSize in
                    },
                        completionHandler: { result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let value):

                                DispatchQueue.main.async {
                                    self.albumImageView.image = value.image

                                }
                            }
                    })
                }
            }
        }
        
        
        
        songsContainerView = BaseView(with: .white, circular: false, shadow: true, borderColor: nil, borderThickness: nil)
        scrollView.addSubview(songsContainerView)
        songsContainerView.translatesAutoresizingMaskIntoConstraints = false
        [songsContainerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
         songsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
         songsContainerView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -16),
         songsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
         songsContainerView.heightAnchor.constraint(equalToConstant: CGFloat(numberOfSongs * 60) + 32)].forEach( { $0.isActive = true })
        
        
        
        
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: view.bounds.width, height: 60)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        songsContainerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [collectionView.leftAnchor.constraint(equalTo: songsContainerView.leftAnchor, constant: 0),
         collectionView.rightAnchor.constraint(equalTo: songsContainerView.rightAnchor, constant: 0),
         collectionView.topAnchor.constraint(equalTo: songsContainerView.topAnchor, constant: 16),
         collectionView.heightAnchor.constraint(equalToConstant: CGFloat(numberOfSongs * 60))].forEach({$0.isActive = true})
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(SongCell.self, forCellWithReuseIdentifier: "SomeIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    
        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        [backButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
         backButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 4),
         backButton.heightAnchor.constraint(equalToConstant: 32),
         backButton.widthAnchor.constraint(equalToConstant: 32)].forEach({ $0.isActive = true })
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.setImage(UIImage.init(named: "back"), for: .normal)
        backButton.tintColor = .white
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getData(){
        let accessToken = UserDefaultUtil.instance.getString(key: "token")
        let expireTokenURL  = "https://api.spotify.com/v1/me"
        if let url = URL.init(string: expireTokenURL){
            UnifiedWebAPIClient.shared.requestApi(with: url, method: "GET", headers: Header.GETHeader(accessTokeny: accessToken).buildHeader(), params: nil) { [weak self] (error, success, data, statusCode) in
                if statusCode == 200{
                    print("Token valid")
                    self?.getTracksAPI()
                    return
                } else{
                    self?.getRefreshTokenAPI()
                    
                }
            }
        }
    }
    
    func getRefreshTokenAPI(){
        
        let refreshToken = UserDefaultUtil.instance.getString(key: "refresh_token")
        let authBaseURL = URL.init(string: "https://accounts.spotify.com/api/token")!
        UnifiedWebAPIClient.shared.requestApi(with: authBaseURL, method: "POST", headers: Header.POSTHeader.buildHeader(), params: Parameters.buildParameters(.refreshTokenForAccessCode(refreshToken: refreshToken))()) { [weak self] (error, success, data, statusCode) in
            if !success{
                print("Failure")
                return
            } else{
                print("Success")
                self?.authorizationSuccessListener(response: "Success", codableResponse: data!)
            }
        }
    }
    
    func authorizationSuccessListener(response: Any, codableResponse: Data){
        let decoder = JSONDecoder()
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:codableResponse, options: [])
            print("JSON Response : \(jsonResponse)")
            let tokenModel = try decoder.decode(TokenModel.self, from: codableResponse)
            UserDefaultUtil.instance.storeString(key: "token", value: tokenModel.access_token ?? "")
            UserDefaultUtil.instance.storeString(key: "refresh_token", value: tokenModel.refresh_token ?? "")
            self.getTracksAPI()
        } catch {
            print("Error")
        }
    }
    
    func getTracksAPI(){
        guard let albumId = selectedModel.id else { return }
        let albumsurl = "https://api.spotify.com/v1/albums/\(albumId)/tracks"
        let accessToken = UserDefaultUtil.instance.getString(key: "token")
        if let url = URL.init(string: albumsurl){
            UnifiedWebAPIClient.shared.requestApi(with: url, method: "GET", headers: Header.GETHeader(accessTokeny: accessToken).buildHeader(), params: Parameters.timeRange(range: "long_term").buildParameters()) { [weak self] (error, success, data, statusCode) in
                if !success{
                    print("Failure")
                    return
                } else{
                    print("Success")
                    self?.albumTrackSuccessListener(response: "Success", codableResponse: data!)
                }
            }
        }
    }
    
    
    func albumTrackSuccessListener(response: Any, codableResponse: Data){
            let decoder = JSONDecoder()
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:codableResponse, options: [])
                print("JSON Response : \(jsonResponse)")
                self.trackModel = try decoder.decode(TrackModel.self, from: codableResponse)
                collectionView.reloadData()
                
            } catch {
                print("Error")
            }
        }
    
    func showAlert(with message: String){
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        alert.view.tintColor = .white
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}



extension IndividualAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackModel?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SomeIdentifier", for: indexPath) as! SongCell
        cell.model = trackModel?.items?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTrack = trackModel?.items?[indexPath.row] else{ return }
        if let imageArray = selectedModel?.images{
            vc = PlayerController.init(trackModel: selectedTrack, image: imageArray)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension IndividualAlbumViewController: PlaylistProtocol{
    func playNext(model: IndividualTrackModel) -> IndividualTrackModel? {
        if let index = trackModel?.items?.firstIndex(where: {$0.name == model.name}){
            if index == 0 || index < (trackModel?.items?.count ?? 0) - 1{
                print(index + 1)
                if let modelTobeReturned = trackModel?.items?[index + 1]{
                    return modelTobeReturned
                }
            }
        }
        return nil
    }
    
    func playPrevious(model: IndividualTrackModel) -> IndividualTrackModel? {
        if let index = trackModel?.items?.firstIndex(where: {$0.name == model.name}){
            if index > 0 && index < trackModel?.items?.count ?? 0{
                print(index - 1)
                if let modelTobeReturned = trackModel?.items?[index - 1]{
                    return modelTobeReturned
                }
            }
        }
        return nil
    }
    
}
