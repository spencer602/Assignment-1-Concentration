//
//  ViewController.swift
//  Assignment 1: Concentration
//
//  Created by Spencer DeBuf on 5/23/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    /// all of the possible themes, including emojis and colors
    private let gameThemeChoices = [(["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐨", "🦁", "🐸", "🐒", "🦆"], #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)),
                                    (["⌚️", "📱", "💻", "⌨️", "🖥", "🖨", "💾", "💿", "📷"], #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
                                    (["🥨", "🍞", "🧀", "🥓", "🥩", "🍕", "🍔", "🌭", "🍟", "🌮"], #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))]
    
    /// the game model
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    /// the emoji choices for a single particular game
    var emojiChoices = [String]()
    /// the emoji choices for a single particular game
    var emojiChoicesMaster = ["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐨", "🦁", "🐸", "🐒", "🦆"] {
        didSet { emojiChoices = emojiChoicesMaster } }
    /// the card color for the single particular game
    var cardColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    /// the background color for the single particular game
    var backgroundColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
    
    /// the emoji dictionary; which card goes to which emoji
    private var emojiDict = [Card: String]()
    /// the timer for updating the time label
    private var timer: Timer?
    
    /// the number of pairs of cards in the game, determined from the number of card buttons in the view
    private var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }

    /// the cardButtons array
    @IBOutlet var cardButtons: [UIButton]!
    
    /// the main view (used for changing background color)
    @IBOutlet var mainView: UIView!
    
    /// the score label
    @IBOutlet weak var scoreLabel: UILabel!
    
    /// the flip count label
    @IBOutlet weak var flipCountLabel: UILabel!
    
    /// the time elapsed label
    @IBOutlet weak var timeLabel: UILabel!
    
    /// the new game button
    @IBOutlet weak var newGameButton: UIButton!
    
    /// target action when new game button is pressed
    @IBAction func newGamePressed(_ sender: UIButton) {
        game.startNewGame(numberOfPairsOfCards: numberOfPairsOfCards)
        restartGame()
    }
    
    /// target action when a card is touched
    @IBAction func touchCard(_ sender: UIButton) {
        if let touchedIndex = cardButtons.firstIndex(of: sender) {
            flipCard(at: touchedIndex)
        }
    }
    
    /// initialize the model after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        restartGame()
    }
    
    /// restarts the game: restarts the model, resets the vars in the controller
    private func restartGame() {
        // remember to invalidate the timer while we still have a reference to it
        if timer != nil { timer?.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        emojiDict.removeAll()
        
        emojiChoices = emojiChoicesMaster
        mainView.backgroundColor = backgroundColor
        scoreLabel.backgroundColor = backgroundColor
        flipCountLabel.backgroundColor = backgroundColor
        timeLabel.backgroundColor = backgroundColor
        newGameButton.backgroundColor = cardColor
        
        scoreLabel.textColor = cardColor
        flipCountLabel.textColor = cardColor
        timeLabel.textColor = cardColor
        newGameButton.setTitleColor(backgroundColor, for: UIControl.State.normal)
        
        updateViewFromModel()
    }
    
    /// target action every time the timer reaches it's increment: updates the time label
    @objc private func updateTimeLabel() {
        var timeLabelText = "Time: 0"
        if game.timeSinceFirstMove != nil {     // round time to one decimal place
            timeLabelText = "Time: \(Double(round(game.timeSinceFirstMove! * 10)) / 10)" }
        timeLabel.text = timeLabelText
    }
    
    /**
     Flips the card at the given index
     - Parameter index: the index of the card to be flipped
     */
    private func flipCard(at index: Int) {
        game.chooseCard(chosenCard: game.cards[index])
        updateViewFromModel()
        if game.gameFinished {
            timer!.invalidate()
        }
    }
    
    /// updates the view using the model
    private func updateViewFromModel() {
        for buttonIndex in cardButtons.indices {
            if game.cards[buttonIndex].isMatched {  // card is matched
                cardButtons[buttonIndex].backgroundColor = backgroundColor
                cardButtons[buttonIndex].setTitle(emoji(for: game.cards[buttonIndex]), for: UIControl.State.normal)
                continue
            }
            if game.cards[buttonIndex].isFaceUp {   // card not matched, but faceup
                cardButtons[buttonIndex].backgroundColor = cardColor
                cardButtons[buttonIndex].setTitle(emoji(for: game.cards[buttonIndex]), for: UIControl.State.normal)
            } else {    // card facedown
                cardButtons[buttonIndex].setTitle("", for: UIControl.State.normal)
                cardButtons[buttonIndex].backgroundColor = cardColor
            }
        }
        
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flip Count: \(game.flipCount)"
    }
    
    /**
     Returns the emoji associated to a particular card
     - Parameter card: the card for which the emoji is needed
     - Returns: the appropriate emoji
     */
    private func emoji(for card: Card) -> String {
        if let emoji = emojiDict[card] { return emoji } // emoji is already in dict
        
        // emoji not in dict, randomly choose an emoji for the card, add it to the dict
        let emoji = emojiChoices.remove(at: emojiChoices.count.arc4random)
        emojiDict[card] = emoji
        return emoji
    }
}

extension Int {
    /// a random int between 0(inclusive) and self(not inclusive)
    var arc4random: Int {
        if self > 0 {   // positive number
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {    // negative number
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {    // 0
            return 0
        }
    }
}
