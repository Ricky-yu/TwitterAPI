//
//  ViewController.swift
//  Twitter
//
//  Created by CHEN SINYU on 2019/05/07.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TextField: UITextField!
    
    private var tweets:Array<Tweet> = []
    private var keyWord = ""
    private var activityIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.register(TweetTableViewCell.self, forCellReuseIdentifier: "Cell")
        TableView.delegate = self
        TableView.dataSource = self
        TableView.refreshControl = refreshControl
        refreshControl.addTarget(self,  action: #selector(Reload(_:)), for: .valueChanged)
        TableView.addSubview(refreshControl)
        initActivityIndicator()
    }
    @IBAction func Serach(_ sender: Any) {
        if(TextField.text == ""){
            return
        }
        TextField.endEditing(true)
        TableView.alpha = 0
        self.keyWord = TextField.text!
        activityIndicator.startAnimating()
        tweets.removeAll()
        TableView.reloadData()
        getData()
    }
    @objc func Reload(_ sender:UIRefreshControl){
        TableView.alpha = 0
        activityIndicator.startAnimating()
        getData()
    }
    func initActivityIndicator(){
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        self.view.addSubview(activityIndicator)
    }
}
extension ViewController{
     func getData(){
        let token = UserDefaults.standard.string(forKey: "Token")
        let headers = ["Authorization": "Bearer \(token!)",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
        ]
        let params: [String : AnyObject] = [
            "q": "\(self.keyWord)" as AnyObject,
            "lang": "ja" as AnyObject,
            "count": "30" as AnyObject,
        ]
        Alamofire.request("https://api.twitter.com/1.1/search/tweets.json", method: .get, parameters: params, headers: headers)
            .responseJSON { response in switch response.result {
            case .success(let value):
                
                 let json = JSON(value)
                 for i in 0...json["statuses"].count {
                    let profileImage = "\(json["statuses"][i]["user"]["profile_image_url_https"])"
                    let userName = "\(json["statuses"][i]["user"]["name"])"
                    let userText = "\(json["statuses"][i]["text"])"
                    let userId =  "\(json["statuses"][i]["id"])"
                    let userScreenName = "\(json["statuses"][i]["user"]["screen_name"])"
                    let userTwitterUrl = "https://twitter.com/\(json["statuses"][i]["user"]["screen_name"])"
                    let user = User(id: userId, screenName: userScreenName, name: userName, profileImageURL: profileImage, twitterUrl: userTwitterUrl)
                    let tweet = Tweet(id: userId, text: userText, user: user)
                    self.tweets.append( tweet)
                 }
                 self.TableView.reloadData()
                 self.TableView.alpha = 1
            case .failure(let error):
                 print("Request failed with error: \(error)")
                 return
                }
                self.TableView.refreshControl?.endRefreshing()
                self.activityIndicator.stopAnimating()
        }
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        cell.fill(tweet: tweets[indexPath.row])
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchURL : NSURL = NSURL(string: "\(tweets[indexPath.row].user.twitterUrl)" as String)!
        UIApplication.shared.openURL(searchURL as URL)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        
        if distanceToBottom < 600 {
            getData()
        }
    }
    
}

