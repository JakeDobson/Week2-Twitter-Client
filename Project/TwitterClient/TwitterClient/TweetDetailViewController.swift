//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Jacob Dobson on 10/23/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetDetailImageView: UIImageView!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextLabel.text = tweet.text
        
        setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func imageTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "userTimelineSegue", sender: nil)
    }
    
    func setupAppearance() {
        tweetDetailImageView.clipsToBounds = true
        tweetDetailImageView.layer.cornerRadius = 30.0
    }
    
    func setupTweet(){
        if let user = tweet.user {
            
            self.navigationItem.title = "@\(tweet.user!.name)"
            self.tweetTextLabel.text = tweet.text
            //self.usernameLabel.text = "@\(user.name)"
            
            self.profileImage(key: user.profileImageURLString, completion: { (image) -> () in
                self.tweetDetailImageView.image = image
            })
        }
    }
    
    func profileImage(key: String, completion: @escaping (UIImage?) -> ()) {
        if let image = SimpleCache.shared.image(key: key) {
            completion(image)
            return
        }
        
        API.shared.getImageFor(urlString: key) { (image) -> () in
            if let image = image {
                completion(image)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "userTimelineSegue" {
            let userTimelineTableViewController = segue.destination as! UserTimelineTableViewController
            userTimelineTableViewController.tweet = self.tweet
        }
        
    }
}
