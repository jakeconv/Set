//
//  ViewController.swift
//  Set
//
//  Created by Jake Convery on 6/17/20.
//  Copyright © 2020 Jake Convery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let game = SetModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var cardsRemainingDisplay: UILabel!
    
    var cardsRemaining = 81 {
        didSet{
            cardsRemainingDisplay.text = "Cards Remaining: \(cardsRemaining)"
        }
    }
    
    @IBAction func flipThree(_ sender: Any) {
        game.pullThreeCards()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
                print(cardNumber)
                game.selectCard(at: cardNumber)
                updateViewFromModel()
            }
            else{
                print("Chosen card not found in viewCards")
            }
    }
    
    @IBAction func newGame(_ sender: Any) {
        game.newGame()
        updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
        // Render any known cards on the screen
        for i in 0..<game.cardsOnScreen.count {
            renderCard(on: cardButtons[i], for: game.cardsOnScreen[i])
        }
        if (game.cardsOnScreen.count < cardButtons.count) {
            // Hide any cards that have not yet been revealed
            for i in game.cardsOnScreen.count..<cardButtons.count {
               makeInvisible(on: cardButtons[i])
            }
        }
        cardsRemaining = game.cardsRemaining
            
    }
    
    func renderCard (on button: UIButton, for card: Card) {
        var text: String
        var color: UIColor
        var attributes: [NSAttributedString.Key : Any] = [:]
        // Determine the shape
        switch card.shape {
        case .circle:
            text = "●"
        case .triangle:
            text = "▲"
        case .square:
            text = "■"
        }
        // Determine the number of shapes and write to card
        switch card.number {
        case .one:
            break
        case .two:
            text = text + text
        case .three:
            text = text + text + text
        }
        // Determine the color
        switch card.color {
        case .blue:
            color = UIColor.blue
        case .green:
            color = UIColor.green
        case .red:
            color = UIColor.red
        }
        // Determine the card pattern
        switch card.pattern {
        case .solid:
            attributes[NSAttributedString.Key.strokeWidth] = -1
            attributes[NSAttributedString.Key.foregroundColor] = color
        case .hollow:
            attributes[NSAttributedString.Key.strokeWidth] = 2
            attributes[NSAttributedString.Key.foregroundColor] = color
        case .striped:
            attributes[NSAttributedString.Key.strokeWidth] = -1
            attributes[NSAttributedString.Key.foregroundColor] = color.withAlphaComponent(0.25)
        }
        
        // Write the attributed string to the button
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
        
        // Indicate if a card is selected
        switch card.state {
        case .unselected:
            button.layer.borderWidth = 0
        case .selectedButNotMatched:
            drawBorder(on: button, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        case .selectedAndFailedMatch:
            drawBorder(on: button, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        case .matched:
            drawBorder(on: button, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        }
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func drawBorder(on button: UIButton, color: CGColor) {
        button.layer.borderWidth = 3
        button.layer.borderColor = color
    }
    
    func makeInvisible (on button: UIButton) {
        let attributedString = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)])
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        drawBorder(on: button, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
}

