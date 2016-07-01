//
//  ListTableViewController.swift
//  Deadline
//
//  Created by x16069xx on 2016/06/24.
//  Copyright © 2016年 Shimon. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var wordArray: [AnyObject] = []
    let saveData = NSUserDefaults.standardUserDefaults()
    var availableNotificationIdArray: [Bool] = []
    
    @IBOutlet var viewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName:"ListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if saveData.arrayForKey("List") != nil {
            wordArray = saveData.arrayForKey("List")!
        }
        if saveData.arrayForKey("NOTIFICATION") != nil {
            availableNotificationIdArray = saveData.arrayForKey("NOTIFICATION") as! [Bool]
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source
    
    //セクションの数を設定します。
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //セルの個数を指定します。
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }
    
    //セルの中身の表示の仕方を設定します。
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        
        let wordDictionary = wordArray[indexPath.row]
        
        cell.dateLabel.text = wordDictionary["date"] as? String
        cell.nameLabel.text = wordDictionary["name"] as? String
        
        return cell
    }
    
    //ボタン押下時に呼ばれるメソッド
    @IBAction func changeMode(sender: AnyObject) {
        //通常モードと編集モードを切り替える。
        if(tableView.editing == true) {
            tableView.editing = false
        } else {
            tableView.editing = true
        }
    }
    
    //テーブルビュー編集時に呼ばれるメソッド
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //削除の場合、配列からデータを削除する。
        if( editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // Cancell local notification.
            let wordDictionary = wordArray[indexPath.row]
            let uidtodelete = wordDictionary["uniqueNotificationId"] as? Int
            let app:UIApplication = UIApplication.sharedApplication()
            for i in app.scheduledLocalNotifications! {
                let notification = i as UILocalNotification
                let userInfoCurrent = notification.userInfo! as? [String:AnyObject]
                let uid = userInfoCurrent!["notificationId"]! as? Int
                if uid == uidtodelete {
                    //Cancelling local notification
                    app.cancelLocalNotification(notification)
                    availableNotificationIdArray[uid!] = true
                    break
                }
            }
            saveData.setObject(availableNotificationIdArray, forKey: "NOTIFICATION")
            wordArray.removeAtIndex(indexPath.row)
            saveData.removeObjectForKey("List")
            saveData.setObject(wordArray, forKey: "List")

        }
        
        
        
        //テーブルの再読み込み
        tableView.reloadData()
    }

}
