//
//  TokenModel.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation


class TokenModel: Codable {
    var access_token: String?
    var expires_in: Int?
    var scope: String?
    var refresh_token: String?
}

