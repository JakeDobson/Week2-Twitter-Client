//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Jacob Dobson on 10/23/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func dismissModalViewAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var tweet: Tweet! {
        self.userNameLabel.text = self.tweet.text
        
        if let user = self.tweet.user {
            self.userNameLabel.text = user.name
            
            if let image = SimpleCache.shared.image(key: user.profileImageURLString) {
                // In The Cache
                print("image in cache")
                profileImageView.image = image
            }else{
                // NOT In The Cache - Go get em
                API.shared.getImageFor(urlString: user.profileImageURLString, completion: { (image) -> () in
                    if let image = image {
                        SimpleCache.shared.setImage(image, key: user.profileImageURLString)
                        print("no image in cache")
                        self.profileImageView.image = image
                    }
                })
            }
        }
        return self.tweet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameLabel.text = tweet.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
