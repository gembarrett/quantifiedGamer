//
//  ViewController.swift
//  graphicstest
//
//  Created by Gemma Barrett on 31/08/2015.
//  Copyright (c) 2015 Gem Barrett. All rights reserved.
//

import UIKit

let steamid = "76561198073968915" as String
let steamkey = "KEY" as String
let gameid = "440" as String


class ViewController: UIViewController {
    
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var gameName: UILabel!
    
    var currentBadge = String()
    var currentPercent = Int()
    var badgeNo = 0 as Int
    var newStuff:[AnyObject] = []
    // we start at 0, so no decreases
    var maximum = Int()
    var nameOfGame = String()
    
    let globalPercentagesRequest = "http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=\(gameid)&format=json" as String
    
    let userStatsRequest = "http://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v0002/?appid=\(gameid)&key=\(steamkey)&steamid=\(steamid)" as String
    
    func grabData(url: String) {
        let urlAsString = url
        let url: NSURL  = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                var stuff: [String:AnyObject] = (jsonResult as? Dictionary)!
                if stuff["achievementpercentages"] != nil {
                    stuff = (stuff["achievementpercentages"] as? Dictionary)!
                    self.newStuff = (stuff["achievements"]! as? Array)!
                    self.currentBadge = self.newStuff[self.badgeNo].valueForKey("name") as! String
                    self.currentPercent = self.newStuff[self.badgeNo].valueForKey("percent") as! Int
                    self.maximum = self.newStuff.count - 1
                    self.updateScreen()
                }
                else if (stuff["playerstats"] != nil) {
                    stuff = (stuff["playerstats"] as? Dictionary)!
                    self.nameOfGame = (stuff["gameName"]! as? String)!
                    if self.nameOfGame == "ValveTestApp1250" {
                        self.nameOfGame = "Killing Floor" as String
                    }
                    println(self.nameOfGame)
                    self.gameName.text = "Global achievement statistics for " + self.nameOfGame as String
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
        })
        jsonQuery.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        counterLabel.text = "0%"
        counterView.counter = 0
        grabData(userStatsRequest)
        grabData(globalPercentagesRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScreen() {
        self.badgeName.text = self.currentBadge
        let toInt: String = String(self.currentPercent)
        self.counterLabel.text = toInt as String + "%"
        self.counterView.counter = self.currentPercent
    }
    
    @IBAction func changeValue(button: ButtonView) {
        // user wants to increase
        if button.isIncreaseButton {
            // are we below the maximum?
            if self.badgeNo < self.maximum {
                // then we can increase
                self.badgeNo++
                self.currentBadge = self.newStuff[self.badgeNo].valueForKey("name") as! String
                self.currentPercent = self.newStuff[self.badgeNo].valueForKey("percent") as! Int
                updateScreen()
            } else {
                let errorMessage = "No more badges" as String
                var errorAlert = UIAlertController(title: "Something went wrong!", message: errorMessage, preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: "Return", style: .Default, handler:nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)

            }
        } else {
            // are we above the minimum?
            if self.badgeNo > 0 {
                // then we can decrease
                self.badgeNo--
                self.currentBadge = self.newStuff[self.badgeNo].valueForKey("name") as! String
                self.currentPercent = self.newStuff[self.badgeNo].valueForKey("percent") as! Int
                
                self.badgeName.text = self.currentBadge
                let toInt: String = String(self.currentPercent)
                self.counterLabel.text = toInt as String + "%"
                self.counterView.counter = self.currentPercent
            } else {
                let errorMessage = "No more badges" as String
                var errorAlert = UIAlertController(title: "Something went wrong!", message: errorMessage, preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: "Return", style: .Default, handler:nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)

            }

        }
        
    }

}

