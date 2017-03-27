//
//  ServerHandler.swift
//  SensorRetrieval
//
//  Created by josh on 3/10/16.
//

import Foundation

class ServerHandler {
    fileprivate static var SERVER_URL: String = "https://crowdzen.cs.ucla.edu"
    
    static func getServerUrl() -> String {
        return SERVER_URL
    }
    
    static func getAuthUrl() -> String {
        return SERVER_URL + "/o/token/"
    }
    
    static func getLogOutUrl() -> String {
        return SERVER_URL + "/accounts/logout/"
    }
    
    static func getLoginUrl() -> String {
        return SERVER_URL + "/accounts/login/"
    }
    
    static func getRegisterUrl()  -> String {
        return SERVER_URL + "/accounts/register"
    }
    
    static func getForgotPasswordUrl() -> String {
        return SERVER_URL + "/accounts/password/reset/"
    }

    static func getQueryUrl() -> String {
        return SERVER_URL + "/api/query"
    }
    
    static func getMessageUrl() -> String {
        return SERVER_URL + "/api/message"
    }
    
    static func getCrashReportingDSN() -> String {
        return "https://prod:secretaladkj907690u9082323129112@experiments1.cs.ucla.edu/2"
    }
    
    static func getFAQUrl() -> String {
        return SERVER_URL + "/static/html/faq.html"
    }
}
