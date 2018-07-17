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
        if availableChallenges.isEmpty {
            if !activeViruses.isEmpty {
                let v: Virus = activeViruses.removeFirst()
                gameButton.setTitle(v.endText, for: .normal)
            } else {
                gameButton.setTitle("Game finished, tap to restart", for: .normal)
                availableChallenges = allChallenges
                activeViruses = []
            }
            return
        }
        
        for i in 0..<activeViruses.count {
            if activeViruses[i].turnsLeft == 0 {
                gameButton.setTitle(activeViruses[i].endText, for: .normal)
                activeViruses.remove(at: i)
                return
            } else {
                activeViruses[i].turnsLeft -= 1
            }
        }
        
        let challengeNum: Int = Int(arc4random_uniform(UInt32(availableChallenges.count)))
        let randomChallenge = availableChallenges.remove(at: challengeNum)
        
        if let v = randomChallenge as? Virus {
            let randomInt = 10 + Int(arc4random_uniform(15))
            print(randomInt)
            v.turnsLeft = randomInt
            activeViruses.append(v)
            
            var challengeText: String = v.challenge
            var availableNames = names
            
            while challengeText.contains("!NAME!") {
                let randomInt = Int(arc4random_uniform(UInt32(availableNames.count)))
                let randomName = availableNames.remove(at: randomInt)
                challengeText = challengeText.replaceFirst(of: "!NAME!", with: randomName)
            }
            gameButton.setTitle(challengeText, for: .normal)
            
        } else if let c = randomChallenge as? Challenge {
            var challengeText: String = c.challenge
            
            var availableNames = names

            while challengeText.contains("!NAME!") {
                let randomInt = Int(arc4random_uniform(UInt32(availableNames.count)))
                let randomName = availableNames.remove(at: randomInt)
                challengeText = challengeText.replaceFirst(of: "!NAME!", with: randomName)
            }
            
            gameButton.setTitle(challengeText, for: .normal)
        }
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

extension String {
    
    public func replaceFirst(of pattern:String, with replacement:String) -> String {
        if let range = self.range(of: pattern) {
            return self.replacingCharacters(in: range, with: replacement)
        } else {
            return self
        }
    }
    
    public func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        }catch{
            NSLog("replaceAll error: \(error)")
            return self
        }
    }
    
}
