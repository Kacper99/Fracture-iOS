//
//  ViewController.swift
//  Fracture-iOS
//
//  Created by Kacper Martela on 16/07/2018.
//  Copyright © 2018 Kacper Martela. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var nameFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        for textField in nameFields {
            textField.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! GameView
        
        var names: [String] = []
        for nameField in nameFields {
            if nameField.text != "" {
                names.append(nameField.text!)
            }
        }
        
        destViewController.names = names
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

