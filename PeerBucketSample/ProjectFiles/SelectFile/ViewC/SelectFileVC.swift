//
//  SelectFileVC.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/17/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit
import MobileCoreServices

final class SelectFileVC: BaseVC {
    let imagePicker = UIImagePickerController()
    private static let kSTORYBOARDNAME = "DocsAndFiles"
    var arrOfImages:[UIImage] = [UIImage]()
    var userId: String?, userType: String?, company_id: String?, type: String?, project_team_id: String?, parent_id: String?


    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    @IBOutlet weak var menuView: UIView!
    let menuHeight = UIScreen.main.bounds.height / 2
    var isPresenting = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tapCameraButton(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            Utility.showOkAlertOnViewController(viewC: self, withMessage: "Camera Device Not Accessible", alertTitle: APPNAME)
        }
    }
    
    @IBAction func tapGalleryButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = true
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true) {
                
            }
        }
        
    }
    
    @IBAction func tapFileButton(_ sender: UIButton) {
    }
    
    @IBAction func tapCrossButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Public and open methods
    
    /// This method is used for getting the object of the current view controller, to push in the Navigation Stack.
    ///
    /// - Returns: Object of the SelectFileVC class
    open class func loadViewController() -> SelectFileVC? {
        let storyBoard = UIStoryboard(name: kSTORYBOARDNAME, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: SelectFileVC.name) as? SelectFileVC ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        
//        menuView.backgroundColor = .red
//        menuView.translatesAutoresizingMaskIntoConstraints = false
//        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
//        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectFileVC.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectFileVC: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}


//MARK: ImagePicker Extension
extension SelectFileVC{
    
   
    
}

