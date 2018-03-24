
//  Created by Rohit Singh on 12/10/17.
//  Copyright © 2017 Rohit Singh. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    class func logInput(input: Any) {
        #if DEV
            print(input)
        #elseif UAT
            print(input)
        #endif
        print(input)

    }
    
    class func readJsonFromFileName(fileName : String) -> Dictionary<String, Any>? {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? Dictionary<String, Any> {
                    return object
                } else {
                    return nil
                }
            } else {
                self.logInput(input: "No file found.")
                return nil
            }
        } catch {
            Utility.logInput(input:error.localizedDescription)
            return nil
        }
    }

    class func getJSONStringFromObject (dict: Dictionary<String, Any>) -> String {
        
        var jsonStringOfClasses = ""
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                //                print(JSONString)
                jsonStringOfClasses = JSONString
            }
        } catch {
            
        }
        
        return jsonStringOfClasses
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // Utility.logInput(input:"validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func showOkAlertOnViewController(viewC: UIViewController, withMessage message: String, alertTitle title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            
        }
        alertVC.addAction(okAction)
        viewC.present(alertVC, animated: true) {
        }
    }
    
    
    class func showOkAlertOnRootViewController(message: String, alertTitle title: String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: Alert With buttons
    class func showOkCancelAlertViewOnViewC(_ viewC : UIViewController, title: String,
                                                     message: String,
                                                     okClickResult: @escaping (_ index: Int,_ action: UIAlertController)->(),cancelClickResult: @escaping (_ index : Int, _ action: UIAlertController)->()){
        
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            okClickResult(0,alert)
            
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            cancelClickResult(0,alert)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewC.present(alert, animated: true) { () -> Void in
        }
    }
    class func setUnderLineOnBasisOfView(_ view : UIView?, colorPassed color : UIColor) {
        
        if  let lable  = view as? UILabel {
//            let lable = (view as? UILabel)!
            let lineView = UIView(frame: CGRect(x: 0, y: lable.frame.size.height, width: lable.frame.size.width, height: 2))
            lineView.backgroundColor = color
            lable.addSubview(lineView)
            
        }
        if let btn = view as? UIButton {
            let lineView = UIView(frame: CGRect(x: 0, y: btn.frame.size.height, width: btn.frame.size.width, height: 2))
            lineView.backgroundColor = color
            btn.addSubview(lineView)
        }
        if let textField = view as? UITextField {
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = color.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width :  textField.frame.size.width, height: textField.frame.size.height)
            
            border.borderWidth = width
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
            
            
        }
    }
    
    class func createFolderInDocumentDirectory(withName folderName: String) {
            let filemgr = FileManager.default
            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            let docsURL = dirPaths[0]
            let newDir = docsURL.appendingPathComponent(folderName).path
        
    
            do {
                try filemgr.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
                print("\(folderName)-Folder created successfully with path= \(newDir)")
            } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
}
