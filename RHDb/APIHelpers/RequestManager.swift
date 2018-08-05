//
//  RequestManager.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Alamofire

class AlamofireRequestManager {
    
    private var manager: Alamofire.SessionManager
    
    init(manager: Alamofire.SessionManager = Alamofire.SessionManager.default) {
        self.manager = manager
    }
    
    func request<T: Decodable>(url: URL, method: Alamofire.HTTPMethod, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (_ result: Result<T>) -> Void) {
        
        let encoding: ParameterEncoding = method == .get ? URLEncoding.queryString : JSONEncoding.default
        
        self.manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let resValue):
                if let resDic = resValue as? [String: Any] {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let object = try decoder.decode(T.self, fromDict: resDic)
                        completion(.success(object))
                    } catch {
                        completion(.error(APIError.invalidData))
                    }
                    
                }
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
}

class RequestManager {
    func request<T: Decodable>(url: URL, method: HTTPMethod = .get, parameters: [String: Any] = [:], headers: HTTPHeaders = [:], completion: @escaping (_ result: Result<T>) -> Void) {
        
        let allParams = self.addDefaultParams(parameters)
        
        AlamofireRequestManager().request(url: url, method: method.toAlamofire(), parameters: allParams, headers: headers, completion: completion)
    }
    
    private func addDefaultParams(_ inParams: [String: Any]) -> [String: Any] {
        var params: [String: Any] = ["api_key": "a1b26c47897b6141bb87007e9bac0849",
                                     "language": Locale.languageAndRegion]
        
        params += inParams
        
        return params
    }
}

enum HTTPMethod {
    case get
    case post
    
    func toAlamofire() -> Alamofire.HTTPMethod {
        switch self {
        case .get:
            return Alamofire.HTTPMethod.get
        case .post:
            return Alamofire.HTTPMethod.post
        }
    }
}
