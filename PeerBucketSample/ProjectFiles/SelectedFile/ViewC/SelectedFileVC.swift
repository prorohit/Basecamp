//
//  SelectedFileVC.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/17/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit

class SelectedFileVC: BaseVC {
    private static let kSTORYBOARDNAME = "DocsAndFiles"
    var projectTitle = "Atinder test"
    var fileType = "", fileName = "", fileSize = "",  fileContentType = ""
    var dataOfVideoFile: Data = Data()
    
    var userId: String?, userType: String?, company_id: String?, type: String?, project_team_id: String?, parent_id: String?
    
    @IBOutlet var viewModelSelectedFiles: SelectedFileViewModel!
    @IBOutlet weak var imageViewOfSelectedFile: UIImageView!
    @IBOutlet weak var textFieldOfFileName: UITextField!
    @IBOutlet weak var labelFileExtension: UILabel!
    @IBOutlet weak var labelFileSize: UILabel!
    
    // if image is selected then
    var arrOfImagesPassed = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: Public and open methods

    /// This method is used for getting the object of the current view controller, to push in the Navigation Stack.
    ///
    /// - Returns: Object of the SelectFileVC class
    open class func loadViewController() -> SelectedFileVC? {
        let storyBoard = UIStoryboard(name: kSTORYBOARDNAME, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: SelectedFileVC.name) as? SelectedFileVC ?? nil
    }
    
    // MARK: Class Private Methods
    fileprivate func configureUI() {
        title = projectTitle
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        let buttonLeft = UIBarButtonItem(customView: getNavigationBarCrossButton())
        navigationItem.leftBarButtonItems = [buttonLeft]
        
        let rightOptionButton = UIBarButtonItem(customView: getNavigationBarUploadButton())
        navigationItem.rightBarButtonItems = [rightOptionButton]
        
        Utility.setUnderLineOnBasisOfView(textFieldOfFileName, colorPassed: UIColor(red: 86 / 255.0, green: 189 / 255.0, blue: 137 / 255.0, alpha: 1.0))
        
        if fileContentType ==  FileContentType.IMAGE.rawValue {
            let image = arrOfImagesPassed[0]
            imageViewOfSelectedFile.image = image
            let imageData: Data = UIImagePNGRepresentation(image)!
            print("Total bytes \(imageData.count)")
            let size = Float(Double(imageData.count) / 1000.0)
            labelFileSize.text = "\(size) KB"
        } else if fileContentType ==  FileContentType.VIDEO.rawValue {
            let image = arrOfImagesPassed[0]
            imageViewOfSelectedFile.image = image
            let size = Float(Double(dataOfVideoFile.count) / 1000.0)
            labelFileSize.text = "\(size) KB"
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        fileName = "\(timestamp)"
        textFieldOfFileName.text = fileName
        labelFileExtension.text = fileType
        
    }
    
    /// This method will return the left navigation bar button
    ///
    /// - Returns: UIButton object
    fileprivate func getNavigationBarCrossButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cross_white"), for: .normal)
        button.addTarget(self, action: #selector(tapCrossButton(_:)), for: .touchUpInside)
        return button
    }
    /// This method will return the Right navigation bar button
    ///
    /// - Returns: UIButton object
    fileprivate func getNavigationBarUploadButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(tapUploadButton(_:)), for: .touchUpInside)
        button.setTitle("UPLOAD FILE", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
        return button
    }
    
    @objc func tapUploadButton(_ sender: UIButton) {
        print("Upload files")
        guard let project_team_id = project_team_id else {return}
        guard let parent_id = parent_id else {return}
        guard let userId = userId else {return}
        guard let company_id = company_id else {return}
        guard let userType = userType else {return}

        
        let dictParams = ["project_team_id": project_team_id,
                          "parent_id": parent_id,
                          "file_name": textFieldOfFileName.text ?? "",
                          "doc_description" : "",
                          "user_id": userId,
                          "company_id" : company_id,
                          "user_type" : userType
                          
            ] as [String : Any]
        
        if NetworkManager.sharedInstance.isInternetAvailable() {
            if fileContentType == FileContentType.IMAGE.rawValue {
            NetworkManager.sharedInstance.uploadingUsingAlamofire(imageParamName: "doc", urlString: DEVSERVERBASEURL + APIEndPoints.DOCUPLAOD.rawValue, arrOfImages: arrOfImagesPassed, headers: ["token" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbiI6InBlZXJidWNrZXQifQ.VFpyg8qiBasCFTBU9IttVeiuibns5lJorSRCetFWGw8"], parameters: dictParams, completionHandler: { (response, error) in
                DispatchQueue.main.async(execute: {
                    if let res = response {
                        print(res)
                        if let message = res["messages"] {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil, userInfo: ["message" : message])
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil, userInfo: ["message" : "No message"])
                            }
                        }
                    
                    })
                
                })
            } else if fileContentType == FileContentType.VIDEO.rawValue {
                NetworkManager.sharedInstance.uploadingBigDataUsingAlamofire(fileKeyName: "doc", urlString: DEVSERVERBASEURL + APIEndPoints.DOCUPLAOD.rawValue, arrOfData: [dataOfVideoFile], headers: ["token" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbiI6InBlZXJidWNrZXQifQ.VFpyg8qiBasCFTBU9IttVeiuibns5lJorSRCetFWGw8"], parameters: dictParams, completionHandler: { (response, error) in
                    DispatchQueue.main.async(execute: {
                        if let res = response {
                            print(res)
                            if let message = res["messages"] {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil, userInfo: ["message" : message])
                            } else {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil, userInfo: ["message" : "No message"])
                            }
                        }
                        
                    })
                })
            }
            
            
            
        } else {
            
        }
    }
    @objc func tapCrossButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
