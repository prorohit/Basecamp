
//  Created by Rohit Singh on 12/11/17.
//  Copyright © 2017 Rohit Singh. All rights reserved.
//

import Foundation

let APPNAME = "PeerBucket"
let PLEASEWAIT = "Please wait..."
let ERROR = "Error"
let INTERNETCONNECTIVITY = "No internet connection. Please connect to internet and try again"


//https://dev.peerbuckets.com/Api
//http://52.37.22.174/peerbucket_api/Api/
var DEVSERVERBASEURL = "https://dev.peerbuckets.com/Api/"
var UATSERVERBASEURL = "https://dev.peerbuckets.com/Api/"
var APPSTORESERVERBASEURL = "https://dev.peerbuckets.com/Api/"


//"rtl_ho"

let LIMITRECORDS = 50

enum APIEndPoints: String {
    case CREATEFOLDER = "create_folder"
    case GETCARDS = "get_cards"
    case DOCUPLAOD = "doc_upload"
}



enum Country: String {
    case UAE = "uae"
    case USA = "us"
}

enum Language: String {
    case ENG = "en"
    case ARB = "ar"
}
