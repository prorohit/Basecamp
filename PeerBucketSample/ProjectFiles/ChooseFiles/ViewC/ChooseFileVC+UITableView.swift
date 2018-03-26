//
//  ChooseFileVC+UITableView.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/24/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit

extension ChooseFileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelChooseFile.arrOfFileInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomChooseFileTableViewCell else { return UITableViewCell() }
        let dict = viewModelChooseFile.arrOfFileInfo[indexPath.row]
        if let fileType = dict[viewModelChooseFile.K_FILETYPE] as? String, fileType == "pdf" {
            cell.imageViewFileIcon.image = UIImage(named: "pdf")
        }
        else if let fileType = dict[viewModelChooseFile.K_FILETYPE] as? String, fileType == "doc" {
            cell.imageViewFileIcon.image = UIImage(named: "word")
        } else {
            cell.imageViewFileIcon.image = UIImage(named: "file")

        }
        
        if let fileName = dict[viewModelChooseFile.K_FILENAME] as? String {
            cell.labelFileName.text = fileName
        }
        if let fileSize = dict[viewModelChooseFile.K_FILESIZE] as? String {
            cell.labelFileSize.text = fileSize + " MB"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
