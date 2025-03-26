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
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 150), spacing: 0), count: 3)
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: columns) {
                ForEach(spellableWords, id: \.self) { word in
                    Text(
                        foundWords.contains(word)
                        ? word.uppercased()
                        : String(repeating: "●", count: word.count)
                    )
                    .font(.title3)
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
            
            Button("Submit", action: submit)
                .disabled(currentWord.count < 3)
        }
        .padding()
        .onAppear(perform: load)
    }
    
    func load() {
        targetWord = ["advert", "bestow", "brains", "carbon", "finale", "island", "nudges", "palate", "ransom", "sedate", "signed", "tailor", "tingle", "usable"].randomElement()!
        
        spellableWords = dictionary.spellableWords(from: targetWord)
        
        letters = targetWord.shuffled().map {
            Letter(text: String($0))
        }
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
        }
        
        currentWord.removeAll()
    }
}

#Preview {
    ContentView()
}
