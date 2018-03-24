
//  Created by Rohit.Singh on 21/09/17.
//

import Foundation
import SystemConfiguration
import SVProgressHUD
import Alamofire

public class NetworkManager {
    public enum APIMETHOD: String {
        case GET
        case POST
        case PATCH
        case DELETE
        case PUT
    }
    // Therse two lines of code will make sure that only singleton instance of this class can be created
    public static let sharedInstance: NetworkManager = NetworkManager()
    
    private init() {}
    
    public func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    // Making String Request Api Call
    public func makeFormEncodedAlamofireRequestWithEndpint(_ apiPath: String,
                                                            time: TimeInterval = 60,
                                                            methodName: String,
                                                            headers: [String: String]?,
                                                            params: [String: AnyObject]?,
                                                            completionHandler: @escaping (_ response: [String: Any]?,
        _ error: NSError?) -> Void) {
        if self.isInternetAvailable() == true {
            
            Utility.logInput(input: "API Path =>>>>\n\(apiPath as Any)")
            if params != nil {
                Utility.logInput(input: "Params =>>>> \n \(params as Any)")
            }
            Alamofire.request(apiPath, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response: DataResponse<Any>) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                switch response.result {
                case.success(let data):

                    do {
                        let dataConverted = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let responseString = NSString(data: dataConverted , encoding: String.Encoding.utf8.rawValue)
                        Utility.logInput(input: "Printable Response =>>>> \n \(String.init(describing: responseString))")

                    } catch let parsingError {
                        Utility.logInput(input: parsingError)
                    }
                    
                    completionHandler(data as? [String: Any], nil)
                case.failure(let error):
                    Utility.logInput(input: error)
                    completionHandler(nil, error as NSError)
                }
            }
        } else {
            DispatchQueue.main.async(execute: {
                Utility.showOkAlertOnRootViewController(message: INTERNETCONNECTIVITY, alertTitle: ERROR)
            })
        }
    }
    
    
    public func uploadingUsingAlamofire(imageParamName: String, urlString: String, arrOfImages:[UIImage], headers: [String: String]?, parameters: Dictionary<String, Any>, completionHandler:@escaping (NSDictionary?, NSError?) -> Void) {
        
        var newHeader: HTTPHeaders?
        if let headers = headers {
            newHeader = headers
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for image in arrOfImages {
                
                var imageData : Data?
                
                imageData = UIImageJPEGRepresentation(image, 0.7)
                if imageData == nil {
                    imageData = UIImagePNGRepresentation(image)
                }
                if imageData != nil {
//                    multipartFormData.append(imageData!, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    multipartFormData.append(imageData!, withName: "\(imageParamName)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")

                }
                
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },to: urlString,
          headers: newHeader,
          
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    completionHandler(response.result.value as? NSDictionary,nil)
                }
            case .failure(let error):
                print(error)
                completionHandler(nil,error as NSError)
                
            }
            
        })
        
    }
    
    public func uploadingBigDataUsingAlamofire(fileKeyName: String, urlString: String, arrOfData:[Data], headers: [String: String]?, parameters: Dictionary<String, Any>, completionHandler:@escaping (NSDictionary?, NSError?) -> Void) {
        
        var newHeader: HTTPHeaders?
        if let headers = headers {
            newHeader = headers
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for data in arrOfData {
                    //                    multipartFormData.append(imageData!, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    multipartFormData.append(data, withName: "\(fileKeyName)", fileName: "\(Date().timeIntervalSince1970).mov", mimeType: "video/mov")
                
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },to: urlString,
          headers: newHeader,
          
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    completionHandler(response.result.value as? NSDictionary,nil)
                }
            case .failure(let error):
                print(error)
                completionHandler(nil,error as NSError)
                
            }
            
        })
        
    }

    
    
}

extension String {
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: Returns percent-escaped string.
    func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
}

extension Dictionary {
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    func stringFromHttpParameters() -> String {
        let parameterArray = map { key, value -> String in
            let percentEscapedKey = ((key as? String)!).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = ((value as? String)!).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
