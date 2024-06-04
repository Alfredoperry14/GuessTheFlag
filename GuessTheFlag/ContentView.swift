//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alfredo Perry on 5/30/24.
//

import SwiftUI

struct Title: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(.blue)
    }
}

extension View{
    func titleStyle() -> some View{
        modifier(Title())
    }
}

struct ContentView: View {
    //All of our flags
    @State private var countries = ["Estonia", "France", "Germany","Ireland", "Italy",
                                    "Poland","Spain","UK","Ukraine","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State var questions = 0
    @State private var reset = false
    

    struct FlagImage: View{
        var flag: String
        
        var body: some View{
            Image(flag)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops:[
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    //.font(.largeTitle.bold())
                    //.foregroundStyle(.white)
                    .titleStyle()
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{ //Flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])

                        }
                    }
                    
                }
                //.padding()
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                Spacer()
            }
            .padding()
        }
            .alert(scoreTitle, isPresented: $showingScore){
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
        
            .alert(scoreTitle, isPresented: $reset){
                Button("Reset", action: resetGame)
            }
        
    }
    
    func flagTapped(_ number: Int){
        if(number == correctAnswer){
            scoreTitle = "Correct"
            score += 1
        }
        else{
            scoreTitle = "Wrong, the correct answer was the \(getCorrectFlag(correctAnswer)) flag"
        }
        questions += 1
        
        if(questions < 8){
            showingScore = true
        }
        //Once 8 Questions are asked reset the game
        else{
            scoreTitle = "You got \(score) out of 8"
            reset = true
        }
    }
    
    //Reset score, the number of questions already asked, and restart with a new question
    func resetGame(){
        score = 0
        questions = 0
        askQuestion()
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func getCorrectFlag(_ flagNumber: Int) -> String{
        switch flagNumber{
        case 0:
            return "top"
        case 1:
            return "middle"
        case 2:
            return "bottom"
        default:
            return "Error"
        }
    }
    
}


#Preview {
    ContentView()
}
