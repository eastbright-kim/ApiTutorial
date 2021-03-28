//
//  MySearchRouter.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire


//segmented control에 따라서 , url을 routing하고, url request를 return 함
enum MySearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUser(term: String)
    
    var baseUrl: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos"
        case .searchUser:
            return "users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .searchUser, .searchPhotos:
            return .get
        }
    }
    
    var param: [String : String] {
        switch self {
        case let .searchUser(term):
            return ["query" : term]
        case let .searchPhotos(term):
            return ["query" : term]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseUrl.appendingPathComponent(endPoint)
        
        var urlRequset = URLRequest(url: url)
        
        urlRequset.method = httpMethod
        
        urlRequset = try URLEncodedFormParameterEncoder().encode(param, into: urlRequset)
        
        return urlRequset
    }
    
}
