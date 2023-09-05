import UIKit
import Flutter
import UserNotifications
import AVFoundation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate  {
    
    var audioPlayer: AVAudioPlayer?
    
    
    
//    var timer = Timer() //make a timer variable, but do do anything yet
//       let timeInterval:TimeInterval = 10.0
    

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      
      do {
                 try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
                 try AVAudioSession.sharedInstance().setActive(true)
             } catch {
                 print("Failed to configure audio session: \(error)")
             }
      // 1
             let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
             
             // 2
             let deviceChannel = FlutterMethodChannel(name: "com.gama.applePay/native", binaryMessenger: controller.binaryMessenger)
             
             // 3
             prepareMethodHandler(deviceChannel: deviceChannel)

      
      
//
//      if let notification = launchOptions?[.localNotification] as? UILocalNotification {
//          print("handleLocalNotification.")
//
//                handleLocalNotification(notification)
//            }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    
//
//    func handleLocalNotification(_ notification: UILocalNotification) {
//           // Play the audio here
//        playAudio()
//       }
//
//
//
//    func playAudio() {
//          guard let audioFileURL = Bundle.main.url(forResource: "elharam_azan_ali_ahmed_molla", withExtension: "mp3") else {
//              print("Audio file not found.")
//              return
//          }
//
//          do {
//              // Create the audio player and set the 2-minute duration
//              audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
//              audioPlayer?.numberOfLoops = -1 // Play the audio indefinitely
//              audioPlayer?.prepareToPlay()
//              audioPlayer?.play()
//          } catch {
//              print("Error initializing audio player: \(error)")
//          }
//      }
    
    override   func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "TIMER_EXPIRED" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "SNOOZE_ACTION" {
                // Invalidate the old timer and create a new one. . .
                
                
                print("timer is snooze")
            }
            else if response.actionIdentifier == "STOP_ACTION" {
                // Invalidate the timer. . .
                print("timer is stop")
            }
        }else {
            print("timer is set")
        }
        
        // Else handle actions for other notification types. . .
    }

    
    override  func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        print(" userNotificationCenter timer is play sound")

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

    }
    
    
    private func receiveAlarm(result: FlutterResult) {
        var localError = false
        
        
        
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: false) { timer in
            print("Timer fired!")
        }
        
        
//        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval,
//                   target: self,
//                   selector: "timerDidEnd:",
//                   userInfo: "Pizza Done!!",
//                   repeats: false)
//
//
//
//        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

        
//
//        let content = UNMutableNotificationContent()
//        content.title = "notification"
//        content.subtitle = "It looks good"
//        content.sound = UNNotificationSound.default
//
////        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "elharam_azan_ali_ahmed_molla_ios.aiff"))
//
//        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        // choose a random identifier
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        // add our notification request
//        UNUserNotificationCenter.current().add(request){ (error) in
////            if error != nil {
////               // Handle any errors.
////                localError = true
//////                     result("error")
////            }
//
//
//            if let error = error {
//                       print("Error scheduling Azan notification: \(error.localizedDescription)")
//                localError = true
//                   } else {
//                       print("Azan notification scheduled successfully.")
//                       // Start playing the audio after the notification is scheduled
//
////                       DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) {
////                           self.playAudio()
////                        }
//
//
//                       self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval,
//                                  target: self,
//                                  selector: "timerDidEnd:",
//                                  userInfo: "Pizza Done!!",
//                                  repeats: false)
//
//                   }
//
//         }
        
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

