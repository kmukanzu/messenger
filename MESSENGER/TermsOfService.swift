//
//  TermsOfService.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/26/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class TermsOfService: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        let url = NSURL (string: "https://www.snapchat.com/terms")
        
        webView.loadRequest(NSURLRequest(URL: url!))
    }
}