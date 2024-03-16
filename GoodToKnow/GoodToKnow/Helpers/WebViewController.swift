//
//  WebViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 16.03.24.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else {
            self.dismiss(animated: true)
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
