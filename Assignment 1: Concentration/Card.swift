/// An individual playing card with at most one card equal to itself
class Card: Hashable, CustomStringConvertible {
    private let identifier: Int
    
    /// whether or not the Card is face up
    var isFaceUp: Bool
    
    /// whether or not the Card is Matched
    var isMatched: Bool
    
    /// whether or not the Card has been viewed
    var hasBeenViewed: Bool
    
    /// the last identifer to be used in the creation of a Card
    private static var lastUsedIdentifier = 0
    
    /// whether or not the last created card has an equal match
    private static var needsMatchingCard = false
    
    /// The String description of the Card using only non-private attributes
    public var description: String { return "identifier: \(identifier), isFaceUp: \(isFaceUp), isMatched: \(isMatched), hasBeenViewed: \(hasBeenViewed)"
    }
    
    ///Sets the variables and constants responsible for comparing equality of Card instances
    func hash(into hasher: inout Hasher) { hasher.combine(identifier) }
    
    /**
     Initializes a new Card
     - Returns: A new Card instance
     */
    init() {
        isFaceUp = false
        isMatched = false
        hasBeenViewed = false
        identifier = Card.getIdentifier()
    }
    
    /**
     Calculates the appropriate identifier for the Card
     - Returns: the next identifier to be used
     */
    private static func getIdentifier() -> Int {
        if !needsMatchingCard {
            lastUsedIdentifier += 1
            needsMatchingCard = true
        } else { needsMatchingCard = false }
        return lastUsedIdentifier
    }
    
    /**
     Determines the equality of the two cards
     - Parameters:
     - lhs: the first of the two Cards to be compared
     - rhs: the second of the two Cards to be compared
     - Returns: whether or not the two Cards are equal
     */
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
