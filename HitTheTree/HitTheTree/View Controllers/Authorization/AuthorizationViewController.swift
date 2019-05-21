//
//  AuthorizationViewController.swift
//  HitTheTree
//
//  Created by Evgeny Shishko on 21/05/2019.
//  Copyright © 2019 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController {
    @IBAction func openWebForm() {
        let webFormVC = UIStoryboard(name: "Authorization", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: WebFormViewController.self)) as! WebFormViewController
        webFormVC.completeAuthorization = { [weak self] (isAuthorized: Bool, user: User?) in
            //TODO: logic
            print(isAuthorized)
        }
        present(webFormVC, animated: true, completion: nil)
    }
}
