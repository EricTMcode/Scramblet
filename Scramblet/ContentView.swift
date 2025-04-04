//
//  ContentView.swift
//  Scramblet
//
//  Created by Eric on 26/03/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var dictionary = GameDictionary()
    @State private var targetWord = ""
    @State private var spellableWords = [String]()
    @State private var foundWords = Set<String>()

    @State private var letters = [Letter]()
    @State private var currentWord = [Letter]()

    @State private var currentProgress = 0.0
    @State private var totalProgress = 1.0

    let columns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 150), spacing: 0), count: 3)

    var body: some View {
        VStack(spacing: 20) {
            ProgressView("Level Progress", value: currentProgress, total: totalProgress)
                .tint(currentProgress / totalProgress > 0.8 ? .green : nil)

            LazyVGrid(columns: columns) {
                ForEach(spellableWords, id: \.self) { word in
                    Text(
                        foundWords.contains(word)
                        ? word.uppercased()
                        : String(repeating: "●", count: word.count)
                    )
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            HStack {
                ForEach(currentWord) { letter in
                    Button {
                        remove(letter)
                    } label: {
                        Text(letter.text.uppercased())
                            .font(.largeTitle)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.white)
                            .background(.blue)
                    }
                    .buttonStyle(.plain)
                }

                if currentWord.isEmpty {
                    Text("A")
                        .frame(width: 44, height: 44)
                        .hidden()
                }
            }

            HStack {
                ForEach(letters) { letter in
                    Button {
                        use(letter)
                    } label: {
                        Text(letter.text.uppercased())
                            .font(.largeTitle)
                            .frame(width: 44, height: 44)
                    }
                    .disabled(currentWord.contains(letter))
                }
            }

            HStack(spacing: 50) {
                Button("Shuffle", action: shuffle)

                Button("Submit", action: submit)
                    .disabled(currentWord.count < 3)

            }

            Button("Next Level", action: load)
                .disabled(currentProgress / totalProgress < 0.1)
        }
        .padding()
        .onAppear(perform: load)
    }

    func load() {
        targetWord = ["advert", "bestow", "brains", "carbon", "finale", "island", "nudges", "palate", "ransom", "sedate", "signed", "tailor", "tingle", "usable"].randomElement()!

        spellableWords = dictionary.spellableWords(from: targetWord)
        spellableWords = rotate(items: spellableWords, columns: 3)

        letters = targetWord.shuffled().map {
            Letter(text: String($0))
        }

        totalProgress = Double(spellableWords.map(\.count).reduce(0, +))
        currentProgress = 0
        foundWords.removeAll()
    }

    func use(_ letter: Letter) {
        withAnimation {
            currentWord.append(letter)
        }
    }

    func remove(_ letter: Letter) {
        withAnimation {
            if let index = currentWord.firstIndex(of: letter) {
                currentWord.remove(at: index)
            }
        }
    }

    func submit() {
        let spelled = currentWord.map(\.text).joined()
        guard foundWords.contains(spelled) == false else { return }

        if spellableWords.contains(spelled) {
            foundWords.insert(spelled)
            currentProgress += Double(spelled.count)
        }

        currentWord.removeAll()
    }

    func rotate(items: [String], columns: Int) -> [String] {
        // Figure out how many rows we'll have.
        let rows = (items.count + columns - 1) / columns
        var result = [String]()

        for row in 0..<rows {
            for col in 0..<columns {
                // Calculate the word that should appear here.
                let index = col * rows + row
                if index < items.count {
                    // Add it to the new array.
                    result.append(items[index])
                }
            }
        }

        return result
    }

    func shuffle() {
        withAnimation {
            letters.shuffle()
        }
    }
}

#Preview {
    ContentView()
}
