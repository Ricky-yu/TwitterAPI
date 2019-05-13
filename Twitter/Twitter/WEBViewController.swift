//
//  WEBViewController.swift
//  Twitter
//
//  Created by CHEN SINYU on 2019/05/13.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit
import WebKit

class WEBViewController: UIViewController, WKUIDelegate{
    
    private var webView: WKWebView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame:CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height), configuration: config)
        
        let urlString = "\(url)"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        setCancelButton()
    }
    func setCancelButton(){
        let CancelBtn = UIButton()
        CancelBtn.frame = CGRect(x: self.view.frame.width - 50, y: 10, width: 50, height: 50)
        CancelBtn.setImage(UIImage(named: "cancel"), for: .normal)
        CancelBtn.addTarget(self, action: #selector(self.closeView(_:)), for: .touchDown)
        
        self.webView.addSubview(CancelBtn)
    }
    
    @objc func closeView(_ :UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
