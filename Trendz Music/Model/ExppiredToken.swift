//
//  ExppiredToken.swift
//  Trendz Music
//
//  Created by Girira Stephy on 21/02/21.
//

import Foundation


class ExpireToken: Codable {
    var error: ErrorMessage?
   
}

class ErrorMessage: Codable {
    var status: Int?
    var message: String?
}
