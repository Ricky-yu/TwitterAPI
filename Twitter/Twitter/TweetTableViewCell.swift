//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by CHEN SINYU on 2019/05/08.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var textContentLabel: UILabel!
    
    func fill(tweet: Tweet){
        let downloadTask = URLSession.shared.dataTask(with:  URL(string: tweet.user.profileImageURL)!) { [weak self] data, response, error in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data!)
            }
        }
        downloadTask.resume()
        nameLabel.text = tweet.user.name
        textContentLabel.text = tweet.text
        screenNameLabel.text = "@" + tweet.user.screenName
    }
}
