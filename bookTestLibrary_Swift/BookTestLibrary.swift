//
//  BookTestLibrary.swift
//  bookTestLibrary_Tester
//
//  Created by Benjamin Budzak on 6/5/21.
//


import UIKit


protocol Endpoint {
    var httpMethod: String { get }
    var apiKey: String { get }
    var appID: String { get }
    var deviceID: String { get }
    var currentBookKey: String { get }
    var userAuthToken: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String : Any]? { get }
    var body: [String : Any]? { get }
}

extension Endpoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
    
    
}

enum EndpointCases: Endpoint {
    
    
    
    
    case account
    case books
    case activate(bookKey: String)
    case getPage(page: String)
    case getLine(page: String, line: String)
    case getWord(page: String, line: String, across: String)
    case getPosition(word: String)
    
    //MARK: - Put your API Key below
    var apiKey: String {
        return "Your API Key"
    }
    
    var appID: String {
        if AppName.appBundleName != "" {
            return AppName.appBundleName
        } else if AppName.appBundleBuild != "" {
            return AppName.appBundleBuild
        } else if AppName.appBundleShortVersion != "" {
            return AppName.appBundleShortVersion
        } else {
            return apiKey
        }
    }
    
    var deviceID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    //MARK: - Set to user's auth token from the BookTestLibrary page
    var userAuthToken: String {
        return "YOUR USER AUTH TOKEN"
    }
    
    //MARK: - Set to return variable for whichever book user has active in your app
    var currentBookKey: String {
        return "CURRENT BOOK KEY"
    }
    
    
    
    var httpMethod: String {
        switch self {
        case .account, .activate: return "POST"
        case .books, .getPage, .getLine, .getWord, .getPosition: return "GET"
            
        }
    }
        
    var baseURLString: String {
        return "https://bookindexapi.com/"
        
    }
    
    //leading forward slash for paths that require api key, no leading slash for paths that don't require api key
    var path: String {
        switch self {
        case .account: return "account"
        case .books: return "books?apiKey=\(apiKey)"
        case .activate: return "activate"
        case .getPage(let page): return "getPage/\(page)?bookKey=\(currentBookKey)&apikey=\(apiKey)&appID=\(appID)&deviceID=\(deviceID)"
        case .getLine(let page, let line): return "getLine/\(page)/\(line)?bookKey=\(currentBookKey)&apikey=\(apiKey)&appID=\(appID)&deviceID=\(deviceID)"
        case .getWord(let page, let line, let across): return "getAcross/\(page)/\(line)/\(across)?bookKey=\(currentBookKey)&apikey=\(apiKey)&appID=\(appID)&deviceID=\(deviceID)"
        case .getPosition(let word): return "getWord/\(word)?bookKey=\(currentBookKey)&apikey=\(apiKey)&appID=\(appID)&deviceID=\(deviceID)"
        }
    }
    
    var headers: [String: Any]? {
        return ["Content-Type" : "application/json"]
    }
    
    var body: [String : Any]? {
        switch self {
        case .account: return ["apiKey": apiKey, "authToken": userAuthToken]
        case .activate: return ["apiKey": apiKey, "bookKey": currentBookKey, "appID": appID, "deviceID": deviceID]
            
        default: return ["":""]
        }
    }
    
    
}


class BookTestURLSession {
    
    
    func fetchData(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
        let session = URLSession.shared
        let url = URL(string: endpoint.url)

        
        if let safeURL = url {
            var urlRequest = URLRequest(url: safeURL)
            
            // HTTP Method
            urlRequest.httpMethod = endpoint.httpMethod
                    
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: endpoint.body, options: .prettyPrinted)
                if endpoint.path == "account" || endpoint.path == "activate" {
                    urlRequest.httpBody = jsondata
                }
                
            } catch {
                print("JSON Header Serialization error - \(error)")
            }
            
            
            // Header fields
            endpoint.headers?.forEach({ header in
                urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
                
            })

                    
            let task = session.dataTask(with: urlRequest) { data, response, error in
                completion(data, response, error)
            }
            
            task.resume()
        }
       
        
    }
    
}

public class BookTestLibrary {
    
    public static let shared = BookTestLibrary()

    
    private func getData(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?)->()) {
        BookTestURLSession().fetchData(endpoint: endpoint) { data, response, error in
            if let error = error {
//                print("BookTestLibrary fetchData call error \(error)")
                completion(nil, nil, error)
            } else {
//                print("data is \(data), response is \(response)")
                completion(data, response, nil)
            }
            
        }
    }
    
    
    
    public func getAccountData(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.account
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func getAvailableBooks(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.books
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func activateBook(bookKey: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.activate(bookKey: bookKey)
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func getWordsOnPage(page: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.getPage(page: page)
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func getWordsOnLine(page: String, line: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.getLine(page: page, line: line)
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func getWordAtPosition(page: String, line: String, across: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.getWord(page: page, line: line, across: across)
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    public func getLocationForWord(word: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let endpoint = EndpointCases.getPosition(word: word)
        
        getData(endpoint: endpoint) { data, response, error in
        completion(data, response, error)
    }
    }
    
    
    
}



//MARK: - Structures to turn JSONs into objects
// MARK: - AccountBookData
struct BookData: Codable {
    var bookType: String
    var coverImage: String
    var displayType, id, isbn13, language: String
    var name: String
    var pageCount: Int
    var price: String
    var bookKey: String?
}


// MARK: - Message
struct Message: Codable {
    let msg: String
}

// MARK: - Location
struct Location: Codable {
    let page, line, across: Int
}


//MARK: - Get App Name Automatically

public struct AppName {
    static var appBundleName:String {
        get { guard Bundle.main.infoDictionary != nil else {return ""}
            return Bundle.main.infoDictionary!["CFBundleName"] as! String
        }//end get
    }//end computed property
    static var appBundleShortVersion:String {
        get { guard Bundle.main.infoDictionary != nil else {return ""}
            return Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String
        }//end get
    }//end computed property
    static var appBundleBuild:String {
        get { guard Bundle.main.infoDictionary != nil else {return ""}
            return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        }//end get
    }
}




