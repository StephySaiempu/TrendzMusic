//
//  AudioPlayer.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    static let shared = AudioPlayer()
    var player: AVAudioPlayer!
    var firsttime = true
    func downloadFileFromURL(url: URL){
        //URLSessionDownloadTask
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in
            
            if let url = URL {
                self?.play(url: url)
                
            }
        }).resume()
    }
    
    func play(url: URL) {
        //        print("playing \(url)")
        do {
            player = try AVAudioPlayer(contentsOf: url)
            // to be able to play sound when device in slient mode
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
            player.volume = 0.7
            if firsttime{
                NotificationCenter.default.post(name: NSNotification.Name("playerintiated"), object: nil)
                firsttime = false
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("ended")
    }
    
    func forwardFiveSecs(){
      
    }
    
    
}

