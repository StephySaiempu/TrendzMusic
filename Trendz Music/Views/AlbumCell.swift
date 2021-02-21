//
//  AlbumCell.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import UIKit
import Kingfisher

class AlbumCell: UICollectionViewCell{
     
    var imageView = UIImageView()
    var albumNameLabel: UILabel!
    var artistName: UILabel!
    var numberOfTracks: UILabel!
    var baseViewBackground: BaseView!
    var releaseDateLabel: UILabel!
    var model: SingleAlbumModel?{
        didSet{
            albumNameLabel.text = model?.name ?? ""
            if let artistArray = model?.artists{
                var namesArray = [String]()
                artistArray.forEach({namesArray.append($0.name ?? "")})
                artistName.text = namesArray.joined(separator: ", ")
            }
            
            
            if let imagesArray = model?.images {
                for image in imagesArray {
                    if image.height == 300 {
                        baseViewBackground.imageView.kf.setImage(
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
                                        self.baseViewBackground.imageView.image = value.image
                                        self.releaseDateLabel.text = DateFormatUtil.getMonthNameAndYear(date: DateFormatUtil.convertStringToDate(stringDate: self.model?.release_date ?? ""))
                                        self.numberOfTracks.text = "\(self.model?.total_tracks ?? 0)"

                                    }
                                }
                        })
                    }
                }
            }

        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseViewBackground = BaseView.init(with: .white, circular: false, shadow: true, borderColor: nil, borderThickness: nil)
        self.addSubview(baseViewBackground)
        albumNameLabel = UILabel()
        self.addSubview(albumNameLabel)
        albumNameLabel.textColor = .black
        albumNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        albumNameLabel.numberOfLines = 1
        albumNameLabel.lineBreakMode = .byTruncatingTail
        artistName = UILabel()
        self.addSubview(artistName)
        artistName.textColor = .black
        artistName.font = UIFont.systemFont(ofSize: 11, weight: .light)
        artistName.numberOfLines = 2
        artistName.lineBreakMode = .byTruncatingTail
        numberOfTracks = UILabel()
        self.addSubview(numberOfTracks)
        numberOfTracks.font = UIFont.systemFont(ofSize: 16, weight: .light)
        releaseDateLabel = UILabel()
        self.addSubview(releaseDateLabel)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            
        baseViewBackground.translatesAutoresizingMaskIntoConstraints = false
        [baseViewBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
         baseViewBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
         baseViewBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
         baseViewBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)].forEach({$0.isActive =  true})
        
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [albumNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
         albumNameLabel.topAnchor.constraint(equalTo: baseViewBackground.bottomAnchor, constant: 8),
         albumNameLabel.widthAnchor.constraint(equalTo: baseViewBackground.widthAnchor, constant: -16)].forEach({ $0.isActive = true })
        
        
        artistName.translatesAutoresizingMaskIntoConstraints = false
        [artistName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
         artistName.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 2),
         artistName.widthAnchor.constraint(equalTo: baseViewBackground.widthAnchor, constant: -16)].forEach({ $0.isActive = true })
        
        numberOfTracks.translatesAutoresizingMaskIntoConstraints = false
        [numberOfTracks.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
         numberOfTracks.bottomAnchor.constraint(equalTo: baseViewBackground.bottomAnchor, constant: -16)].forEach({ $0.isActive = true })
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        [releaseDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
         releaseDateLabel.topAnchor.constraint(equalTo: baseViewBackground.topAnchor, constant: 4)].forEach({ $0.isActive = true })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
