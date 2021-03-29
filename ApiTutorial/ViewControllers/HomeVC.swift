//
//  ViewController.swift
//  ApiTutorial
//
//  Created by 김동환 on 2021/03/27.
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
            
            nextVC.vcTitle = userInputValue + " 👨‍💻"
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else {return}
            
            nextVC.vcTitle = userInputValue + "  🏞"
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
        // 키보드 사이즈 가져오기
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchButton.frame.origin.y : \(searchButton.frame.origin.y)")
            
            if(keyboardSize.height < searchButton.frame.origin.y){
                print("키보드가 버튼을 덮었다.")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                print("이만큼 덮었다. distance : \(distance)")
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
            self.view.makeToast("📣 검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() searchText : \(searchText)")
        
        // 사용자가 입력한 값이 없을때
        if (searchText.isEmpty) {
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                // 포커싱 해제
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
            self.view.makeToast("📢 12자 까지만 입력가능합니다.", duration: 1.0, position: .center)
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
        
        // 터치로 들어온 뷰가 요놈이면
        if(touch.view?.isDescendant(of: searchFilterSegment) == true){
            //            print("세그먼트가 터치되었다.")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true){
            //            print("서치바가 터치되었다.")
            return false
        } else {
            view.endEditing(true)
            //            print("화면이 터치되었다.")
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
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        
        self.searchBar.becomeFirstResponder() // 포커싱 주기
    }
    
    

}
