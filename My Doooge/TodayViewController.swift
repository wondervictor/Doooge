//
//  TodayViewController.swift
//  My Doooge
//
//  Created by VicChan on 2016/10/29.
//  Copyright © 2016年 VicChan. All rights reserved.
//

import UIKit
import NotificationCenter
import AVFoundation





extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
}



enum MovementType: Int {
    case sleep1 = 0
    case sleep2 = 1
    case eat = 2
    case touch = 3
    case static1 = 4
    case static2 = 5
    case move = 6
    case wear = 7
    
}


class Sound {
    static var isOn: Bool = true
    
    static func sleep() {
        if Sound.isOn {
            let urlString = Bundle.main.path(forResource: "sleep", ofType: "wav")
            let url = URL(fileURLWithPath: urlString!)
            
            castVoice(url: url)
        }
    }
    
    static func eat() {
        if Sound.isOn {
            let urlString = Bundle.main.path(forResource: "eat", ofType: "mp3")
            let url = URL(fileURLWithPath: urlString!)
            castVoice(url: url)
        }
        
    }
    
    static func play() {
        if Sound.isOn {
            let urlString = Bundle.main.path(forResource: "play", ofType: "mp3")
            let url = URL(fileURLWithPath: urlString!)
            castVoice(url: url)
        }
        
    }
    
    static func touch() {
        if Sound.isOn {
            let urlString = Bundle.main.path(forResource: "touchdog", ofType: "mp3")
            let url = URL(fileURLWithPath: urlString!)
            
            castVoice(url: url)
        }
    }
    
    private static func castVoice(url: URL) {
        
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
}




/*
class DateManager {
    
    private static let manager = DateManager()
    class func shared() -> DateManager {
        return DateManager.manager
    }
}

*/


enum IncrementType: Int {
    case ontime = 0
    case overdue = 1
    case play = 2
    case undo = 3
    case sleep = 4
}

extension UIView {
    
    

}



class TodayViewController: UIViewController, NCWidgetProviding,UIViewControllerTransitioningDelegate {
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    let animation = AnimationEngine.shared
    
    var animationView: AnimationView!

    @IBOutlet weak var growthLabel: UILabel!
    
    var progressBar: ProgressBar!
    
    var messageView: MessageView!
    
    var tapGesture: UITapGestureRecognizer!
    
    var notifications = [NotificationModel]()
    
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    var tag: Int = 0

    var notificationManager: NotificationManager!
    
    private var lifeValue: Int = 0
    
    override func viewDidLayoutSubviews() {
        let width = UIScreen.main.bounds.width
        
        self.preferredContentSize = CGSize(width: width,height: 200)
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
    }
    
    
    override func viewWillLayoutSubviews() {
        let width = UIScreen.main.bounds.width

        self.preferredContentSize = CGSize(width: width,height: 200)
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tag += 1
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        AnimationEngine.shared.defaultAnimation()
        
        self.view.window?.addSubview(AnimationEngine.shared.animationView)
        self.view.window?.addSubview(progressBar)
        
        
        
    }
    
    
    @IBAction func openSound(_ sender: UIButton) {
        if Sound.isOn {
            sender.setBackgroundImage(UIImage(named:"AssistorOff"), for: .normal)
            Sound.isOn = false
        } else {
            sender.setBackgroundImage(UIImage(named:"AssistorOn"), for: .normal)
            Sound.isOn = true
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tag += 1
        
        //growthLabel.text = "\(lifeValue)"
        let width = UIScreen.main.bounds.width
        
        progressBar = ProgressBar(CGRect(width-120,2,100,13), 100, lv: 1)
        progressBar.levelLabel.text = "Lv35"
        
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        animationView = AnimationView(frame: CGRect(width/2.0-60,40,90,90))
        AnimationEngine.shared.initView(animationView)
        
        messageView = MessageView(frame: CGRect(width/2.0+30,60,97,22.5))
        self.view.window?.makeKeyAndVisible()
        notificationManager = NotificationManager(view: messageView)
        self.view.addSubview(messageView)
        
        self.notifications = [
            
        NotificationModel("吃午饭",1,false),
        NotificationModel("吃晚饭",2,false),
        NotificationModel("吃早饭",3,false),
        NotificationModel("吃夜宵",4,false),
        ]
        notificationManager.delegate = self
        notificationManager.showRandom(content: notifications)
    }
    


    
    @IBAction func play(_ sender: AnyObject) {
        if AnimationEngine.shared.state == .sleeping {
            endSleeping()
        }
        animation.switchAnimation(.play)

    }
    
    @IBAction func eat(_ sender: AnyObject) {
        if AnimationEngine.shared.state == .sleeping {
            endSleeping()
        }
        self.performSegue(withIdentifier: "showFood", sender: nil)
        //animation.switchAnimation(.eat)
        
    }
    
    @IBAction func sleep(_ sender: Any) {
       
        UIView.animate(withDuration: 0.5){
            self.backImageView.image = UIImage(named: "night")
        }
        animation.switchAnimation(.sleep)
    
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

        if activeDisplayMode == NCWidgetDisplayMode.compact {
            let width = UIScreen.main.bounds.width
            animate(expand: false)
            self.preferredContentSize = CGSize(width: width,height: 200)
            print("1")
        } else {
            let width = UIScreen.main.bounds.width
            animate(expand: true)
            self.preferredContentSize = CGSize(width: width,height: 120)
            print("2")

        } 
        
    }
    
    func animate(expand: Bool) {
        if expand == true && tag > 1 {
            verticalConstraint.constant += 15
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
        } else if expand == false && tag > 1 {
            verticalConstraint.constant -= 15
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }

    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Transition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BackTransition()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFood" {
            let controller = segue.destination as! FoodViewController
            controller.delegate = self
            controller.transitioningDelegate = self
        }
        
        if segue.identifier == "showPlay" {
            let controller = segue.destination as! PlayViewController
            controller.delegate = self
            controller.transitioningDelegate = self
        }
    }

 
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

        
        completionHandler(NCUpdateResult.newData)
    }
    

    
    // 打卡
    func punch(_ id: Int,name: String) {
        // 打卡
        let s = UserDefaults.doooge().object(forKey: name) as! Int
        UserDefaults.doooge().set(s+1, forKey: name)
        
    }
    
    func endSleeping() {
        UIView.animate(withDuration: 0.5){
            self.backImageView.image = UIImage(named: "background")
        }
        AnimationEngine.shared.defaultAnimation()
    }
    
}

extension TodayViewController: PresentViewControllerDelegate,AnimationEngineDelegate,NotificationDelegate {
    
    func dismiss() {

        AnimationEngine.shared.delegate = self
    }
    
    func didFinishPlaying() {
        
    }
    

    
    func didChangeNotification(index: Int, id: Int) {
        
    
    
    
    }
    
    func didTouched() {
        if AnimationEngine.shared.state == .sleeping {
            endSleeping()
        }
    }
    

}
