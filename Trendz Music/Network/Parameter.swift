//
//  Parameter.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation

enum Parameters {
    case codeForToken(accessCode: String)
    case refreshTokenForAccessCode(refreshToken: String)
    case timeRange(range: String)

    func buildParameters() -> [String:Any] {
        switch self {
        case .codeForToken(let code):
            return ["grant_type": "authorization_code",
                    "code": "\(code)",
                    "redirect_uri": redirectUri]
        case .refreshTokenForAccessCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken
            ]
        case .timeRange(let range):
            return ["time_range": range]
        }
    }
}
