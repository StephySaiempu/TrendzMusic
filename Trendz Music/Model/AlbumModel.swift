//
//  AlbumModel.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation


class AlbumModel: Codable{
//    The names of artists for that album (Separate by commas if multiple)
//    The release date of that album in the format - Month Year (e.g. May 2019)
//    The genre in which that album falls (If available)
//    The number of tracks in that album
//    A miniature image of the album’s cover
    var albums: AlbumListModel?
}


class AlbumListModel: Codable{
    var items: [SingleAlbumModel]?
}

class SingleAlbumModel: Codable{
    var artists: [ArtistModel]?
    var release_date: String?
    var total_tracks: Int?
    var images: [Image]?
    var name: String?
    var genres: [String]?
    var id: String?
}


class ArtistModel: Codable{
    var name: String?
}


class Image: Codable{
    var height: Int?
    var url: String?
    var width: Int?
}
