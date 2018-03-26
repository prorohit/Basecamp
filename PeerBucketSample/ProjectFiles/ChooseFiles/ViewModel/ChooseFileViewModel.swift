//
//  SelectFileViewModel.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/17/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import UIKit

class ChooseFileViewModel: NSObject {

    let K_FILENAME = "fileName"
    let K_FILETYPE = "fileType"
    let K_FILEURL = "fileURL"
    let K_FILESIZE = "fileSize"

    
    var arrOfFileInfo = [Dictionary<String, Any>]()

    func makeDictObjectForURLAndName(url: URL, name: String, type: String, size: String) -> Dictionary<String, Any>  {
        let dict: Dictionary<String, Any> = [K_FILENAME: name,
                                             K_FILEURL : url,
                                             K_FILETYPE: type,
                                             K_FILESIZE: size]
        return dict
    }
    
    func getAllFilesForSharingDocs(ofType fileType: String) {
        arrOfFileInfo.removeAll()
        if fileType == DOCFILETYPE.PDF.rawValue {
            getPDFDocs()
        } else if fileType == DOCFILETYPE.DOC.rawValue {
            getWORDDocs()
        } else if fileType == DOCFILETYPE.XLS.rawValue {
            getExcelDocs()
        } else if fileType == DOCFILETYPE.PPT.rawValue {
            getPowerPointDocs()
        }
        
        
    }
    
    func getPDFDocs(fileType: String = "pdf") {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            let pdfFileUrls = directoryContents.filter{ $0.pathExtension == fileType }
            print("file urls:",pdfFileUrls)
            let pdfFileNames = pdfFileUrls.map{ $0.deletingPathExtension().lastPathComponent }
            print("filenames list:", pdfFileNames)
            
            let zip_pdfUrls_pdfNames = zip(pdfFileUrls, pdfFileNames)
            
            for pair in zip_pdfUrls_pdfNames {
                var size: Float = 0.0
                do {
                    let data = try Data(contentsOf: pair.0)
                    size = Float(Double(data.count) / 1000000.0)
                } catch {
                    
                }
                
                let dict = self.makeDictObjectForURLAndName(url: pair.0, name: pair.1 + "." + fileType, type: fileType, size: "\(size)")
                arrOfFileInfo.append(dict)
            }
            
        } catch let error {
            print("Error while enumerating files  \(error.localizedDescription)")
        }
    }
    
    func getWORDDocs(fileType: String = "doc") {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let arrOfFileExt = ["doc","docx"]

        for val in arrOfFileExt {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                let fileUrls = directoryContents.filter{ $0.pathExtension == val }
                print("file urls:",fileUrls)
                let fileNames = fileUrls.map{ $0.deletingPathExtension().lastPathComponent }
                print("filenames list:", fileNames)
                
                let zip_urls_names = zip(fileUrls, fileNames)
                
                for pair in zip_urls_names {
                    var size: Float = 0.0
                    do {
                        let data = try Data(contentsOf: pair.0)
                        size = Float(Double(data.count) / 1000000.0)
                    } catch {
                        
                    }
                    
                    let dict = self.makeDictObjectForURLAndName(url: pair.0, name: pair.1 + "." + val, type: fileType, size: "\(size)")
                    arrOfFileInfo.append(dict)
                }
                
            } catch let error {
                print("Error while enumerating files  \(error.localizedDescription)")
            }
        }
    }
    
    func getExcelDocs(fileType: String = "xls") {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let arrOfFileExt = ["xls","xlsx"]
        
        for val in arrOfFileExt {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                let fileUrls = directoryContents.filter{ $0.pathExtension == val }
                print("file urls:",fileUrls)
                let fileNames = fileUrls.map{ $0.deletingPathExtension().lastPathComponent }
                print("filenames list:", fileNames)
                
                let zip_urls_names = zip(fileUrls, fileNames)
                
                for pair in zip_urls_names {
                    var size: Float = 0.0
                    do {
                        let data = try Data(contentsOf: pair.0)
                        size = Float(Double(data.count) / 1000000.0)
                    } catch {
                        
                    }
                    
                    let dict = self.makeDictObjectForURLAndName(url: pair.0, name: pair.1 + "." + val, type: fileType, size: "\(size)")
                    arrOfFileInfo.append(dict)
                }
                
            } catch let error {
                print("Error while enumerating files  \(error.localizedDescription)")
            }
        }
    }
    
    func getPowerPointDocs(fileType: String = "ppt") {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let arrOfFileExt = ["ppt","pptx","pps"]
        
        for val in arrOfFileExt {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                let fileUrls = directoryContents.filter{ $0.pathExtension == val }
                print("file urls:",fileUrls)
                let fileNames = fileUrls.map{ $0.deletingPathExtension().lastPathComponent }
                print("filenames list:", fileNames)
                
                let zip_urls_names = zip(fileUrls, fileNames)
                
                for pair in zip_urls_names {
                    var size: Float = 0.0
                    do {
                        let data = try Data(contentsOf: pair.0)
                        size = Float(Double(data.count) / 1000000.0)
                    } catch {
                        
                    }
                    
                    let dict = self.makeDictObjectForURLAndName(url: pair.0, name: pair.1 + "." + val, type: fileType, size: "\(size)")
                    arrOfFileInfo.append(dict)
                }
                
            } catch let error {
                print("Error while enumerating files  \(error.localizedDescription)")
            }
        }
    }
    
    

}
