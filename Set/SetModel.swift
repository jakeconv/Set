//
//  SetModel.swift
//  Set
//
//  Created by Jake Convery on 6/17/20.
//  Copyright © 2020 Jake Convery. All rights reserved.
//

import Foundation

class SetModel {
    
    private(set) var cards = [Card] ()
    private(set) var cardsOnScreen = [Card] ()
    private var selectedCards = [Card] ()
    private var failedMatchCards: [Card]?
    private var successfulMatchCards: [Card]?
    var cardsRemaining = 81
    
    init() {
        newGame()
    }
    
    func newGame() {
        generateCards()
        cardsOnScreen = []
        selectedCards = []
        failedMatchCards = nil
        successfulMatchCards = nil
        cardsRemaining = 81
        print("\(cards.count) cards generated.")
        // Pull the 12 srtarting cards
        for _ in 1...12 {
            cardsOnScreen.append(pullCard()!)
        }
    }
    
    private func generateCards() {
        for color in Card.Color.all {
            for shape in Card.Shape.all {
                for pattern in Card.Pattern.all {
                    for number in Card.Number.all {
                        cards.append(Card(color: color, shape: shape, pattern: pattern, number: number))
                    }
                }
            }
        }
    }
    
    private func update() {
        // Check if previous call was a failed set
        if let failedCards = failedMatchCards {
            //clearState(on: cardsOnScreen.indices.filter({cardsOnScreen[$0] == failedCards[$0]}))
            setState(state: .unselected, on: failedCards)
            failedMatchCards = nil
        }
        // Check if the previous call was a successful set
        if let successfulCards = successfulMatchCards {
            // Remove the matched cards from the deck
            for card in successfulCards{
                if let index = cardsOnScreen.firstIndex(of: card){
                    cardsOnScreen.remove(at: index)
                    if (cardsOnScreen.count < 12) {
                        if let newCard = pullCard() {
                            cardsOnScreen.insert(newCard, at: index)
                        }
                    }
                }
            }
            successfulMatchCards = nil
        }
        
        if selectedCards.count == 3 {
            if checkForSet() {
                // Successful match.  Update the state on the matched cards.
                successfulMatchCards = selectedCards
                setState(state: .matched, on: selectedCards)
                selectedCards = []
            }
            else {
                // Failed match.  Update the state on the selected cards.
                failedMatchCards = selectedCards
                setState(state: .selectedAndFailedMatch, on: selectedCards)
                selectedCards = []
            }
        }
    }
    
    private func checkForSet() -> Bool {
        // 4 rules:
        // All cards must have the same number or 3 different numbers
        // All cards must have the same or 3 different shapes
        // All cards must have the same or 3 different colors
        // All cards must have the same or 3 different patterns
        
        // Pull the selected cards
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        // Check for the number condition
        if (card1.number == card2.number){
            if (card1.number != card3.number){
                // Two unique numbers, not three.  Not a set.
                return false
            }
        }
        else {
            // Card 1 and Card 2 not equal
            if (card1.number == card3.number || card2.number == card3.number){
                // Two unique numbers, not three.  Not a set.
                return false
            }
        }
        
        // Check for the shape condition
        if (card1.shape == card2.shape){
            if (card1.shape != card3.shape){
                // Two unique colors, not three.  Not a set.
                return false
            }
        }
        else {
            // Card 1 and Card 2 not equal
            if (card1.shape == card3.shape || card2.shape == card3.shape){
                // Two unique shapes, not three.  Not a set.
                return false
            }
        }
        
        // Check for the color condition
        if (card1.color == card2.color){
            if (card1.color != card3.color){
                // Two unique colors, not three.  Not a set.
                return false
            }
        }
        else {
            // Card 1 and Card 2 not equal
            if (card1.color == card3.color || card2.color == card3.color){
                // Two unique colors, not three.  Not a set.
                return false
            }
        }
        
        // Check for the pattern condition
        if (card1.pattern == card2.pattern){
            if (card1.pattern != card3.pattern){
                // Two unique patterns, not three.  Not a set.
                return false
            }
        }
        else {
            // Card 1 and Card 2 not equal
            if (card1.pattern == card3.pattern || card2.pattern == card3.pattern){
                // Two unique patterns, not three.  Not a set.
                return false
            }
        }
        // Passed all conditions.  The selected cards are a set.
        return true
    }
    
    func pullThreeCards() {
        for _ in 1...3 {
            if let newCard = pullCard() {
                cardsOnScreen.append(newCard)
                }
            }
        }
    
    /*private func checkCondition(cards: [Card], condition: Card.E) -> Bool {
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        // Check for the pattern condition
        if (card1.condition == card2.condition){
            if (card1.condition != card3.condition){
                // Two unique patterns, not three.  Not a set.
                return false
            }
        }
        else {
            // Card 1 and Card 2 not equal
            if (card1.condition == card3.condition || card2.condition == card3.condition){
                // Two unique patterns, not three.  Not a set.
                return false
            }
        }
        // Passed all conditions.  The selected cards are a set.
        return true
    }*/
    
    private func pullCard() -> Card? {
        if (cardsOnScreen.count == 24) {
            // Too many cards on screen.  Do not continue
            print("You're getting greedy")
            return nil
        }
        else if (cards.count == 0) {
            // No cards left to reveal
            print("No cards left!")
            return nil
        }
        else {
            // Reveal a card
            cardsRemaining -= 1
            return cards.remove(at: cards.count.arc4random)
        }
    }
    
    func selectCard (at index: Int) {
        if cardsOnScreen.indices.contains(index) {
            // Make sure the card selected is currently visible
            if cardsOnScreen[index].state == .selectedButNotMatched {
                // Card has been deselected
                cardsOnScreen[index].state = .unselected
                if let index = selectedCards.firstIndex(of: cardsOnScreen[index]) {
                    selectedCards.remove(at: index)
                }
                print("Deselected")
            }
            else if cardsOnScreen[index].state == .selectedAndFailedMatch {
                cardsOnScreen[index].state = .selectedButNotMatched
                selectedCards.append(cardsOnScreen[index])
                // Remove the card from the failed match index
                if let index = failedMatchCards!.firstIndex(of: cardsOnScreen[index]){
                    failedMatchCards!.remove(at: index)
                }
                
            }
            else if cardsOnScreen[index].state == .unselected {
                // Card has been selected
                cardsOnScreen[index].state = .selectedButNotMatched
                selectedCards.append(cardsOnScreen[index])
                print("Selected")
            }
        }
        else {
            print("No such card exists")
        }
        update()
    }
    
    private func setState(state: Card.State, on cards: [Card]) {
        for card in cards {
            if let index = cardsOnScreen.firstIndex(of: card) {
                cardsOnScreen[index].state = state
            }
        }
    }
}

// Use an extension of Int to generate a random integer
extension Int {
    var arc4random: Int {
        // Self is the int that sent us here, in this case
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self == 0 {
            return 0
        }
        else {
            return -Int(arc4random_uniform(UInt32(self)))
        }
    }
}
