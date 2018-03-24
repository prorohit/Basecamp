//
//  DocsHomeVC+UICollectionView.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit
import Kingfisher
private let kCellIdentifileForFileCell = "cell_file"
private let kCellIdentifolderForFileCell = "cell_folder"

extension DocsHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout   {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelDocsHome.getNumberOfDocs()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellFile = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifileForFileCell, for: indexPath) as? CustomDocFileCell else {
            return UICollectionViewCell()
        }
        guard let cellFolder = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifolderForFileCell, for: indexPath) as? CustomDocFolderCell else {
            return UICollectionViewCell()
        }
        let model = viewModelDocsHome.getDocModelDetailAtIndexPath(index: indexPath.item)
        if model.doc_type == "folder" {
            cellFolder.labelFolderName.text = model.document_title
            return cellFolder
        } else {
            cellFile.labelFileName.text = model.document_title
            
            if model.ext == ".jpg" || model.ext == ".jpeg" || model.ext == ".png" {
                if let url = URL(string: model.url) {
                    cellFile.imageViewFileType.kf.setImage(with: url)
//                    cellFile.imageViewFileType.downloadedFrom(url: url, contentMode: UIViewContentMode.scaleAspectFit)
                }
            } else if model.ext == ".mp4" || model.ext == ".mov" {
                cellFile.imageViewFileType.image = UIImage(named: "video")
            } else if model.ext == ".doc" || model.ext == ".docx" {
                cellFile.imageViewFileType.image = UIImage(named: "word")
            }
            return cellFile
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModelDocsHome.getDocModelDetailAtIndexPath(index: indexPath.item)
        if model.doc_type == "folder" {
            guard let obj = DocsHomeVC.loadViewController() else { return }
            obj.isFolderClicked = true
            //viewModelDocsHome.getDocs(withUserId: "8", userType: "admin", company_id: "1008", type: "project", project_team_id: "26", parent_id: "0", limit: "0", offset: "0") {
            
            obj.userId = viewModelDocsHome.projectTeamModel?.user_id
            obj.userType = "admin"
            obj.company_id = viewModelDocsHome.projectTeamModel?.company_id
            obj.limit = "0"
            obj.offset = 0
            obj.type = viewModelDocsHome.projectTeamModel?.project_team_type
            obj.project_team_id = viewModelDocsHome.projectTeamModel?.project_team_id
            obj.parent_id = model.document_id
            obj.stringOfScrolling = viewModelDocsHome.stringOfScrolling + " > " + model.document_title
            navigationController?.pushViewController(obj, animated: true)
        } else {
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weak var weakSelf =  self
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if isLoading == false && viewModelDocsHome.isLoadMore == true {
                isLoading = true
                viewModelDocsHome.getDocs(withUserId: userId ?? "", userType: userType ?? "", company_id: company_id ?? "", type: type ?? "",
                  project_team_id: project_team_id ?? "", parent_id: parent_id ?? "", limit: limit ?? "0", offset: "\(offset)", isLoadMore: viewModelDocsHome.isLoadMore ) {
                    DispatchQueue.main.async {
                        weakSelf?.collectionViewDocsAndFolder.reloadData()
                        if let loadMore = (weakSelf?.viewModelDocsHome.isLoadMore), loadMore == true {
                            if let count = weakSelf?.offset {
                                weakSelf?.isLoading = false
                                let increased = count + 1
                                weakSelf?.offset = increased
                            }
                        }
                    }
            }
        }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooterReusableView", for: indexPath as IndexPath)
            reusableView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)

            return reusableView!
        }
      
        return reusableView!
    }
    
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
