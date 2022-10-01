//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mirshod Makhmudov on 07/01/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var corrrectAnswer = Int.random(in: 0...2)
    
//    кружение флагов
    @State private var isCorrect = false
    @State private var selectedNumber = 0
    
    @State private var isFadeOutOpacity = false
    
    @State private var isWrong = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[corrrectAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation{
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(indexValue: number, countriesArray: countries)
                        }
                        .rotation3DEffect(.degrees(isCorrect && selectedNumber == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(isFadeOutOpacity && selectedNumber != number ? 0.25 : 1)
                        .rotation3DEffect(.degrees(isWrong && selectedNumber == number ? 90 : 0), axis: (x: 0, y: 0, z: 0.5))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        selectedNumber = number
        if number == corrrectAnswer {
            scoreTitle = "Correct"
            score += 1
            isCorrect = true
            isFadeOutOpacity = true
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            isWrong = true
            isFadeOutOpacity = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        corrrectAnswer = Int.random(in: 0...2)
        isCorrect = false
        isFadeOutOpacity = false
        isWrong = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct FlagImage: View {
    var indexValue: Int
    var countriesArray = [String]()
    
    var body: some View {
        Image(self.countriesArray[indexValue])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
            .shadow(radius: 5)
    }
}
