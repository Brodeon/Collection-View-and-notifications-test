//
//  ViewController.swift
//  Collection View test
//
//  Created by Przemek on 2/1/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UNUserNotificationCenterDelegate {
    
    let imagesArray: [String] = ["google", "rabbit", "net", "team", "apple", "twitter"]
    let center = UNUserNotificationCenter.current()
    var isPermGranted = false
    var isAlertGranted = false
    var isSoundGranted = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var clickLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        center.delegate = self
        
        center.requestAuthorization(options: [.sound, .alert]) {granted, error in
            if error != nil || !granted {
                self.isPermGranted = false
            } else {
                self.isPermGranted = true
            }
        }
        
        checkNotificationPerrmision()
        defineNotificationCustomActions()
    }

    @IBAction func showNotificationClicked(_ sender: UIButton) {
        clickLabel.text = "Not Clicked"
        if isPermGranted {
            let content = UNMutableNotificationContent()
            content.userInfo = ["type" : 1]
            
            if isAlertGranted {
                content.title = "Hello notification"
                content.body = "This is my first internal notification"
            }
            
            if isSoundGranted {
                content.sound = UNNotificationSound.default
            }
            let uuid = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false))
        
            center.add(request) { (error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
        }
    }
    
    @IBAction func showActionNotification(_ sender: UIButton) {
        clickLabel.text = "Not Clicked"
        if isPermGranted {
            let content = UNMutableNotificationContent()
            content.userInfo = ["type" : 2]
            
            if isAlertGranted {
                content.title = "Join to us!"
                content.body = "Join to our amazing game. Do you want to join?"
                content.categoryIdentifier = "JOIN_INVITATION"
            }
            
            if isSoundGranted {
                content.sound = UNNotificationSound.default
            }
            
            let uuid = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false))
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionCell
        cell.setImage(ofName: imagesArray[indexPath.row])
        return cell
    }
    
    func checkNotificationPerrmision() {
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                return
            }
            
            if settings.alertSetting == .enabled {
                self.isAlertGranted = true
            }
            
            if settings.soundSetting == .enabled {
                self.isSoundGranted = true
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let type = response.notification.request.content.userInfo["type"] as! Int
        clickLabel.text = "notification of type \(type) clicked"
        
        if type == 2 {
            switch response.actionIdentifier {
            case "ACTION_YES":
                print("yes clicked")
                
            case "ACTION_NO":
                print("no clicked")
            default:
                break
            }
        }
    }
    
    func defineNotificationCustomActions() {
        let yesAction = UNNotificationAction(identifier: "ACTION_YES", title: "Yes", options: UNNotificationActionOptions.init(rawValue: 0))
        let noAction = UNNotificationAction(identifier: "ACTION_NO", title: "No", options: UNNotificationActionOptions.init(rawValue: 0))
        
        let joinCategory = UNNotificationCategory(identifier: "JOIN_INVITATION", actions: [yesAction, noAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        center.setNotificationCategories([joinCategory])
    }

    
}

