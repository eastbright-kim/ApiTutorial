//
//  MyLogger.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "ApiLog")
    
    func requestDidResume(_ request: Request) {
        
        print("requestDidResume called")
        debugPrint(request)
        print("requestDidResume end")
    }
    
//    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
//        print("request did parse response called")
//        
//        print("MyLogger - request.didParseResponse()")
//        debugPrint(response)
//    }
    
}
