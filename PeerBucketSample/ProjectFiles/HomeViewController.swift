//
//  ViewController.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/16/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
         let params = ["user_id": "4",
         "user_type": "admin",
         "company_id": "1",
         "type": "team",
         "project_team_id": "1",
         "parent_id": "0",
         "limit": "0",
         "offset": "0"]*/
    }

    @IBAction func tapDocsButton(_ sender: UIButton) {
        guard let obj = DocsHomeVC.loadViewController() else { return }
        //viewModelDocsHome.getDocs(withUserId: "8", userType: "admin", company_id: "1008", type: "project", project_team_id: "26", parent_id: "0", limit: "0", offset: "0") {

        obj.userId = "8"
        obj.userType = "admin"
        obj.company_id = "1008"
        obj.limit = "0"
        obj.offset = 0
        obj.type = "project"
        obj.project_team_id = "26"
        obj.parent_id = "0"
        
        obj.stringOfScrolling = "Atinder Chat Test > Docs & files"
        navigationController?.pushViewController(obj, animated: true)
    }
}

