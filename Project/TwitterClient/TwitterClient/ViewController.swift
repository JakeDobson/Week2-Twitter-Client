//
//  ViewController.swift
//  TwitterClient
//
//  Created by Jacob Dobson on 10/17/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //computed properties
    var allTweets = [Tweet]() {
        didSet { // didSet is a property observer, will fire off once complete
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //set up delegate and dataSoure
        tableView.delegate = self //concerned with user touch interactions
        tableView.dataSource = self //concerned with loading the tableView with info(has 2 required methods --> see extension below)
        
        //setup layout of tableView
        self.tableView.backgroundColor = UIColor.purple
        //self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.green
        //self.tableView.widthAnchor.
        self.view.backgroundColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "detailTweetSegue" {
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            let selectedTweet = self.allTweets[selectedIndex]
            
            if let destinationViewController = segue.destination as? TweetDetailViewController {
                destinationViewController.tweet = selectedTweet
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update() {
        
        activityIndicator.startAnimating()
        
        API.shared.getTweets { (tweets) in
            if tweets != nil {
                //concurrency
                OperationQueue.main.addOperation { // taking assignment operation into the main queue
                    self.allTweets = tweets!
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK: TableViewDataSource and TableViewDelegate Methods

// Best practice is to write your dataSource as an extension!!!
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //implement required methods for dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        let currentTweet = self.allTweets[indexPath.row] //assigning each tweet to its own row
        cell.tweet = currentTweet
        return cell
    }
    //delegate methods...
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailTweetSegue", sender: nil)
    }
}

