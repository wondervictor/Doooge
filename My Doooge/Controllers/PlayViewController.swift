//
//  PlayViewController.swift
//  Doooge
//
//  Created by VicChan on 2016/12/4.
//  Copyright © 2016年 VicChan. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    // showPlay
    
    var delegate: PresentViewControllerDelegate?

    @IBOutlet weak var backButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        AnimationEngine.shared.delegate = self

        backButton.isEnabled = false
        super.viewWillAppear(animated)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        delegate?.dismiss()
        self.dismiss(animated: true, completion: nil)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayViewController: AnimationEngineDelegate {
    func didFinishPlaying() {
        backButton.isEnabled = true
    }

}
