//
//  WebFormViewController.swift
//  HitTheTree
//
//  Created by Evgeny Shishko on 21/05/2019.
//  Copyright © 2019 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import WebKit

struct User {
    let name: String
    let surname: String
}

class WebFormViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var timer: Timer!
    var firstName: String = ""
    var lastName: String = ""
    
    var completeAuthorization: ((Bool, User) -> (Void))?

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let value = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
//        UINavigationController.attemptRotationToDeviceOrientation()
//    }

//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.portrait.rawValue)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem

        let request = URLRequest(url: URL(string: "https://sberbank-talents.ru/mobius19/")!)
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.webView.evaluateJavaScript("document.getElementsByName(\"FirstName\")[0].value",
                                             completionHandler: { (firstName: Any?, error: Error?) in
                                                if let firstName = firstName as? String, firstName.count > 0 {
                                                    self?.firstName = firstName
                                                }
            })

            self?.webView.evaluateJavaScript("document.getElementsByName(\"LastName\")[0].value",
                                             completionHandler: { (lastName: Any?, error: Error?) in
                                                if let lastName = lastName as? String, lastName.count > 0 {
                                                    self?.lastName = lastName
                                                }
            })
        }
    }
}

extension WebFormViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)

//        timer.invalidate()
//        timer = nil

        guard let responseURL = navigationResponse.response.url,
                responseURL.absoluteString == "https://sberbank-talents.ru/succsess-mobius19/" else {
            return
        }
        
        if let response = navigationResponse.response as? HTTPURLResponse {
            let user: User = User(name: firstName, surname: lastName)
            //TODO: fetch user somehow
            dismiss(animated: true) { [weak self] in
                self?.completeAuthorization?(response.statusCode == 200, user)
            }
        }
    }
}
