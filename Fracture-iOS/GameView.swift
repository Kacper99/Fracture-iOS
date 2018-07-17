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
    
    @IBOutlet var GameButton: UIButton!
    
    var names: [String] = []
    var challeges: [AnyObject] = []
    
    override func viewDidLoad() {
        
        var cStrings:[String] = []
        
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
            
            if line.range(of: "!VIRUS!") != nil {
                line = line.replacingOccurrences(of: "!VIRUS!", with: "")
                i += 1
                let endText = cStrings[i]
                
                challeges.append(Virus(challenge: line, endText: endText))
                
            } else {
                challeges.append(Challenge(challenge: line))
                
            }

            i += 1
        }
        
        print(challeges.count)
        var cCount:Int = 0, vCount: Int = 0
        for element in challeges {
            
            if let v = element as? Virus {
                print(v.challenge, " ", v.endText)
                vCount += 1
            } else if let c = element as? Challenge {
                print(c.challenge)
                cCount += 1
            }
        }
        print(cCount, " ", vCount)
    }
}
