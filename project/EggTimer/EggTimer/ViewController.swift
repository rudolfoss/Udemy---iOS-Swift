//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let eggTimes = ["Soft": 30, "Medium": 40, "Hard": 70]
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer!


    //가변타이머 만들기
    var timer = Timer()

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        let hardness = sender.currentTitle! //Soft, Medium, Hard
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
  
    }



//bring from object C
    @objc func updateCounter() {
        //example functionality
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
          //  print(Float(secondsPassed) / Float(totalTime))
            
        }else{
            timer.invalidate()
            titleLabel.text = "Done!"
            
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension:"mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
}


