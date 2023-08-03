import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      
      
      // 1
             let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
             
             // 2
             let deviceChannel = FlutterMethodChannel(name: "com.gama.applePay/native", binaryMessenger: controller.binaryMessenger)
             
             // 3
             prepareMethodHandler(deviceChannel: deviceChannel)

      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    override   func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "TIMER_EXPIRED" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "SNOOZE_ACTION" {
                // Invalidate the old timer and create a new one. . .
            }
            else if response.actionIdentifier == "STOP_ACTION" {
                // Invalidate the timer. . .
            }
        }
        
        // Else handle actions for other notification types. . .
    }

    
    override  func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
//    override  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//
//                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//            // Here return .newData after you checked if you have any new data, or .noData in case of nothing to update.
//           // A request to the server can be made to check if new data are available for the app
//
//            completionHandler(UIBackgroundFetchResult.newData)
//
//        }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        
        // 4
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            // 5
            if call.method == "getNativeCode" {
                
           // 6
        self.receiveDeviceModel(result: result)
            }
            
            if call.method == "getNativeAlarmCode" {
                
           // 6
        self.receiveAlarm(result: result)
            }
            
            
            
            if call.method == "getNativeArgsCode" {
                guard let args = call.arguments as? [String : Int] else {return}
                let localNum = args["number"]!
                
           // 6
                
                
                self.receiveArgs(result: result, number: localNum)
//                self.receiveAlarm(result: result , number: localNum)
            }
            
            
            else {
                // 9
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
    }
    
    private func receiveDeviceModel(result: FlutterResult) {
        // 7
//        let deviceModel = UIDevice.current.model
        
        var localError = false

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
                localError = false
//                result("All set!")
            } else if let error = error {
                print(error.localizedDescription)
                localError = true
//                result("not set!")
            }
        }
        
        if localError {
            result("error")


        }else {
            result("All set!")

            }
        
        // 8
        // result(deviceModel)
    }
    
    
    private func receiveAlarm(result: FlutterResult) {
        var localError = false
        
        
        let content = UNMutableNotificationContent()
        content.title = "notification"
        content.subtitle = "It looks good"
//        content.sound = UNNotificationSound.
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "elharam_azan_ali_ahmed_molla_ios.aiff"))
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request){ (error) in
            if error != nil {
               // Handle any errors.
                localError = true
//                     result("error")
            }
         }
        
//        // 7
//        var localError = false
//              let content = UNMutableNotificationContent()
//              content.title = "Weekly Staff Meeting"
//              content.body = "Every Tuesday at 2pm"
//              // Configure the recurring date.
//
//              var dateComponents = DateComponents()
//              dateComponents.calendar = Calendar.current
//
//              dateComponents.hour = 17    // 14:00 hours
//              dateComponents.minute = 00
//
//              // Create the trigger as a repeating event.
//              let trigger = UNCalendarNotificationTrigger(
//                       dateMatching: dateComponents, repeats: true)
//
//              // Create the request
//              let uuidString = UUID().uuidString
//              let request = UNNotificationRequest(identifier: uuidString,
//                          content: content, trigger: trigger)
//
//              // Schedule the request with the system.
//              let notificationCenter = UNUserNotificationCenter.current()
//              notificationCenter.add(request) { (error) in
//                 if error != nil {
//                    // Handle any errors.
//                     localError = true
////                     result("error")
//                 }
//              }
//        // 8
        if localError {
            result("error")


        }else {
            result("notification schadualed ")

            }
    }
    
    
    
    private func receiveArgs(result: FlutterResult , number: Int) {
        // 7
        var local = number * 2 ;
        
        // 8
        result(local)
    }
    
}


