//
//  ConcentrationThemeChooserViewController.swift
//  Assignment 1: Concentration
//
//  Created by Spencer DeBuf on 6/28/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    
    private let gameThemeChoices = ["Animals": (["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐨", "🦁", "🐸", "🐒", "🦆"], #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)),
                                    "Tech": (["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "💾", "💿", "📷"], #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                                    "Food": (["🥨", "🍞", "🧀", "🥓", "🥩", "🍕", "🍔", "🌭", "🍟", "🌮"], #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = gameThemeChoices[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.emojiChoicesMaster = theme.0
                    cvc.cardColor = theme.1
                    cvc.backgroundColor = theme.2
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
