//
//  ViewController.swift
//  FunnyLyrics
//
//  Created by bhumika dwivedi on 6/12/17.
//  Copyright © 2017 bhumika dwivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController 	{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lyricsView: UITextView!
    let bananaFanaTemplate = [
        "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
        "Banana Fana Fo F<SHORT_NAME>",
        "Me My Mo M<SHORT_NAME>",
        "<FULL_NAME>"].joined(separator: "\n")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.nameField.delegate = self
        self.nameField.returnKeyType = UIReturnKeyType.done
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: Any) {
        self.nameField.text = ""
        self.lyricsView.text = ""
    }
    
    
    @IBAction func displayLyrics(_ sender: Any) {
        
        if let text = self.nameField.text{
            self.lyricsView.text = lyricsForName(lyricsTemplate: bananaFanaTemplate, fullName: text)
        }
        else
        {
            
            self.lyricsView.text = ""
        }
        
    }
    /* create a SHORT NAME with description:
     The shortened name should be all lowercase letters (this way it will fit in with the song)
     Any consonants before the first vowel will be removed; if no consonants exist before the first vowel, then no consonants will be removed
     */
    func shorthandName (fullName: String) -> String{
        
        let lowerFullName = fullName.lowercased()
        let vowelCharacterSet = CharacterSet(charactersIn: "aeiou")
        let  firstVowelRange = lowerFullName.rangeOfCharacter(from: vowelCharacterSet)
        
        
        if let p = firstVowelRange{
            
            return lowerFullName.substring(from: p.lowerBound)
            
        }else{
            
            return lowerFullName
            
        }
        
        
    }
    
    
    func lyricsForName(lyricsTemplate: String, fullName: String) -> String {
        
        var lyrics = String()
        let shortName = shorthandName(fullName: fullName)
        lyrics = lyricsTemplate.replacingOccurrences(of: "<FULL_NAME>", with: fullName).replacingOccurrences(of: "<SHORT_NAME>", with: shortName)
        
        return lyrics
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
