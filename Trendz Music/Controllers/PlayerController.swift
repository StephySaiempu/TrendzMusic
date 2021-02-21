//
//  PlayerController.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import UIKit
import AVKit



class PlayerController: UIViewController {
    
    var albumArtImageView: BaseView!
    var songNameLabel: UILabel!
    var artistNameLabel: UILabel!
    var previousButton: UIButton!
    var playButton: UIButton!
    var nextButton: UIButton!
    var seekbar: BaseSlider!
    var selectedModel: IndividualTrackModel!
    var coverImage: [Image]?
    var playOn = true
    weak var delegate: PlaylistProtocol?
    convenience init(trackModel: IndividualTrackModel,image: [Image]){
        self.init()
        selectedModel = trackModel
        coverImage = image
    }
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        NotificationCenter.default.addObserver(self, selector: #selector(playerInitiated), name: NSNotification.Name("playerintiated"), object: nil)

    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func playerInitiated(){
        AudioPlayer.shared.player.delegate = self
    }
    
}


extension PlayerController {
    
    
    func initViews() {
        
        let guide = view.safeAreaLayoutGuide
        view.backgroundColor = .white
        
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
        backButton.tintColor = .black
        
        
        let albumImageContainer = BaseView.init(with: .white, circular: true, shadow: true, borderColor: nil, borderThickness: nil)
        view.addSubview(albumImageContainer)
        albumImageContainer.translatesAutoresizingMaskIntoConstraints = false
        [albumImageContainer.heightAnchor.constraint(equalToConstant: 200),
         albumImageContainer.widthAnchor.constraint(equalToConstant: 200),
         albumImageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         albumImageContainer.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20)].forEach({ $0.isActive = true })
        
        albumArtImageView = BaseView.init(with: .white, circular: true, shadow: true, borderColor: nil, borderThickness: nil)
        albumImageContainer.addSubview(albumArtImageView)
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        [albumArtImageView.heightAnchor.constraint(equalToConstant: 180),
         albumArtImageView.widthAnchor.constraint(equalToConstant: 180),
         albumArtImageView.centerXAnchor.constraint(equalTo: albumImageContainer.centerXAnchor, constant: 0),
         albumArtImageView.centerYAnchor.constraint(equalTo: albumImageContainer.centerYAnchor, constant: 0)].forEach({ $0.isActive = true })
        albumArtImageView.contentMode = .scaleAspectFill
        
        
        if let imagesArray = coverImage {
            for image in imagesArray {
                if image.height == 300 {
                    albumArtImageView.imageView.kf.setImage(
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
                                    self.albumArtImageView.imageView.image = value.image
                                }
                            }
                    })
                }
            }
        }
        
        songNameLabel = UILabel()
        view.addSubview(songNameLabel)
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [songNameLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
         songNameLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -16),
         songNameLabel.topAnchor.constraint(equalTo: albumImageContainer.bottomAnchor, constant: 20)].forEach({ $0.isActive = true })
        songNameLabel.textColor = .black
        songNameLabel.textAlignment = .center
        songNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        artistNameLabel = UILabel()
        view.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        [artistNameLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 8),
         artistNameLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -8),
         artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8)].forEach({ $0.isActive = true })
        artistNameLabel.textAlignment = .center
        artistNameLabel.textColor = .black
        artistNameLabel.textAlignment = .center
        artistNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .ultraLight)
        
        
        
        
        previousButton = UIButton()
        view.addSubview(previousButton)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        [previousButton.rightAnchor.constraint(equalTo: guide.centerXAnchor, constant: -100),
         previousButton.heightAnchor.constraint(equalToConstant: 30),
         previousButton.widthAnchor.constraint(equalToConstant: 30),
         previousButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -90)].forEach({ $0.isActive = true})
        previousButton.setImage(UIImage.init(systemName: "backward.frame.fill"), for: .normal)
        previousButton.tintColor = .black
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        playButton = UIButton()
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        [playButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
         playButton.heightAnchor.constraint(equalToConstant: 80),
         playButton.widthAnchor.constraint(equalToConstant: 80),
         playButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor, constant: 0)].forEach({ $0.isActive = true})
        let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 80, weight: .bold, scale: .large)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: playButtonConfiguration), for: .normal)
        playButton.tintColor = .black
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        
        nextButton = UIButton()
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        [nextButton.leftAnchor.constraint(equalTo: guide.centerXAnchor, constant: 100),
         nextButton.heightAnchor.constraint(equalToConstant: 30),
         nextButton.widthAnchor.constraint(equalToConstant: 30),
         nextButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor, constant: 0)].forEach({ $0.isActive = true})
        nextButton.setImage(UIImage.init(systemName: "forward.frame.fill"), for: .normal)
        nextButton.tintColor = .black
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        
        let routeSelector = AVRoutePickerView()
        routeSelector.backgroundColor = UIColor.clear
        routeSelector.tintColor = .black
        routeSelector.activeTintColor = .black
        view.addSubview(routeSelector)
        routeSelector.translatesAutoresizingMaskIntoConstraints = false
        [routeSelector.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -30),
         routeSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         routeSelector.widthAnchor.constraint(equalToConstant: 30),
         routeSelector.heightAnchor.constraint(equalToConstant: 30)].forEach({$0.isActive = true})
        
        
//        seekbar = BaseSlider(ticks: 0)
//        view.addSubview(seekbar)
//        seekbar.translatesAutoresizingMaskIntoConstraints = false
//        [seekbar.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30),
//         seekbar.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 30),
//         seekbar.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -30),
//         seekbar.heightAnchor.constraint(equalToConstant: 30)].forEach({$0.isActive = true})
        setLabelNames()
    }
    
    
    func setLabelNames(){
        if let artistArray = selectedModel?.artists{
            var namesArray = [String]()
            artistArray.forEach({namesArray.append($0.name ?? "")})
            artistNameLabel.text = namesArray.joined(separator: ", ")
        }
        songNameLabel.text = selectedModel.name
        guard let player = AudioPlayer.shared.player else { return }
        if player.isPlaying{
            AudioPlayer.shared.player.stop()
            playOn = true
            playTapped()
        }
    }
    
    @objc func previousButtonTapped(){
        guard let changedModel = delegate?.playPrevious(model: selectedModel) else{ return }
        selectedModel = changedModel
        setLabelNames()
    }
    
    @objc func nextButtonTapped(){
        guard let changedModel = delegate?.playNext(model: selectedModel) else{ return }
        selectedModel = changedModel
        setLabelNames()
    }
    
    
    @objc func playTapped(){
        if playOn{
            playOn = false
            if let previewURL = selectedModel.preview_url {
                if previewURL != ""{
                    let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 80, weight: .bold, scale: .large)
                    playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: playButtonConfiguration), for: .normal)
                }
                let url = URL.init(string: previewURL)!
                AudioPlayer.shared.downloadFileFromURL(url: url)
            } else{
                self.showAlert(with: "Preview for this song is not available")
            }
            
        } else{
            if selectedModel.preview_url != "" && selectedModel.preview_url != nil{
                let playButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 80, weight: .bold, scale: .large)
                playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: playButtonConfiguration), for: .normal)
            }
            AudioPlayer.shared.player.stop()
            playOn = true
        }
        
    }
    
    func showAlert(with message: String){
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        alert.view.tintColor = .white
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension PlayerController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("ended")
        guard let changedModel = delegate?.playNext(model: selectedModel) else{ return }
        selectedModel = changedModel
        setLabelNames()
        playOn = true
        playTapped()
    }
}


protocol PlaylistProtocol: AnyObject {
    func playNext(model: IndividualTrackModel) -> IndividualTrackModel?
    func playPrevious(model: IndividualTrackModel) -> IndividualTrackModel?
}
