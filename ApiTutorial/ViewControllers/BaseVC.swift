//
//  BaseVC.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/27.
//

import UIKit
import Toast_Swift

class BaseVC: UIViewController {
    
    
      var vcTitle : String = "" {
          didSet {
              print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
              self.title = vcTitle
          }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUp(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    @objc fileprivate func showErrorPopUp(notification: NSNotification) {
        
        guard let statusCode = notification.userInfo?["statusCode"] else { return }
        
        DispatchQueue.main.async {
            self.view.makeToast("\(statusCode) 에러 발생", duration: 1.5, position: .center)
        }
        
    }
    
    
}
