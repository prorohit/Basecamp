//
//  SelectFileVC.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/17/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit
import MobileCoreServices

class ChooseFileVC: BaseVC {
    @IBOutlet var viewModelChooseFile: ChooseFileViewModel!
    private static let kSTORYBOARDNAME = "DocsAndFiles"
    fileprivate let colorSelected = UIColor.black
    fileprivate let colorUnSelected = UIColor.darkGray
    @IBOutlet weak var btnPDF: UIButton!
    @IBOutlet weak var btnDOC: UIButton!
    @IBOutlet weak var btnPPT: UIButton!
    @IBOutlet weak var btnXLS: UIButton!
    @IBOutlet weak var btnTXT: UIButton!
    let underLineColor = UIColor(red: 86 / 255.0, green: 189 / 255.0, blue: 137 / 255.0, alpha: 1.0)
    
    
    var globalClosure = {(dict: [String: Any]) -> Void in }
    
    func sendCallBackWithDictionary(completionHandler: @escaping ([String: Any]) -> Void) {
        globalClosure = completionHandler
    }

    @IBOutlet weak var tableViewDocs: UITableView!
    
    @IBAction func tapPDFButton(_ sender: UIButton) {
        selectingButtonWithType(type: DOCFILETYPE.PDF.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.PDF.rawValue)
        tableViewDocs.reloadData()
    }
    
    @IBAction func tapDOCButton(_ sender: UIButton) {
        selectingButtonWithType(type: DOCFILETYPE.DOC.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.DOC.rawValue)
        tableViewDocs.reloadData()
    }
    
    @IBAction func tapPPTButton(_ sender: UIButton) {
        selectingButtonWithType(type: DOCFILETYPE.PPT.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.PPT.rawValue)
        tableViewDocs.reloadData()
    }
    
    @IBAction func tapXLSButton(_ sender: UIButton) {
        selectingButtonWithType(type: DOCFILETYPE.XLS.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.XLS.rawValue)
        tableViewDocs.reloadData()
    }
    
    @IBAction func tapTXTButton(_ sender: UIButton) {
        selectingButtonWithType(type: DOCFILETYPE.TEXT.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.TEXT.rawValue)
        tableViewDocs.reloadData()
    }
    
    @IBAction func tapCrossButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectingButtonWithType(type: String) {
        unSelectingButtons()
        
        if type == DOCFILETYPE.PDF.rawValue {
            btnPDF.setTitleColor(UIColor.black, for: .normal)
            Utility.setUnderLineOnBasisOfView(btnPDF, colorPassed: underLineColor)
        } else if type == DOCFILETYPE.DOC.rawValue{
            btnDOC.setTitleColor(UIColor.black, for: .normal)
            Utility.setUnderLineOnBasisOfView(btnDOC, colorPassed: underLineColor)
        } else if type == DOCFILETYPE.PPT.rawValue {
            btnPPT.setTitleColor(UIColor.black, for: .normal)
            Utility.setUnderLineOnBasisOfView(btnPPT, colorPassed: underLineColor)
        } else if type == DOCFILETYPE.XLS.rawValue {
            btnXLS.setTitleColor(UIColor.black, for: .normal)
            Utility.setUnderLineOnBasisOfView(btnXLS, colorPassed: underLineColor)
        } else if type == DOCFILETYPE.TEXT.rawValue {
            btnTXT.setTitleColor(UIColor.black, for: .normal)
            Utility.setUnderLineOnBasisOfView(btnTXT, colorPassed: underLineColor)
        }
    }
    
    func unSelectingButtons() {
        btnPDF.setTitleColor(UIColor.gray, for: .normal)
        Utility.setUnderLineOnBasisOfView(btnPDF, colorPassed: UIColor.white)
        btnDOC.setTitleColor(UIColor.gray, for: .normal)
        Utility.setUnderLineOnBasisOfView(btnDOC, colorPassed: UIColor.white)
        btnPPT.setTitleColor(UIColor.gray, for: .normal)
        Utility.setUnderLineOnBasisOfView(btnPPT, colorPassed: UIColor.white)
        btnXLS.setTitleColor(UIColor.gray, for: .normal)
        Utility.setUnderLineOnBasisOfView(btnXLS, colorPassed: UIColor.white)
        btnTXT.setTitleColor(UIColor.gray, for: .normal)
        Utility.setUnderLineOnBasisOfView(btnTXT, colorPassed: UIColor.white)
    }
    
//    // MARK: Public and open methods
    
    /// This method is used for getting the object of the current view controller, to push in the Navigation Stack.
    ///
    /// - Returns: Object of the SelectFileVC class
    open class func loadViewController() -> ChooseFileVC? {
        let storyBoard = UIStoryboard(name: kSTORYBOARDNAME, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: ChooseFileVC.name) as? ChooseFileVC ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a document"
        //navigationController?.navigationController.
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        let buttonLeft = UIBarButtonItem(customView: getNavigationBarCrossButton())
        navigationItem.leftBarButtonItems = [buttonLeft]
        
        let rightOptionButton = UIBarButtonItem(customView: getNavigationBarUploadButton())
        navigationItem.rightBarButtonItems = [rightOptionButton]
        tableViewDocs.delegate = self
        tableViewDocs.dataSource = self
        tableViewDocs.tableFooterView = UIView(frame: .zero)
        
        unSelectingButtons()
        selectingButtonWithType(type: DOCFILETYPE.PDF.rawValue)
        viewModelChooseFile.getAllFilesForSharingDocs(ofType: DOCFILETYPE.PDF.rawValue)
        tableViewDocs.reloadData()
    }
    
    /// This method will return the left navigation bar button
    ///
    /// - Returns: UIButton object
    fileprivate func getNavigationBarCrossButton() -> UIButton {
        let button = UIButton(type: .custom)
        //back
        button.setImage(UIImage(named: "cross_white"), for: .normal)
        button.addTarget(self, action: #selector(tapCrossButton(_:)), for: .touchUpInside)
        return button
    }
    /// This method will return the Right navigation bar button
    ///
    /// - Returns: UIButton object
    fileprivate func getNavigationBarUploadButton() -> UIButton {
        let button = UIButton(type: .custom)
//        button.addTarget(self, action: #selector(tapUploadButton(_:)), for: .touchUpInside)
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
        return button
    }
    
 
  
}



