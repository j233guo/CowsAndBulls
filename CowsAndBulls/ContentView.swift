//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Jiaming Guo on 2023-06-15.
//

import SwiftUI

struct ContentView: View {
	@State private var guess = ""
	@State private var guesses = [String]()
	@State private var answer = ""
	@State private var isGameOver = false
	
	let answerLength = 4
	
	func submitGuess() {
		guard Set(guess).count == answerLength else { return }
		guard guess.count == answerLength else { return }
		let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
		guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
		guesses.insert(guess, at: 0)
		if result(for: guess).contains("\(answerLength)b") {
			isGameOver = true
		}
		guess = ""
	}
	
	func result(for guess: String) -> String {
		var bulls = 0
		var cows = 0
		let guessLetters = Array(guess)
		let answerLetters = Array(answer)
		for (index, letter) in guessLetters.enumerated() {
			if letter == answerLetters[index] {
				bulls += 1
			} else if answerLetters.contains(letter) {
				cows += 1
			}
		}
		return "\(bulls)b \(cows)c"
	}
	
	func startNewGame() {
		guess = ""
		guesses.removeAll()
		let numbers = (0...9).shuffled()
		for i in 0..<answerLength {
			answer.append(String(numbers[i]))
		}
	}
	
    var body: some View {
		VStack(spacing: 0) {
			HStack {
				TextField("Enter a guess..", text: $guess)
					.onSubmit {
						submitGuess()
					}
				Button("Go") {
					submitGuess()
				}
			}
			.padding()
			List(guesses, id: \.self) { guess in
				HStack {
					Text(guess)
					Spacer()
					Text(result(for: guess))
				}
			}
			.listStyle(.sidebar)
		}
		.frame(width: 250)
		.frame(minHeight: 300, maxHeight: .infinity)
		.onAppear(perform: startNewGame)
		.alert("You Win", isPresented: $isGameOver) {
			Button("OK") { startNewGame() }
		} message: {
			Text("Congratulation. Click OK to play again.")
		}
		.navigationTitle("Cows and Bulls")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
