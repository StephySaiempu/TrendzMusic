//
//  AlbumViewController.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation


class AlbumViewController: UIViewController{
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var albumArray: [SingleAlbumModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initViews()
        getData()
    }
    
    
    
    
    func getData(){
        let accessToken = UserDefaultUtil.instance.getString(key: "token")
        let expireTokenURL  = "https://api.spotify.com/v1/me"
        if let url = URL.init(string: expireTokenURL){
            UnifiedWebAPIClient.shared.requestApi(with: url, method: "GET", headers: Header.GETHeader(accessTokeny: accessToken).buildHeader(), params: nil) { [weak self] (error, success, data, statusCode) in
                if statusCode == 200{
                    print("Token valid")
                    self?.getAlbumsAPI()
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
                self?.showAlert(with: "Token access Failed")
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
            self.getAlbumsAPI()
        } catch {
            showAlert(with: "Failure")
        }
    }
    
    func getAlbumsAPI(){
        let accessToken = UserDefaultUtil.instance.getString(key: "token")
        let albumsurl = "https://api.spotify.com/v1/browse/new-releases?country=IN"
        if let url = URL.init(string: albumsurl){
            UnifiedWebAPIClient.shared.requestApi(with: url, method: "GET", headers: Header.GETHeader(accessTokeny: accessToken).buildHeader(), params: Parameters.timeRange(range: "long_term").buildParameters()) { [weak self] (error, success, data, statusCode) in
                if !success{
                    self?.showAlert(with: "Unknown Error")
                    return
                } else{
                    print("Success")
                    self?.albumsSuccessListener(response: "Success", codableResponse: data!)
                }
            }
        }
    }
    
    
    
    
    func albumsSuccessListener(response: Any, codableResponse: Data){
            let decoder = JSONDecoder()
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:codableResponse, options: [])
                print("JSON Response : \(jsonResponse)")
                let albumModel = try decoder.decode(AlbumModel.self, from: codableResponse)
                albumArray = [SingleAlbumModel]()
                albumArray = albumModel.albums?.items
                collectionView.reloadData()
            } catch {
                showAlert(with: "Failure")
            }
        }
    
    func initViews(){
        self.navigationController?.navigationBar.isHidden = true
        
        let guide = view.safeAreaLayoutGuide
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
         titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16)].forEach({$0.isActive = true})
        titleLabel.text = "Trending Now"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        
        
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (view.bounds.width - 64) / 2, height: 180)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
         collectionView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
         collectionView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -16),
         collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor,constant: -24)].forEach({ $0.isActive = true })
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "albumId")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
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


extension AlbumViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumId", for: indexPath) as! AlbumCell
        cell.model = albumArray?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedAlbum = albumArray?[indexPath.row] else{ return }
        let vc = IndividualAlbumViewController.init(albumModel: selectedAlbum)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
