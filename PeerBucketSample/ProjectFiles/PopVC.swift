//
//  popVC.swift
//  MAFUtilityAppiOS
//
//  Created by Noufal chakkali Parambil on 3/13/18.
//  Copyright © 2018 Majid Al Futtaim. All rights reserved.
//

import UIKit

protocol PopViewOptionClickedProtocol: class {
    func sendCallBackOnTopItemClicked(_: UIButton);
    func sendCallBackOnBottomItemClicked(_: UIButton);

}

class PopVC: BaseVC {
    
    weak var delegatePopViewC: PopViewOptionClickedProtocol?
    
    @IBAction func tapTopButton(_ sender: AnyObject) {
        if delegatePopViewC != nil {
            delegatePopViewC?.sendCallBackOnTopItemClicked(sender as! UIButton)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapBottomButton(_ sender: AnyObject) {
        delegatePopViewC?.sendCallBackOnBottomItemClicked(sender as! UIButton)
        dismiss(animated: true, completion: nil)
    }
}
