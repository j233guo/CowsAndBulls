//
//  SettingView.swift
//  CowsAndBulls
//
//  Created by Jiaming Guo on 2023-06-15.
//

import SwiftUI

struct SettingView: View {
	@AppStorage("maximumGuesses") var maximumGuesses = 100
	@AppStorage("answerLength") var answerLength = 4
	@AppStorage("enableHardMode") var enableHardMode = false
	@AppStorage("showGuessCount") var showGuessCount = false
	
    var body: some View {
		TabView {
			Form {
				TextField("Maximum Guesses", value: $maximumGuesses, format: .number)
					.help("The maximum number of answers you can submit. Changing this will immediately restart your game.")
				TextField("Answer Length", value: $answerLength, format: .number)
					.help("The length of the number string to guess. Changing this will immediately restart your game.")
				
				if answerLength < 3 || answerLength > 8 {
					Text("Answer length must be between 3 and 8.")
						.foregroundColor(.red)
				}
			}
			.padding()
			.navigationTitle("Game Settings")
			.tabItem {
				Label("Game", systemImage: "number.circle")
			}
			
			Form {
				Toggle("Enable Hard Mode", isOn: $enableHardMode)
					.help("This shows the cows and bulls score for only the most recent guess.")
				Toggle("Show Guess Count", isOn: $showGuessCount)
					.help("Adds a footer below your guesses showing the total.")
			}
			.padding()
			.tabItem {
				Label("Advanced", systemImage: "gearshape.2")
			}
		}
		.frame(width: 400)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
