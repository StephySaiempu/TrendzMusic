//
//  UnifiedWebApiClient.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
import Alamofire
class UnifiedWebAPIClient: NSObject {
    
    
    public static var shared = UnifiedWebAPIClient()
    
    func requestApi(with url: URL,method: String,headers: HTTPHeaders, params: [String: Any]?,completion: @escaping (_ error: String?,_ success: Bool,_ data: Data?,_ statusCode: Int) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        if let params = params {
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: false)  {
                components.queryItems = [URLQueryItem]()
                
                for (key, value) in params {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    components.queryItems?.append(queryItem)
                }
                request.url = components.url
            }
        }
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion(error.localizedDescription, false, nil,response.response?.statusCode ?? 0)
                
            case .success(_):
                guard let dataResponse = response.data else {
                    completion("No data response", false, nil,response.response?.statusCode ?? 0)
                    return
                }
                completion(nil, true, dataResponse,response.response?.statusCode ?? 0)
            }

        }
    }
    
}



