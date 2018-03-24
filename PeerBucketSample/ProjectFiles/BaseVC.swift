//
//  BaseVC.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseVC: UIViewController, PopViewOptionClickedProtocol {

    class var name: String { return String(describing: self) }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Changin the color of the navigation bar title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    
   
    /// This method will return the left navigation bar button
    ///
    /// - Returns: UIButton object
    func getNavigationBarBackButton() -> UIButton {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        return backButton
    }
    
    /// It is used to go back in the navigation stack
    ///
    /// - Parameter sender: UIbutton Object which is clicked to go back in the navigation stack
    @objc func tapBackButton (_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    /// It is used to show the popup view controller on the screen
    ///
    /// - Parameter sender: UIbutton Object which will be clicked and pop up view controller will be shown
    @objc func tapMenuOtionButton (_ sender: UIButton) {
        showPopup(originx: sender.bounds.midX, originy: sender.bounds.minY - 20, popWidth: 300, popHeight: 90, sourceView: sender)

    }
    
    
    func getNavigationBarRightOptionButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 40)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(tapMenuOtionButton(_:)), for: .touchUpInside)
        return button
    }
    
    
    /// This method is used to present the pop view controller
    ///
    /// - Parameters:
    ///   - originx: Origin from x axis of Pop view
    ///   - originy: Orign from y axis of the pop view
    ///   - popWidth: Width of the Pop up view
    ///   - popHeight: Height of the pop up view
    ///   - sourceView: Source view - clicked button to present thr pop up view conrtroller
    
    fileprivate func showPopup(originx: CGFloat, originy: CGFloat, popWidth: CGFloat, popHeight: CGFloat, sourceView: UIView) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: PopVC.name) as? PopVC else { return }
        
        popVC.delegatePopViewC = self
        popVC.modalPresentationStyle = .popover
        popVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = sourceView
        popOverVC?.sourceRect = sourceView.bounds
        //popOverVC?.sourceRect = CGRect(x: originx, y: originy, width: 20, height: 40)
        popVC.preferredContentSize = CGSize(width: popWidth, height: popHeight)
        present(popVC, animated: true)
    }
    
    func sendCallBackOnTopItemClicked(_: UIButton) {
        
    }
    
    func sendCallBackOnBottomItemClicked(_: UIButton) {
        
    }
    
    class func getHeaders() -> [String: String] {
        return ["token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbiI6InBlZXJidWNrZXQifQ.VFpyg8qiBasCFTBU9IttVeiuibns5lJorSRCetFWGw8"]
    }
}

extension BaseVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
}

extension BaseVC {
    func createFolder(dictParams: [String: String],
                      completionHandler: @escaping (([String: Any]?) -> Void)) {
//        weak var weakSelf = self
        
        if NetworkManager.sharedInstance.isInternetAvailable() {
            let finalURL = DEVSERVERBASEURL + APIEndPoints.CREATEFOLDER.rawValue
            let headers = BaseVC.getHeaders()
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: PLEASEWAIT)
            }
            
            NetworkManager.sharedInstance.makeFormEncodedAlamofireRequestWithEndpint(finalURL, methodName: NetworkManager.APIMETHOD.POST.rawValue, headers: headers, params: dictParams as [String : AnyObject], completionHandler: { (response, error) in
                
                DispatchQueue.main.async {
                    if error != nil {
                        Utility.showOkAlertOnRootViewController(message: APPNAME, alertTitle: error.debugDescription)
                        completionHandler(nil)
                    } else {
                        completionHandler(response)
                    }
                }
               
                
            })
        

        } else {
            Utility.showOkAlertOnRootViewController(message: APPNAME, alertTitle: INTERNETCONNECTIVITY)

        }
    }
}



