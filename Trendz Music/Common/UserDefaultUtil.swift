//
//  UserDefaultUtil.swift
//  Trendz Music
//
//  Created by Girira Stephy on 20/02/21.
//

import Foundation
class UserDefaultUtil
{
    static var instance:UserDefaultUtil = UserDefaultUtil()
    
    
    func storeString(key:String,value:String)
        {
            
            let userDefault = UserDefaults.standard
            userDefault.set(value, forKey: key)
            userDefault.synchronize()
        }
        func getString(key:String)->String
        {
            let userDefault = UserDefaults.standard
            let value:String = userDefault.value(forKey: key) as? String ?? ""
            return value
        }
}
