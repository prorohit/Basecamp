//
//  SelectFileVC+UIImagePicker.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/17/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit
import AVKit



extension SelectFileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            OperationQueue.main.addOperation {
                weakSelf?.arrOfImages.removeAll()
                weakSelf?.arrOfImages.append(pickedImage)
                picker.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        guard let obj = SelectedFileVC.loadViewController() else {return}
                        if let arr = weakSelf?.arrOfImages {
                            obj.arrOfImagesPassed = arr
                            obj.fileContentType = FileContentType.IMAGE.rawValue
                            obj.fileType = ".jpg"
                            obj.userType = weakSelf?.userType
                            obj.userId = weakSelf?.userId
                            obj.project_team_id = weakSelf?.project_team_id
                            obj.company_id = weakSelf?.company_id
                            obj.parent_id = weakSelf?.parent_id
                            //obj.company_id = co
                        }
                        let navigationC = UINavigationController(rootViewController: obj)
                        navigationC.barTintColor = UIColor(red: 86 / 255.0, green: 189 / 255.0, blue: 137 / 255.0, alpha: 1.0)
                        weakSelf?.present(navigationC, animated: true, completion: {
                            
                        })
                    }
                  
                })
            }
        } else {
            OperationQueue.main.addOperation {
                picker.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        var uniqueVideoID = ""
                        var uniqueID = ""
                        
                        //Add this to ViewDidLoad
                        uniqueID = NSUUID().uuidString
                        guard let obj = SelectedFileVC.loadViewController() else {return}
                            obj.fileType = ".mov"
                            obj.userType = weakSelf?.userType
                            obj.fileContentType = FileContentType.VIDEO.rawValue
                            obj.userId = weakSelf?.userId
                            obj.project_team_id = weakSelf?.project_team_id
                            obj.company_id = weakSelf?.company_id
                            obj.parent_id = weakSelf?.parent_id
                            guard let videoURL = info[UIImagePickerControllerMediaURL] as? URL else { return }
                            var data = Data()
                            do {
                                data = try Data(contentsOf: videoURL)
                            } catch {
                                print("Problem while converting video URL to data")
                                return
                            }
                        
                        
                            //FileManagerHelper.
                        
                        //Now writeing the data to the temp diroctory.
                        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                        let tempDocumentsDirectory: AnyObject = tempPath[0] as AnyObject
                        uniqueVideoID = uniqueID  + "TEMPVIDEO.MOV"
                        let tempDataPath = tempDocumentsDirectory.appendingPathComponent(uniqueVideoID) as String
                        do {
                            try data.write(to: URL(fileURLWithPath: tempDataPath), options: [])
                        } catch let e {
                            print(e.localizedDescription)
                            return
                        }
                        
                        let fileManager = FileManager.default
                        //Getting the time value of the movie.
                        let fileURL = URL(fileURLWithPath: tempDataPath)
                        let asset = AVAsset(url: fileURL)

                        let duration : CMTime = asset.duration
                        //Now we remove the data from the temp Document Diroctory.
                        do{
                            try fileManager.removeItem(atPath: tempDataPath)
                        } catch {
                            //Do nothing
                        }

                        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                        let documentsDirectory: AnyObject = docPaths[0] as AnyObject
                        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]


                        do {
                            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                            print(fileURLs)
                            do {
                                for (_ , path) in fileURLs.enumerated() {
                                    try fileManager.removeItem(at: path)
                                }
                            } catch {
                                print("Problem while converting video URL to data")
                                return
                            }
                        } catch {

                        }
                        
                        uniqueVideoID = uniqueID  + "VIDEO.MOV"
                        let docDataPath = documentsDirectory.appendingPathComponent(uniqueVideoID) as String
                        do {
                            try data.write(to: URL(fileURLWithPath: docDataPath), options: [])
                        } catch let e {
                            print(e.localizedDescription)
                            return
                        }
                        //This creates a thumbnail image.
                        let assetImageGenerate = AVAssetImageGenerator(asset: asset)
                        assetImageGenerate.appliesPreferredTrackTransform = true
                        let time = CMTimeMake(asset.duration.value / 1, asset.duration.timescale)
                        
                        //This adds the thumbnail to the imageview.
                        if let videoImage = try? assetImageGenerate.copyCGImage(at: time, actualTime: nil) {
                            obj.arrOfImagesPassed.append(UIImage(cgImage: videoImage))
                        }
                        let size = Float(Double(data.count) / 1000.0)
                        
                        if size <= 25000 {
                            obj.dataOfVideoFile = data
                            
                            let navigationC = UINavigationController(rootViewController: obj)
                            navigationC.barTintColor = UIColor(red: 86 / 255.0, green: 189 / 255.0, blue: 137 / 255.0, alpha: 1.0)
                            weakSelf?.present(navigationC, animated: true, completion: {
                                
                            })
                        } else {
                            DispatchQueue.main.async {
                                Utility.showOkAlertOnRootViewController(message: "Max allowed size is 25 MB", alertTitle: APPNAME)

                            }
                        }
                        
                   
                    }
                    
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
