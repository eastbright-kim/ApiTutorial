//
//  ViewController.swift
//  ApiTutorial
//
//  Created by κΉλν on 2021/03/27.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.config()
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = self.searchBar.text else {return}
            
            nextVC.vcTitle = userInputValue + " π¨βπ»"
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else {return}
            
            nextVC.vcTitle = userInputValue + "  π"
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func config(){
        
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.keyboardDismissTapGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    fileprivate func pushVC(){
        var segueId: String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            segueId = SEGUE_ID.PHOTO_COLLECTION_VC
        case 1:
            segueId = SEGUE_ID.USER_LIST_VC
        default:
            print("default")
        }
        
        self.performSegue(withIdentifier: segueId, sender: self)
        
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification){
        print("HomeVC - keyboardWillShowHandle() called")
        // ν€λ³΄λ μ¬μ΄μ¦ κ°μ Έμ€κΈ°
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchButton.frame.origin.y : \(searchButton.frame.origin.y)")
            
            if(keyboardSize.height < searchButton.frame.origin.y){
                print("ν€λ³΄λκ° λ²νΌμ λ?μλ€.")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                print("μ΄λ§νΌ λ?μλ€. distance : \(distance)")
                self.view.frame.origin.y = distance + searchButton.frame.height
            }
        }

    }
    
    @objc func keyboardWillHideHandle(){
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() ")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            // toast with a specific duration and position
            self.view.makeToast("π£ κ²μ ν€μλλ₯Ό μλ ₯ν΄μ£ΌμΈμ", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() searchText : \(searchText)")
        
        // μ¬μ©μκ° μλ ₯ν κ°μ΄ μμλ
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                // ν¬μ»€μ± ν΄μ 
                searchBar.resignFirstResponder()
            })
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn : \(inputTextCount) / text : \(text)")
        
        if (inputTextCount >= 12){
            // toast with a specific duration and position
            self.view.makeToast("π’ 12μ κΉμ§λ§ μλ ₯κ°λ₯ν©λλ€.", duration: 1.0, position: .center)
        }
        
        //        if inputTextCount <= 12 {
        //            return true
        //        } else {
        //            return false
        //        }
        return inputTextCount <= 12
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //        print("HomeVC - gestureRecognizer shouldReceive() called")
        
        // ν°μΉλ‘ λ€μ΄μ¨ λ·°κ° μλμ΄λ©΄
        if(touch.view?.isDescendant(of: searchFilterSegment) == true){
            //            print("μΈκ·Έλ¨ΌνΈκ° ν°μΉλμλ€.")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true){
            //            print("μμΉλ°κ° ν°μΉλμλ€.")
            return false
        } else {
            view.endEditing(true)
            //            print("νλ©΄μ΄ ν°μΉλμλ€.")
            return true
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
//        pushVC()
        
//        let url = API.BASE_URL + "search/photos/"
        
        guard let userInput = self.searchBar.text else { return }
        
//        let queryParam = ["query" : userInput, "client_id" : API.CLIENT_ID]
        
        //        AF.request(url, method: .get, parameters: queryParam).responseJSON { (response) in
        //            debugPrint(response)
        //
        
//        var urlToCall: URLRequestConvertible?
//
//        switch searchFilterSegment.selectedSegmentIndex {
//        case 0:
//            urlToCall = MySearchRouter.searchPhotos(term: userInput)
//        case 1:
//            urlToCall = MySearchRouter.searchUser(term: userInput)
//        default:
//            print("segmented default")
//        }
        
       
            MyAlamofireManager.shared.searchPhoto(searchTerm: userInput, completion: { result in
                
                switch result {
                case .success(let photos):
                    print(photos.count)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view.makeToast("\(error.rawValue)", duration: 1.5, position: .center)
                    }
                }
            })
    }
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            searchBarTitle = "μ¬μ§ ν€μλ"
        case 1:
            searchBarTitle = "μ¬μ©μ μ΄λ¦"
        default:
            searchBarTitle = "μ¬μ§ ν€μλ"
        }
        
        self.searchBar.placeholder = searchBarTitle + " μλ ₯"
        
        self.searchBar.becomeFirstResponder() // ν¬μ»€μ± μ£ΌκΈ°
    }
    
    

}
