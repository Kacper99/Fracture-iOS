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
    
}


class GameView: UIViewController {
    
    @IBOutlet var GameButton: UIButton!
    
    var names: [String] = []
    var challeges: [Challenge] = []
    
    override func viewDidLoad() {
        
        var count = 0;
        for element in names {
            print(count, " ", element)
            count += 1
        }
        
        var myStrings:[String] = []
        
        //Load all lines from text file
        if let path = Bundle.main.path(forResource: "challenges", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                myStrings = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
        
        
    }
}
