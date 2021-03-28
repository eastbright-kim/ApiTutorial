//
//  MyApiStatusLogger.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire

final class MyApiStatusLogger: EventMonitor {
    
    let queue: DispatchQueue = DispatchQueue(label: "MyApiStatusLogger")
    
//    func requestDidResume(_ request: Request) {
//        //request가 시작되고 받음
//        print("MyApiStatusLogger - requestDidResume()")
//        debugPrint(request)
//    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        //request 끝나고 response 받았을 때 실행됨
        guard let statusCode = request.response?.statusCode else {return}
        
        print("MyApiStatusLogger - request.didParseResponse()")
        debugPrint(statusCode)
        print("MyApiStatusLogger - request.didParseResponse() end")
    }
    
}
