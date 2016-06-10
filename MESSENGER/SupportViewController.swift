//
//  SupportViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/27/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class SupportViewController : UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityInd =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let barButton = UIBarButtonItem(customView: activityInd)
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        activityInd.color = UIColor.lightGrayColor()
        activityInd.startAnimating()
        
        self.activityIndicator = activityInd
        
        loadAddress()
    }
    
    func loadAddress() {
        
        let requestURL = NSURL (string: "http://www.universitymessenger.org/support/")
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad( _: UIWebView) {
        
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad( _ : UIWebView) {
        
        activityIndicator.stopAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        webView.scrollView.contentInset = UIEdgeInsetsZero
    }
}