//
//  BaseInterceptor.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("Interceptor adapt func called")
        //거의 맨 처음에 시작됨
        var urlRequest = urlRequest
        urlRequest.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        var dictionary = [String:String]()
        
        dictionary.updateValue(API.CLIENT_ID, forKey: "client_id")
        
        do{
            urlRequest = try URLEncodedFormParameterEncoder().encode(dictionary, into: urlRequest)
        } catch {
            print(error)
        }
        
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("Interceptor retry() called")
        
        if let statusCode = request.response?.statusCode {
            
            let data = ["statusCode" : statusCode]
            
            NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
            
        } else {
            completion(.doNotRetry)
            return
        }
        
        completion(.doNotRetry)
    }
    
}
