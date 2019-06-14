import Foundation

/// A scored and timed game of Concentration
struct Concentration {
    
    /// the score of the game
    private(set) var score = 0
    
    /// the number of individual card flips (reveals)
    private(set) var flipCount = 0
    
    /// the array of Card instances in the game
    private(set) var cards = [Card]()
    
    /// the Date of the first move of the game. Nil if there hasn't been a move yet
    private var timeOfFirstMove: Date?
    
    /// whether or not this game is finished (all cards matching)
    var gameFinished: Bool { return cards.filter { !$0.isMatched }.count == 0}
    
    /// the floating point time in seconds since the first move of the game. Nil if the first move hasn't been made yet
    var timeSinceFirstMove: Double? { return timeOfFirstMove == nil ? nil : -timeOfFirstMove!.timeIntervalSinceNow }
    
    /// the one and only face up card. Nil if there are none or two face up cards
    private var oneAndOnlyFaceUpCard: Card? { return cards.filter { $0.isFaceUp && !$0.isMatched }.oneAndOnly }
    
    /// the times which determine additional bonuses for speedy game completion
    private let timeBonus = [15, 20, 25, 30, 35, 40]
    
    /**
     Initialized a new game of Concentration with the provided number of pairs of cards
     - Parameter numberOfPairsOfCards: the number of pairs of cards in the game
     */
    init(numberOfPairsOfCards: Int) { startNewGame(numberOfPairsOfCards: numberOfPairsOfCards) }
    
    /**
     Start a new game with the provided number of pairs of cards.
     - Parameter numberOfPairsOfCards: the number of pairs of cards in the game
     */
    mutating func startNewGame(numberOfPairsOfCards: Int)
    {
        timeOfFirstMove = nil
        score = 0
        flipCount = 0
        cards.removeAll()
        
        for _ in 0..<numberOfPairsOfCards { cards += [Card(), Card()] }
        
        cards.shuffleElements()
    }
    
    /**
     Chooses the given Card in the game
     - Parameter chosenCard: the card that is to be chosen
     */
    mutating func chooseCard(chosenCard: Card) {
        if chosenCard.isMatched { return }
        
        // the only time a faceup card may be chosen is if there are 2 (faceup and unmatched) cards
        if chosenCard.isFaceUp && cards.filter({$0.isFaceUp && !$0.isMatched}).count != 2 { return }
        
        if flipCount == 0 { timeOfFirstMove = Date() }
        
        // there is one card faceup already
        if let alreadyFaceUpCard = oneAndOnlyFaceUpCard {
            // we have a match
            if alreadyFaceUpCard == chosenCard {
                alreadyFaceUpCard.isMatched = true
                chosenCard.isMatched = true
                score += 2
            } else {    // we dont have a match
                if alreadyFaceUpCard.hasBeenViewed { score -= 1}
                if chosenCard.hasBeenViewed { score -= 1 }
                chosenCard.hasBeenViewed = true
                alreadyFaceUpCard.hasBeenViewed = true
            }
        } else {    // there is 0 or 2 faceup cards
            let faceUpCards = cards.filter{ $0.isFaceUp && !$0.isMatched}
            for card in faceUpCards { card.isFaceUp = false }
        }
        
        chosenCard.isFaceUp = true
        flipCount += 1
        
        if gameFinished {
            for timeInterval in timeBonus { if timeSinceFirstMove! < Double(timeInterval) { score += 1 } }
        }
    }
}

extension Collection {
    /// the one and only one element in a collection, otherwise, nil
    var oneAndOnly: Element? {
        if count == 1 { return first }
        return nil
    }
}

extension Array {
    /// randomly shuffles the elements in an array using arc4random
    mutating func shuffleElements() {
        var shuffled = [Element]()
        while count > 0 { shuffled.append(remove(at: count.arc4random)) }
        self = shuffled
    }
}
