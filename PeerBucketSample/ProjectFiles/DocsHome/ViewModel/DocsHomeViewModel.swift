//
//  DocsHomeViewModel.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import Foundation
import SVProgressHUD

class DocsHomeViewModel: NSObject {
    
    var projectTeamModel: ProjectTeamModel?
    var arrOfDocFilesFolders: [DocsHomeModel] = []
    var stringOfScrolling: String = ""
    var isLoadMore = false
    
    

    func getNumberOfDocs() -> Int {
        return arrOfDocFilesFolders.count
    }
    
    func getDocModelDetailAtIndexPath(index: Int) -> DocsHomeModel {
        let model = arrOfDocFilesFolders[index]
        return model
    }
    
    func getDocs(withUserId: String, userType: String,
                 company_id: String,
                 type: String, project_team_id: String,
                 parent_id: String, limit: String,
                 offset: String, isLoadMore: Bool, completionHandler: @escaping (() -> Void)) {
        weak var weakSelf = self
        let params = ["user_id": withUserId,
                      "user_type": userType,
                      "company_id": company_id,
                      "type": type,
                      "project_team_id": project_team_id,
                      "parent_id": parent_id,
                      "limit": limit,
                      "offset": offset]
        
        let finalURL = DEVSERVERBASEURL + APIEndPoints.GETCARDS.rawValue
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbiI6InBlZXJidWNrZXQifQ.VFpyg8qiBasCFTBU9IttVeiuibns5lJorSRCetFWGw8"
        if NetworkManager.sharedInstance.isInternetAvailable() {
            if isLoadMore == false {
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: PLEASEWAIT)
                }
            }
            NetworkManager.sharedInstance.makeFormEncodedAlamofireRequestWithEndpint(finalURL, methodName: NetworkManager.APIMETHOD.POST.rawValue, headers: ["token": token], params: params as [String : AnyObject], completionHandler: { (response, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        print(response!)
                        guard let response = response else { return }
                        guard let data = response["data"] as? [String: Any] else {return}
                        if let team = data["team"] as? [String: Any] {
                            
                            guard let company_id = team["company_id"] as? String else { return }
                            guard let created_at = team["created_at"] as? String else { return }
                            guard let project_team_name = team["project_team_name"] as? String else { return }
                            guard let user_id = team["user_id"] as? String else { return }
                            guard let created_by = team["created_by"] as? String else { return }
                            guard let project_team_type = team["project_team_type"] as? String else { return }
                            guard let updated_at = team["updated_at"] as? String else { return }
                            guard let project_team_id = team["project_team_id"] as? String else { return }
                            guard let status = team["status"] as? String else { return }
                            
                            weakSelf?.projectTeamModel = ProjectTeamModel(company_id: company_id, created_at: created_at, project_team_name: project_team_name, user_id: user_id, created_by: created_by, project_team_type: project_team_type, updated_at: updated_at, project_team_id: project_team_id, status: status)
                            
                            
                            weakSelf?.stringOfScrolling = project_team_name + " > " + "Docs & files"
                        }
                        
                        // Getting all the docs items
                        if let documents = data["documents"] as? [[String: Any]] {
                            
                            for (_ ,obj) in documents.enumerated() {
                                guard let document_title = obj["document_title"] as? String else { return }
                                guard let thumb = obj["thumb"] as? String else { return }
                                guard let parent_id = obj["parent_id"] as? String else { return }
                                guard let company_id = obj["company_id"] as? String else { return }
                                guard let content_type = obj["content_type"] as? String else { return }
                                guard let url = obj["url"] as? String else { return }
                                guard let user_id = obj["user_id"] as? String else { return }
                                guard let created_at = obj["created_at"] as? String else { return }
                                guard let size = obj["size"] as? String else { return }
                                guard let updated_at = obj["updated_at"] as? String else { return }
                                guard let ext = obj["extension"] as? String else { return }
                                guard let doc_type = obj["doc_type"] as? String else { return }
                                guard let name_on_disk = obj["name_on_disk"] as? String else { return }
                                guard let document_id = obj["document_id"] as? String else { return }
                                guard let document_description = obj["document_description"] as? String else { return }
                                guard let project_team_id = obj["project_team_id"] as? String else { return }
                                guard let status = obj["status"] as? String else { return }
                                
                                let model = DocsHomeModel(document_title: document_title, thumb: thumb, parent_id: parent_id, company_id: company_id, content_type: content_type, url: url, user_id: user_id, created_at: created_at, size: size, updated_at: updated_at, ext: ext, doc_type: doc_type, name_on_disk: name_on_disk, document_id: document_id, document_description: document_description, project_team_id: project_team_id, status: status)
                                
                                weakSelf?.arrOfDocFilesFolders.append(model)
                            }
                        }
                        
                        if let isLoad = data["isLoadMore"] as? String, isLoad == "true" {
                            weakSelf?.isLoadMore = true
                        } else {
                             weakSelf?.isLoadMore = false
                        }
                        
                        completionHandler()
                    } else {
                        Utility.showOkAlertOnRootViewController(message: APPNAME, alertTitle: (error?.localizedDescription)!)

                    }
                }
            })
        } else {
            Utility.showOkAlertOnRootViewController(message: APPNAME, alertTitle: INTERNETCONNECTIVITY)
        }
    }
}
