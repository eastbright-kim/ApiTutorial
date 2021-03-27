//
//  MyAlamofireManager.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    
    static let shared = MyAlamofireManager()
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
    ])
    
    var session: Session
    
    private init(){
        session = Session(interceptor: interceptors)
    }
    
}
