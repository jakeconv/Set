//
//  Card.swift
//  Set
//
//  Created by Jake Convery on 6/17/20.
//  Copyright © 2020 Jake Convery. All rights reserved.
//

import Foundation

struct Card : Equatable {
    
    var state = State.unselected
    var color: Color
    var shape: Shape
    var pattern: Pattern
    var number: Number
    
    init(color: Color, shape: Shape, pattern: Pattern, number: Number) {
        self.color = color
        self.shape = shape
        self.pattern = pattern
        self.number = number
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return ((lhs.color == rhs.color) && (lhs.shape == rhs.shape) && (lhs.pattern == rhs.pattern) && (lhs.number == rhs.number))
    }
    
    enum Color: Int {
        case green
        case blue
        case red
        static var all: [Color] {
            return [Color.green, Color.blue, Color.red]
        }
    }

    enum Shape: Int {
        case square
        case triangle
        case circle
        static var all: [Shape] {
            return [Shape.square, Shape.triangle, Shape.circle]
        }
    }

    enum Pattern: Int {
        case solid
        case striped
        case hollow
        static var all: [Pattern] {
            return [Pattern.solid, Pattern.striped, Pattern.hollow]
        }
    }

    enum Number: Int {
        case one
        case two
        case three
        static var all: [Number] {
            return [Number.one, Number.two, Number.three]
        }
    }
    
    enum State: Int {
        case unselected
        case selectedButNotMatched
        case selectedAndFailedMatch
        case matched
    }
}
