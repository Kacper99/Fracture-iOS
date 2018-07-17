//
//  GameView.swift
//  Fracture-iOS
//
//  Created by Kacper Martela on 16/07/2018.
//  Copyright © 2018 Kacper Martela. All rights reserved.
//

import Foundation
import UIKit

class Challenge {
    
    var challenge: String
    
    init(challenge:String) {
        self.challenge = challenge
    }
    
    
}

class Virus: Challenge {
    
    var turnsLeft: Int
    var endText: String
    
    init(challenge: String, endText: String) {
        self.turnsLeft = 10
        self.endText = endText
        super.init(challenge: challenge)
    }
}

class GameView: UIViewController {
    

    @IBOutlet var gameButton: UIButton!
    
    var names: [String] = []
    var allChallenges: [AnyObject] = []
    var availableChallenges: [AnyObject] = []
    var activeViruses: [Virus] = []
    
    @IBAction func gameButtonPress(_ sender: Any) {
        if availableChallenges.count < 1 {
            gameButton.setTitle("Game finished, tap to restart", for: .normal)
            availableChallenges = allChallenges
            activeViruses = []
        }
        
        let challengeNum: Int = Int(arc4random_uniform(UInt32(availableChallenges.count)))
        let randomChallenge = availableChallenges[challengeNum]
        
        if let v = randomChallenge as? Virus {
            gameButton.setTitle(v.challenge, for: .normal)
        } else if let c = randomChallenge as? Challenge {
            gameButton.setTitle(c.challenge, for: .normal)
        }
        availableChallenges.remove(at: challengeNum)
    }
    
    override func viewDidLoad() {
        
        var cStrings:[String] = []
        
        gameButton.titleLabel?.textAlignment = NSTextAlignment.center //Align title to center

        //Load all lines from text file
        if let path = Bundle.main.path(forResource: "challenges", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                cStrings = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
        
        
        var i = 0;
        while i < cStrings.count {
            //print(cStrings[i])
            var line: String = cStrings[i]
            
            if line.range(of: "!VIRUS!") != nil { //Add virus type
                line = line.replacingOccurrences(of: "!VIRUS!", with: "")
                i += 1
                let endText = cStrings[i]
                
                allChallenges.append(Virus(challenge: line, endText: endText))
                
            } else { //Add normal challenge
                allChallenges.append(Challenge(challenge: line))
                
            }

            i += 1
        }
        
        //Used to check if all elements are in the array
        print(allChallenges.count)
        var cCount:Int = 0, vCount: Int = 0
        for element in allChallenges {
            
            if let v = element as? Virus {
                print(v.challenge, " ", v.endText)
                vCount += 1
            } else if let c = element as? Challenge {
                print(c.challenge)
                cCount += 1
            }
        }
        print(cCount, " ", vCount)
        
        availableChallenges = allChallenges
    }
    
    override var prefersStatusBarHidden: Bool { //Hide notification bar
        return true
    }
}
