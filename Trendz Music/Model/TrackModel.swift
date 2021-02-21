//
//  TrackModel.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation


class TrackModel: Codable{
//    The number of tracks in the album
//    The album’s cover
//    A list of all songs, with each list item having
//    Name of the song
//    Length of the song as `X minutes` (Rounded up to the nearest minute. E.g. 02:43 should be rounded to 3 minutes)
//    Comma-separated list of artists for that song
//    A button to play the preview
    
    var total: Int?
    var items: [IndividualTrackModel]?
}


class IndividualTrackModel: Codable{
    var name: String?
    var duration_ms: Double?
    var artists: [ArtistModel]?
    var preview_url: String?
    var uri: String?
}
