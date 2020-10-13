//
//  LanguageHelper.swift
//  SHMarasonT01
//
//  Created by WillowRivers on 2019/12/30.
//  Copyright © 2019 WillowRivers. All rights reserved.
//

import UIKit

let UserLanguage = "UserLanguage"
let AppleLanguages = "AppleLanguages"
final class LanguageHelper: NSObject {
    static let shareInstance = LanguageHelper()
    private let def = UserDefaults.standard
    lazy private var bundle : Bundle? = {
        //def.setValue("", forKey: UserLanguage) //for test
        var string:String = standerLanName(sourceStr: UserPlistManager.sharedInstance.getValueForKey(keyEnum: .Language) ?? "")
        if string == "" {
            let languages = def.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                }
            }
        }
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource:"en" , ofType: "lproj")
        }
        return Bundle(path: path!)
    }()
    
    /// get string by key
    /// - Parameter key: key
    func getStr(key:String) -> String{
        let bundle = LanguageHelper.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return str!
    }
    
    func setLanguage(langeuage:LanguareKind) {
        let path = Bundle.main.path(forResource:langeuage.rawValue , ofType: "lproj")
        bundle = Bundle(path: path!)
        def.set(langeuage, forKey: UserLanguage)
        def.synchronize()
    }
    
    func getLanguageForRequestHeader() -> String {
        /*
         默认zh-CN，支持：zh-CN中文、en_英文、ja_日文、fr_法文
         */
        let def = UserDefaults.standard
        var string:String = standerLanName(sourceStr: UserPlistManager.sharedInstance.getValueForKey(keyEnum: .Language) ?? "")
        if string == "" {
            let languages = def.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                }
            }
        }
        return changeAppleLanguageNameToRequest(appleLanguageName: string)
    }
    
    /// request: 语言，默认zh-CN，支持：zh-CN中文、en_英文、ja_日文、fr_法文
    func changeAppleLanguageNameToRequest(appleLanguageName: String?) -> String {
        guard appleLanguageName != nil && (appleLanguageName?.notEmpty ?? false) else {
            return "en"
        }
        if (appleLanguageName?.hasPrefix("zh-"))! {
            return "zh-CN"
        }else if(appleLanguageName == "ja" || ((appleLanguageName?.hasPrefix("ja-")) ?? false)) {
            return "ja"
        }else if(appleLanguageName == "en" || ((appleLanguageName?.hasPrefix("en-")) ?? false)) {
            return "en"
        }else if(appleLanguageName == "fr" || ((appleLanguageName?.hasPrefix("fr-")) ?? false)) {
            return "fr"
        }else {
            return "en"
        }
    }
    
    /// 转换语言名称
    /// - Parameter sourceStr: 用于显示给用户和保存的到Plist的名称
    /// - Returns: 和apple 统一到语言名称
    func standerLanName(sourceStr: String) -> String {
        switch sourceStr {
        case "简体中文":
            return "zh-Hans"
        case "English":
            return "en"
        case "日本語":
            return "ja"
        case "Français":
            return "fr"
        default:
           return ""
        }
    }
}

/// 保存到plist 文件的enum
enum LanguareKind: String {
    case 简体中文 = "zh-Hans"
    case English = "en"
    case 日本語 = "ja"
    case Français = "fr"
}
