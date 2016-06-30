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
    var saveDate = NSUserDefaults.standardUserDefaults()
    var listArray = [AnyObject]()
    var pickerData: String = ""
    
    var wordArray: [AnyObject] = []
    let saveData = NSUserDefaults.standardUserDefaults()
    
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
        
        let listDictionary = ["date": selectedDate, "repeat": pickerData, "name": name!]
        listArray.append(listDictionary)
        saveData.setObject(listArray, forKey: "List")
        saveData.synchronize()
        
        if selectedRow == 0 {
            UIApplication.sharedApplication().cancelAllLocalNotifications();
            //通知部分
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: span)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        if selectedRow == 1 {
            UIApplication.sharedApplication().cancelAllLocalNotifications();
            //通知部分
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: span)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.repeatInterval = .Day
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        let date: NSDate = datePicker.date
        let cal: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let comp: NSDateComponents = cal.components(
            [NSCalendarUnit.Weekday],
            fromDate: date
        )
        let weekday: Int = comp.weekday
        
        let sep1 = selectedDate.componentsSeparatedByString("/")
        let sep2 = sep1[2].componentsSeparatedByString(" ")
        let sep3 = sep2[1].componentsSeparatedByString(":")
        
        let hour: Int = Int(sep3[0])!
        let min: Int = Int(sep3[1])!
        
        if selectedRow == 2 {
            UIApplication.sharedApplication().cancelAllLocalNotifications();
            cal.locale = NSLocale.currentLocale()
            let comps = NSDateComponents()
            comps.weekday = weekday       // ここは重要。日曜日が1で月曜日が2、あと曜日が進むごとに+1されていく
            comps.hour = hour      // 通知したい時刻（時）
            comps.minute = min  // 通知したい時刻（分）
            let fireDate = cal.dateFromComponents(comps)! // 指定曜日指定時刻のNSDateを得る
            let notification = UILocalNotification()
            notification.fireDate = fireDate    // さっき作った指定曜日が入っているNSDate
            notification.repeatInterval = NSCalendarUnit.WeekOfYear  // NSDateの曜日で毎週通知を示す
            notification.alertBody = "⚠︎提出期限の迫った課題があります。"
            notification.soundName = UILocalNotificationDefaultSoundName
            let app = UIApplication.sharedApplication()
            app.scheduleLocalNotification(notification)
            
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
