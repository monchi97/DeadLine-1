//
//  ViewController.swift
//  Deadline
//
//  Created by x16069xx on 2016/06/24.
//  Copyright © 2016年 Shimon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatPicker: UIPickerView!
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //表示させるやつ
    let dataList = [["しない","毎日","毎週"]]
    //データをUILocalNotificationに渡す配列
    let dataArray = [0.0, 86400.0, 604800.0]
    var selectedRow = 0
    
    var date: String!
    //var saveDate = NSUserDefaults.standardUserDefaults()
    var pickerData: String = ""
    
    var wordArray: [AnyObject] = []
    let saveData = NSUserDefaults.standardUserDefaults()
    
    var availableNotificationIdArray: [Bool] = [true, true, true, true, true, true, true, true, true, true]
    var notificationId: Int = 0

    
    @IBAction func changeDate(sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        date = formatter.stringFromDate(sender.date)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        repeatPicker.dataSource = self
        repeatPicker.delegate = self
        
        textField.placeholder = "課題名を入力してください"
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if saveData.arrayForKey("List") != nil {
            wordArray = saveData.arrayForKey("List")!
        }
    }
    
    @IBAction func saveButton(){
        
        if textField.text == "" {
            let alertController = UIAlertController(title: "課題名が入力されていません", message: nil, preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        let DateFormatter: NSDateFormatter = NSDateFormatter()
        DateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        let selectedDate: String = DateFormatter.stringFromDate(datePicker.date)
        let name = textField.text

        let start = formatter.stringFromDate(now)
        let end = selectedDate
        let startDate:NSDate? = formatter.dateFromString(start)
        let endDate:NSDate? = formatter.dateFromString(end)
        let span = endDate!.timeIntervalSinceDate(startDate!)
        let alert = UIAlertController(
            title: "保存完了",
            message: "登録が完了しました",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler:nil
            )
        )
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        for i in 0..<availableNotificationIdArray.count {
            if availableNotificationIdArray[i] {
                notificationId = i
                availableNotificationIdArray[i] = false
                break
            }
        }
        saveData.setObject(availableNotificationIdArray, forKey: "NOTIFICATION")
        
        let listDictionary = ["date": selectedDate, "repeat": pickerData, "name": name!, "uniqueNotificationId": notificationId]
        wordArray.append(listDictionary)
        saveData.setObject(wordArray, forKey: "List")
        saveData.synchronize()
        
        if selectedRow == 0 {
            //通知部分
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: span)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            // 登録する前に、userInfoにキーを設定しておく
            notification.userInfo = ["notificationId": notificationId];
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        if selectedRow == 1 {
            //通知部分
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: span)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.repeatInterval = .Day
            // 登録する前に、userInfoにキーを設定しておく
            notification.userInfo = ["notificationId": notificationId];
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        if selectedRow == 2 {
            //通知部分
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: span)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.repeatInterval = .Weekday
            // 登録する前に、userInfoにキーを設定しておく
            notification.userInfo = ["notificationId": notificationId];
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        textField.text = ""

        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return dataList.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return dataList[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return dataList[component][row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerData = dataList[component][row]
        selectedRow = row
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
}
