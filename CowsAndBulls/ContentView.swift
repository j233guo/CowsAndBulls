//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Jiaming Guo on 2023-06-15.
//

import SwiftUI

struct ContentView: View {
	@AppStorage("maximumGuesses") var maximumGuesses = 100
	@AppStorage("showGuessCount") var showGuessCount = false
	@AppStorage("answerLength") var answerLength = 4
	@AppStorage("enableHardMode") var enableHardMode = false
	
	@State private var guess = ""
	@State private var guesses = [String]()
	@State private var answer = ""
	@State private var isGameOver = false
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	
	func submitGuess() {
		guard Set(guess).count == answerLength else { return }
		guard guess.count == answerLength else { return }
		guard !guesses.contains(guess) else { return }
		let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
		guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
		guesses.insert(guess, at: 0)
		if guesses.count >= maximumGuesses {
			onGameLose()
		}
		if result(for: guess).contains("\(answerLength)b") {
			onGameWin()
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
	
	func onGameLose() {
		alertTitle = "You Lose"
		alertMessage = "You have used up your chances of guessing. The correct number was \(answer). \n Click OK to start a new game."
		isGameOver = true
	}
	
	func onGameWin() {
		alertTitle = "You Win"
		if guesses.count < 10 {
			alertMessage = "You made it with under 10 attempts. Great!"
		} else if guesses.count >= 10 && guess.count < 20 {
			alertMessage = "You made it with under 20 attempts. Good."
		} else {
			alertMessage = "You did ok."
		}
		isGameOver = true
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
			List(0..<guesses.count, id: \.self) { index in
				let guess = guesses[index]
				let shouldShowResult = (enableHardMode == false) || (enableHardMode && index == 0)
				
				HStack {
					Text("Guess \(index + 1)")
					Spacer()
					Text(guess)
					Spacer()
					if shouldShowResult {
						Text(result(for: guess))
					}
				}
			}
			.listStyle(.sidebar)
			
			if showGuessCount {
				Text("Guesses: \(guesses.count)/\(maximumGuesses)")
					.padding()
			}
		}
		.frame(width: 250)
		.frame(minHeight: 300, maxHeight: .infinity)
		.onAppear(perform: startNewGame)
		.onChange(of: answerLength) { _ in
			startNewGame()
		}
		.alert(alertTitle, isPresented: $isGameOver) {
			Button("OK") { startNewGame() }
		} message: {
			Text(alertMessage)
		}
		.navigationTitle("Cows and Bulls")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
