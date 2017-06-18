//
//  ViewController.swift
//  MidNightTheme
//
//  Created by bhumika dwivedi on 6/16/17.
//  Copyright © 2017 bhumika dwivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lableTheme: UILabel!
    @IBOutlet weak var switchTheme: UISwitch!
    @IBOutlet weak var imageViewTheme: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let weWantMidnight = UserDefaults.standard.bool(forKey: "midnightThemeOn")
        if weWantMidnight {
            switchToMidnight()
        }
        else{
            switchToDaytime()
            switchTheme.setOn(false, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func switchFlipped(_ sender: Any) {
        if switchTheme.isOn {
            switchToMidnight()
            UserDefaults.standard.set(true, forKey: "midnightThemeOn")
        } else {
            switchToDaytime()
            UserDefaults.standard.set(false, forKey: "midnightThemeOn")
        }
    }
    func switchToMidnight() {
       
        self.lableTheme.text = "Midnight theme is on"
        self.imageViewTheme.image = UIImage(named: "midnight" )
        
    }
    
    func switchToDaytime() {
       
        self.lableTheme.text = "Daylight theme is on"
        self.imageViewTheme.image = UIImage(named: "sunrise")
    }
}

