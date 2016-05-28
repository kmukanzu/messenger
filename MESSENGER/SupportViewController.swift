//
//  SupportViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/27/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class SupportViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        let url = NSURL (string: "https://support.snapchat.com/en-US/")
        
        webView.loadRequest(NSURLRequest(URL: url!))
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        webView.scrollView.contentInset = UIEdgeInsetsZero;
    }
}