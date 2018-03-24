//
//  DocsHomeModel.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import Foundation

struct DocsHomeModel {
    /*
     "document_title":"new folder",
     "thumb":"",
     "parent_id":"0",
     "company_id":"1",
     "content_type":"",
     "url":"http:\/\/52.37.22.174\/peerbucket_api\/uploads\/",
     "user_id":"4",
     "created_at":"2018-03-16 05:53:32",
     "size":"0",
     "updated_at":"2018-03-16 05:53:32",
     "extension":"",
     "doc_type":"folder",
     "name_on_disk":"",
     "document_id":"16",
     "document_description":"",
     "project_team_id":"1",
     "status":"active"
     */
    let document_title: String, thumb: String, parent_id: String,
    company_id: String, content_type: String, url: String,
    user_id: String, created_at: String, size: String, updated_at: String, ext: String, doc_type: String,
    name_on_disk: String, document_id: String, document_description: String, project_team_id: String, status: String
    
}


struct ProjectTeamModel {
    /*
     "company_id":"1",
     "created_at":"2018-02-22 06:02:13",
     "project_team_name":"Sales",
     "user_id":"4",
     "created_by":"company",
     "project_team_type":"team",
     "updated_at":"2018-02-22 06:02:13",
     "project_team_id":"1",
     "status":"active"
     */
    let company_id: String, created_at: String, project_team_name: String, user_id: String, created_by: String, project_team_type: String, updated_at: String, project_team_id: String, status: String
}
