//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Soft Dev Student on 5/8/19.
//  Copyright © 2019 Alice Zhong. All rights reserved.
//

import Foundation

class Emoji {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
}
