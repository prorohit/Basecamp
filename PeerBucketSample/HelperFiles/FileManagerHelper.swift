//
//  FileManagerHelper.swift
//  PeerBucketSample
//
//  Created by Rohit Singh on 3/20/18.
//  Copyright © 2018 Zabius. All rights reserved.
//

import Foundation

class FileManagerHelper {
    
    static let filemgr = FileManager.default

    /// This function will create a new folder
    ///
    /// - Returns: URL of the Document Directory
    class func getDocumentDirectoryPath() -> URL {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        return docsURL
    }
    
    
    /// This function is used to create a new folder in document directory
    ///
    /// - Parameter folderName: Name of the folder
    @discardableResult
    class func createFolderInDocumentDirectory(withName folderName: String) -> (success: Bool, newFolderPath: String) {
        let filemgr = FileManager.default
        let docsURL = getDocumentDirectoryPath()
        let newDir = docsURL.appendingPathComponent(folderName).path
        
        do {
            try filemgr.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
            print("\(folderName)-Folder created successfully with path= \(newDir)")
            return (true, newDir)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return (false, error.localizedDescription)

        }
    }
    
    
    /// This function will delete all the files and folders in the document directory
    class func deleteAllFilesInDocumentDirectory() {
        do {
            let fileURLs = try filemgr.contentsOfDirectory(at: getDocumentDirectoryPath(), includingPropertiesForKeys: nil)
            print(fileURLs)
            do {
                for (_ , path) in fileURLs.enumerated() {
                    try filemgr.removeItem(at: path)
                }
            } catch let e {
                print(e.localizedDescription)
            }
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    
    /// This function will save a file inside a customm folder of the document dicretory
    ///
    /// - Parameters:
    ///   - folderName: Custome folder name
    ///   - fileName: File Name of which need to be saved
    ///   - data: data to be written
    /// - Returns: It will return the path of the files created in the custom folder or nil
    @discardableResult
    class func saveFileInCustomFolderInsideDocumentDirectory(folderName: String, fileName: String, data: Data) -> String? {
        let paths = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folderName) as NSString).appendingPathComponent(fileName)
        if filemgr.createFile(atPath: paths as String, contents: data, attributes: nil) {
            return paths
        } else {
            return nil
        }
    }
    
    
    /// This function will return the path of the custom folder if exists
    ///
    /// - Parameter customFolderName: Name of the custom folder
    /// - Returns: Returns the path of the new custom folder or nil if the folder does not exists
    @discardableResult
    class func getCustomFolderPathInsideDocumentDirectory(customFolderName: String) -> String? {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(customFolderName)
        if filemgr.fileExists(atPath: path) {
            return path
        } else {
            return nil
        }
    }
    
    
    /// This function will delete a file with file name from the document directory
    ///
    /// - Parameter fileName: File name
    /// - Returns: It will return true and false on the basis of the deletion status of the file
    @discardableResult
    class func deleteFileInsideDocumentDirectory(fileName: String) -> Bool {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        if filemgr.fileExists(atPath: path) {
            do {
             try filemgr.removeItem(at: URL(fileURLWithPath: path))
                return true
            } catch let e {
                print(e.localizedDescription)
                return false
            }
        } else {
            print("File does not exists")
            return false
        }
    }
    
    @discardableResult
    class func deleteFileFromFolderDocumentDirectory(fileName: String, folderName folder: String) -> Bool {
        let path = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folder) as NSString).appendingPathComponent(fileName)
        if filemgr.fileExists(atPath: path) {
            do {
                try filemgr.removeItem(at: URL(fileURLWithPath: path))
                return true
            } catch let e {
                print(e.localizedDescription)
                return false
            }
        } else {
            print("File does not exists")
            return false
        }
    }
    
    class func deleteAllFilesFromFolderInDocumentDirectory(folderName folder: String) {
        let path = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folder))
        let url = URL(fileURLWithPath: path)
    
        do {
            let fileURLs = try filemgr.contentsOfDirectory(at: url , includingPropertiesForKeys: nil)
            print(fileURLs)
            do {
                for (_ , path) in fileURLs.enumerated() {
                    try filemgr.removeItem(at: path)
                }
            } catch let e {
                print(e.localizedDescription)
            }
        } catch let e {
            print(e.localizedDescription)
        }
        

    
    }
   
}
