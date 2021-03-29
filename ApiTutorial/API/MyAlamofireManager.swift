//
//  MyAlamofireManager.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/28.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    
    static let shared = MyAlamofireManager()
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
    ])
    
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    
    var session: Session
    
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func searchPhoto(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void) {
        
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON { (response) in
                print("start response")
                debugPrint(response)
                
                //json처리
                guard let value = response.value else { return }
                
                let jsonValue = JSON(value)
                let results = jsonValue["results"]
                var photos = [Photo]()
                
                for (index, subJson) : (String, JSON) in results {
                    
                    guard let thumb = subJson["urls"]["thumb"].string,
                          let username = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else {return}
                    
                    let likescount = subJson["likes"].intValue
                    
                    let photo = Photo(thumb: thumb, username: username, likescount: likescount, createdAt: createdAt)
                    
                    photos.append(photo)
                    
                }
                
                //완성된 json을 활용해서 다른 vc에서 씀 -> 컴플리션 블락
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(MyError.noContent))
                }
            }
    }
}
