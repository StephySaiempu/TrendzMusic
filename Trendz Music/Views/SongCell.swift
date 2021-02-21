//
//  SongCell.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import Foundation

class SongCell: UICollectionViewCell {
    
    var artistLabel: UILabel!
    var songNameLabel: UILabel!
    var timeLabel: UILabel!
    var playButton: UIButton!
    var isPlaying = true
    var model: IndividualTrackModel?{
        didSet{
            songNameLabel.text = model?.name ?? ""
            timeLabel.text = getMinutesFromMS(value: model?.duration_ms ?? 0)
            if let artistArray = model?.artists{
                var namesArray = [String]()
                artistArray.forEach({namesArray.append($0.name ?? "")})
                artistLabel.text = namesArray.joined(separator: ", ")
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        songNameLabel = UILabel()
        self.addSubview(songNameLabel)
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [songNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
         songNameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -2),
         songNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -80)].forEach({$0.isActive = true})
        songNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        songNameLabel.textColor = .black
        songNameLabel.lineBreakMode = .byTruncatingTail
        songNameLabel.numberOfLines = 1
        
        artistLabel = UILabel()
        self.addSubview(artistLabel)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        [artistLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
         artistLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
         artistLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30)].forEach({ $0.isActive = true })
        artistLabel.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        artistLabel.textColor = .black
        artistLabel.numberOfLines = 1
        artistLabel.lineBreakMode = .byTruncatingTail
        
        
        playButton = UIButton()
        self.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        [playButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
         playButton.centerYAnchor.constraint(equalTo: songNameLabel.centerYAnchor, constant: 0),
         playButton.widthAnchor.constraint(equalToConstant: 24),
         playButton.heightAnchor.constraint(equalToConstant: 24)].forEach({ $0.isActive = true })
        let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: playButtonConfiguration), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        
        timeLabel = UILabel()
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        [timeLabel.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: 0),
         timeLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 4)].forEach({ $0.isActive = true })
        timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        timeLabel.textColor = .lightGray
        timeLabel.textAlignment = .center
        
        
    }
    
    @objc func playButtonTapped() {
        if isPlaying{
            let userInfo = ["item": model?.preview_url ?? ""]
            NotificationCenter.default.post(name: NSNotification.Name("playSong"), object: nil, userInfo: userInfo)
            isPlaying = false
            if model?.preview_url != "" && model?.preview_url != nil{
                let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
                playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: playButtonConfiguration), for: .normal)
            }
            
        } else{
            
            NotificationCenter.default.post(name: NSNotification.Name("stopPlaying"), object: nil)
            isPlaying = true
            if model?.preview_url != "" && model?.preview_url != nil{
                let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
                playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: playButtonConfiguration), for: .normal)
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
