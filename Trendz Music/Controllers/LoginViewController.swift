//
//  LoginViewController.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
import AuthenticationServices


class LoginViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
    }
    
    func initViews(){
        let button = UIButton.init()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
    }
    
    
    @objc func doLogin(){
        
        let paramDictionary = ["client_id" : clientID,"redirect_uri" : redirectUri,"response_type" : responseType,"scope" : scope.joined(separator: "%20")]
        let mapParams = paramDictionary.map { key, value in
            
            return "\(key)=\(value)"
        }
        
        let stringQuery = mapParams.joined(separator: "&")
        let accessCodeBaseURL = "https://accounts.spotify.com/authorize"
        let authBaseURL = URL.init(string: "https://accounts.spotify.com/api/token")!
        let fullURL = URL(string: accessCodeBaseURL.appending("?\(stringQuery)"))!
        let scheme = "auth"
        let session = ASWebAuthenticationSession(url: fullURL, callbackURLScheme: scheme) { (callbackURL, error) in
            guard error == nil, let callbackURL = callbackURL else { return }
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
            print(" Code \(requestAccessCode)")
            UnifiedWebAPIClient.shared.requestApi(with: authBaseURL, method: "POST", headers: Header.POSTHeader.buildHeader(), params: Parameters.codeForToken(accessCode: requestAccessCode).buildParameters()) { [weak self] (error, success, data, statusCode) in
                if !success{
                    self?.showAlert(with: "Authentication failed")
                    return
                } else{
                    print("Success")
                    self?.authorizationSuccessListener(response: "Success", codableResponse: data!)
                }
            }
        }
        session.presentationContextProvider = self
        session.start()
        
    }
    
    
    func authorizationSuccessListener(response: Any, codableResponse: Data){
        let decoder = JSONDecoder()
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:codableResponse, options: [])
            print("JSON Response : \(jsonResponse)")
            let tokenModel = try decoder.decode(TokenModel.self, from: codableResponse)
            UserDefaultUtil.instance.storeString(key: "token", value: tokenModel.access_token ?? "")
            UserDefaultUtil.instance.storeString(key: "refresh_token", value: tokenModel.refresh_token ?? "")
            navigationController?.pushViewController(AlbumViewController(), animated: true)
        } catch {
            showAlert(with: "Failure")
        }
    }
    
    func showAlert(with message: String){
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        alert.view.tintColor = .white
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
        
    }
}
