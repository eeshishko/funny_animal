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
    
    var completeAuthorization: ((Bool, User?) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: "https://sberbank-talents.ru/mobius19/")!)
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension WebFormViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        guard let responseURL = navigationResponse.response.url,
                responseURL.absoluteString == "https://sberbank-talents.ru/succsess-mobius19/" else {
            return
        }
        
        if let response = navigationResponse.response as? HTTPURLResponse {
            let user: User? = nil
            //TODO: fetch user somehow
            dismiss(animated: true) { [weak self] in
                self?.completeAuthorization?(response.statusCode == 200, user)
            }
        }
    }
}
