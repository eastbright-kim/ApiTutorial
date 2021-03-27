//
//  BaseVC.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/27.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    
      var vcTitle : String = "" {
          didSet {
              print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
              self.title = vcTitle
          }
      }
    
}
