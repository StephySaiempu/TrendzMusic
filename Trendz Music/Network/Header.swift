//
//  Header.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
enum Header {
    case GETHeader(accessTokeny: String)
    case POSTHeader

    func buildHeader() -> [String:String] {
        switch self {
        case .GETHeader (let accessToken):
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(accessToken)"
            ]
        case .POSTHeader:
            // Spotify's required format for authorization
            let SPOTIFY_API_AUTH_KEY = "Basic \((clientID + ":" + clientSecretkey).data(using: .utf8)!.base64EncodedString())"
            return ["Authorization": SPOTIFY_API_AUTH_KEY,
                    "Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}


