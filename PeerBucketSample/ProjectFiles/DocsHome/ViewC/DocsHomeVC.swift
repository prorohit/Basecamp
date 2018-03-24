//
//  DocsHomeVC.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit

class DocsHomeVC: BaseVC {
    
    private static let kSTORYBOARDNAME = "DocsAndFiles"
    @IBOutlet var viewModelDocsHome: DocsHomeViewModel!
    @IBOutlet weak var constraintWidthOfLabel: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewDocsAndFolder: UICollectionView!
    @IBOutlet weak var labelOfScrollTitle: UILabel!
    var isLoading = false
    
    var stringOfScrolling: String = ""
    var userId: String?, userType: String?, company_id: String?, type: String?, project_team_id: String?, parent_id: String?, limit: String?, offset: Int = 0
    
    var isFolderClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(_:)), name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil)
        
        configureUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "notificationIdentifier"), object: nil)
    }
    
    @objc func methodOfReceivedNotification (_ noti: Notification) {
       callGetFilesFoldersAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        weak var weakSelf = self
        offset = 0
        viewModelDocsHome.arrOfDocFilesFolders.removeAll()
        viewModelDocsHome.isLoadMore = false
        isLoading = false
        viewModelDocsHome.getDocs(withUserId: userId ?? "", userType: userType ?? "", company_id: company_id ?? "", type: type ?? "",
                                  project_team_id: project_team_id ?? "", parent_id: parent_id ?? "", limit: limit ?? "0", offset: "\(offset)", isLoadMore: viewModelDocsHome.isLoadMore ) {
                                    DispatchQueue.main.async {
                                        weakSelf?.settingScrollingStringTitle()
                                        weakSelf?.collectionViewDocsAndFolder.reloadData()
                                        if let loadMore = (weakSelf?.viewModelDocsHome.isLoadMore), loadMore == true {
                                            if let count = weakSelf?.offset {
                                                let increased = count + 1
                                                weakSelf?.offset = increased
                                            }
                                        }
                                    }
        }
    }
    
    func callGetFilesFoldersAPI() {
        weak var weakSelf = self
        offset = 0
        viewModelDocsHome.arrOfDocFilesFolders.removeAll()
        viewModelDocsHome.isLoadMore = false
        viewModelDocsHome.getDocs(withUserId: userId ?? "", userType: userType ?? "", company_id: company_id ?? "", type: type ?? "",
                                  project_team_id: project_team_id ?? "", parent_id: parent_id ?? "", limit: limit ?? "0", offset: "\(offset)", isLoadMore: viewModelDocsHome.isLoadMore ) {
                                    DispatchQueue.main.async {
                                        weakSelf?.collectionViewDocsAndFolder.reloadData()
                                        if let loadMore = (weakSelf?.viewModelDocsHome.isLoadMore), loadMore == true {
                                            if let count = weakSelf?.offset {
                                                let increased = count + 1
                                                weakSelf?.offset = increased
                                            }
                                        }
                                    }
        }
    }

    // MARK: Public and open methods
    
    /// This method is used for getting the object of the current view controller, to push in the Navigation Stack.
    ///
    /// - Returns: Object of the AlertViewVC class
    open class func loadViewController() -> DocsHomeVC? {
        let storyBoard = UIStoryboard(name: kSTORYBOARDNAME, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: DocsHomeVC.name) as? DocsHomeVC ?? nil
    }
    
    // MARK: Class Private Methods
    fileprivate func configureUI() {
        //textViewTitle.delegate = self
        
        //[myTextView setContentSize:CGSizeMake(width, myTextView.frame.size.height)];
        view.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        title = "Docs & Files"
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        let buttonLeft = UIBarButtonItem(customView: getNavigationBarBackButton())
        navigationItem.leftBarButtonItems = [buttonLeft]
        
        let rightOptionButton = UIBarButtonItem(customView: getNavigationBarRightOptionButton())
        navigationItem.rightBarButtonItems = [rightOptionButton]
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: self.view.frame.size.width / 2.0 - 10, height: 190.0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        collectionViewDocsAndFolder.collectionViewLayout = layout
        collectionViewDocsAndFolder.delegate = self
        collectionViewDocsAndFolder.dataSource = self
        collectionViewDocsAndFolder.backgroundColor = .clear
        
        collectionViewDocsAndFolder.register(CollectionFooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectionFooterReusableView")
        
    }
    
    func settingScrollingStringTitle() {
        let string = stringOfScrolling
        let attributedString = NSMutableAttributedString()
        
        let arrOfAllStrings = string.components(separatedBy: ">")
        for (i, val) in arrOfAllStrings.enumerated() {
            if i < arrOfAllStrings.count - 1 {
            attributedString.append(NSAttributedString(string: val,
                                                       attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSFontAttributeName: UIFont(name: "Helvetica Bold", size: 15) as Any]))
            
                attributedString.append(NSAttributedString(string: " > "))

            } else {
                attributedString.append(NSAttributedString(string: val,
                                                           attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]))
            }

        }

        
        
        guard let font = UIFont(name: "Helvetica", size: 15) else {return}
        let width = string.width(withConstrainedHeight: 31, font: font)
        labelOfScrollTitle.attributedText = attributedString
        constraintWidthOfLabel.constant = width
        scrollView.contentSize = CGSize(width: constraintWidthOfLabel.constant, height: 40)
        print(scrollView.contentSize)
    }
    
    override func sendCallBackOnBottomItemClicked(_: UIButton) {
        print("Upload files button clicked")
        weak var weakSelf = self
        DispatchQueue.main.async {
            guard let obj = SelectFileVC.loadViewController() else { return }
            obj.userType = weakSelf?.userType
            obj.userId = weakSelf?.userId
            obj.project_team_id = weakSelf?.project_team_id
            obj.company_id = weakSelf?.company_id
            obj.parent_id = weakSelf?.parent_id
            obj.modalPresentationStyle = .custom
            self.present(obj, animated: true, completion: nil)
        }
       
    }
    
    override func sendCallBackOnTopItemClicked(_: UIButton) {
        let model = DocsHomeModel(document_title: "Untitled", thumb: "", parent_id: "", company_id: "", content_type: "", url: "", user_id: "", created_at: "", size: "", updated_at: "", ext: "", doc_type: "folder_new", name_on_disk: "", document_id: "", document_description: "", project_team_id: "", status: "")
        viewModelDocsHome.arrOfDocFilesFolders.insert(model, at: 0)
        collectionViewDocsAndFolder.reloadData()
        return
    }
   

}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
