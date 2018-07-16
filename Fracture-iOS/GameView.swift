//
//  GameView.swift
//  Fracture-iOS
//
//  Created by Kacper Martela on 16/07/2018.
//  Copyright © 2018 Kacper Martela. All rights reserved.
//

import Foundation
import UIKit

class GameView: UIViewController {
    
    
    @IBOutlet var GameButton: UIButton!
    
    var names: [String] = []
    
    override func viewDidLoad() {
        print(names)
    }
}
