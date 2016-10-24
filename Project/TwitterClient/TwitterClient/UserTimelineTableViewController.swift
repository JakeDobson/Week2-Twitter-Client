//
//  UserTimelineTableViewController.swift
//  TwitterClient
//
//  Created by Jacob Dobson on 10/24/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

import UIKit

class UserTimelineTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var tweet: Tweet?
    
    var tweets = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupTableView()
    }
    
    func setupViewController() {
        if let tweet = self.tweet, let user = tweet.user {
            self.navigationItem.title = user.screenName
            self.update(screenName: user.screenName)
        }
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        
    }
    
    func update(screenName: String) {
        API.shared.GETUserTweets(username: screenName) { (tweets) -> () in
            guard let tweets = tweets else { return }
            OperationQueue.main.addOperation {
                self.tweets = tweets
            }
        }
    }
    
}

extension UserTimelineTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureCellFor(indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = self.tableView.dequeueReusableCell(withIdentifier: "TwitterCell", for: indexPath) as! TweetDetailTableViewCell
        
        tweetCell.tweet = self.tweets[indexPath.row]
        
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCellFor(indexPath: indexPath)
    }
    
}
