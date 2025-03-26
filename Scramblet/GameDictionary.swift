//
//  GameDictionary.swift
//  Scramblet
//
//  Created by Eric on 26/03/2025.
//

import Foundation

struct GameDictionary {
    private var words = Set<String>()

    init() {
        guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else {
            fatalError("Failed to locate dictionary.")
        }

        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Failed to load dictionary.")
        }

        let allWords = string.components(separatedBy: "\n")

        words = Set(allWords.filter { $0.count <= 6 })
    }
}
