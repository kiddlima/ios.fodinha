//
//  TableGameView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 06/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct TableGameView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject private var keyboardHelper = KeyboardResponder()
    
    @ObservedObject var viewModel: TableGameViewModel
    @ObservedObject var chatViewModel: ChatViewModel
    
    @State var gameLoaded = false
    
    @State var activeMenu = [
        false, false, false
    ]
    
    var chatMessages = [Message]()
    
    @State var chatMessageToSend = ""
    
    init(gameId: String) {
        chatViewModel = ChatViewModel(gameId: gameId)
        viewModel = TableGameViewModel(gameId: gameId)
    }
    
    var body: some View {
        ZStack (alignment: .leading) {
            Color.dark6.edgesIgnoringSafeArea(.all).zIndex(1)
            
            if self.gameLoaded {
                HStack {
                    //Side menu
                    VStack {
                        TableMenuItem(icon: "standings", active: self.$activeMenu[0]) {
                            withAnimation {
                                self.activeMenu = [self.activeMenu[0] ? false : true, false, false]
                            }
                        }
                        
                        TableMenuItem(icon: "chat", active: self.$activeMenu[1]) {
                            withAnimation {
                                self.activeMenu = [false, self.activeMenu[1] ? false : true, false]
                            }
                        }
                        
                        TableMenuItem(icon: "cards", active: self.$activeMenu[2]) {
                            withAnimation {
                                self.activeMenu = [false, false, self.activeMenu[2] ? false : true]
                            }
                        }
                    }
                    .padding(.top, 16)
                    .frame(minWidth: 0, maxWidth: 76, minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .background(Color.dark8)
                    
                    //Table
                    ZStack{
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                .fill(Color.tableDefaultGreen)
                                .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6, alignment: .center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 150, style: .circular)
                                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 10)
                                        .shadow(color: Color.black, radius: 25, x: 0, y: 0)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                        ))
                                .offset(x: self.activeMenu[0] || self.activeMenu[1] || self.activeMenu[2] ? geometry.size.width / 4 : geometry.size.width / 5, y: 20.0)
                        }
                    }
                }
                .zIndex(1)
                
                //Side menu shape view
                if self.activeMenu[0] || self.activeMenu[1] || self.activeMenu[2] {
                    ZStack (alignment: .topLeading) {
                        LinearGradient(gradient:
                                        Gradient(colors: [Color.dark8, Color.dark8.opacity(0)]), startPoint: .leading, endPoint: .trailing)
                            .edgesIgnoringSafeArea(.all)
                        
                        //Chat View
                        if self.activeMenu[1] {
                            ZStack (alignment: .bottom) {
                                VStack (alignment: .leading) {
                                    
                                    Text("Chat")
                                        .font(Font.custom("Avenir-Medium", size: 28))
                                        .bold()
                                        .padding(.leading, 8)
                                        .padding(.top, 12)
                                        .foregroundColor(Color.white)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        ScrollView {
                                            ScrollViewReader { scrollView in
                                                ForEach(chatViewModel.messages, id: \.self) { message in
                                                    ChatMessageView(message: message).id(message.id)
                                                }
                                                .onChange(of: chatViewModel.messageCounterUpdate, perform: { value in
                                                    if !chatViewModel.messages.isEmpty {
                                                        withAnimation {
                                                            scrollView.scrollTo(chatViewModel.messages.last?.id)
                                                        }
                                                    }
                                                })
                                                .onAppear {
                                                    if !chatViewModel.messages.isEmpty {
                                                        scrollView.scrollTo(chatViewModel.messages.last?.id)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    VStack {
                                        HStack {
                                            ChatTextField(text: self.$chatViewModel.messageToSend, placeHolder: "Escreva uma mensagem", chatViewModel: self.chatViewModel)
                                                .cornerRadius(4)
                                                .foregroundColor(.white)
                                                .font(Font.custom("Avenir-Regular", size: 14))
                                                .padding(8)
                                                .frame(height: 40)
                                            
                                            Button(action: {
                                                chatViewModel.sendMessage()
                                            }, label: {
                                                Image(systemName: "paperplane.fill")
                                                    .foregroundColor(Color.dark3)
                                                    .padding(.trailing, 8)
                                            })
                                        }
                                        .background(Color.dark4)
                                        .cornerRadius(4)
                                    }
                                    .padding(8)
                                    .padding(.bottom, self.keyboardHelper.keyboardHeight != 0 ? self.keyboardHelper.keyboardHeight : 16)
                                    .animation(.default)
                                }
                            }
                        }
                        
                        //Standing View
                        if self.activeMenu[0] {
                            VStack (alignment: .leading) {
                                Text("Placar")
                                    .font(Font.custom("Avenir-Medium", size: 28))
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 16)
                                
                                StandingsView(players: self.$viewModel.players)
                                
                                Spacer()
                            }
                            .padding(.top, 12)
                            .padding(.leading, 8)
                        }
                    }
                    .padding(.trailing, 48)
                    .zIndex(1)
                    .offset(x: 76, y: 0)
                    .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                }
                
                if false {
                    ZStack{
                        // Table
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                .fill(Color.tableDefaultGreen)
                                .shadow(radius: 20)
                                .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 150, style: .circular)
                                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 10)
                                        .shadow(color: Color.black, radius: 25, x: 0, y: 0)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                        ))
                        }
                        
                        // Players
                        GeometryReader { geometry in
                            ZStack{
                                VStack{
                                    HStack {
                                        if self.viewModel.hasPlayerInThatPosition(position: 1){
                                            PlayerItem(player : self.viewModel.getPlayerByPosition(position: 1)!)
                                                .animation(.easeIn)
                                        } else {
                                            PlayerItem(player: Player()).hidden()
                                        }
                                        
                                        if self.viewModel.hasPlayerInThatPosition(position: 0){
                                            PlayerItem(player : self.viewModel.getPlayerByPosition(position: 0)!)
                                        } else {
                                            PlayerItem(player: Player()).hidden()
                                        }
                                        
                                    }.offset(y: geometry.size.height / -4.5)
                                    
                                    HStack {
                                        if self.viewModel.hasPlayerInThatPosition(position: 4){
                                            PlayerItem(player : self.viewModel.getPlayerByPosition(position: 4)!)
                                        } else {
                                            PlayerItem(player: Player()).hidden()
                                        }
                                        
                                        if self.viewModel.hasPlayerInThatPosition(position: 5){
                                            PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!)
                                        } else {
                                            PlayerItem(player: Player()).hidden()
                                        }
                                        
                                    }.offset(y: geometry.size.height / 4.5)
                                }.overlay(
                                    HStack{
                                        VStack (spacing: 20){
                                            if self.viewModel.hasPlayerInThatPosition(position: 2){
                                                PlayerItem(player : self.viewModel.getPlayerByPosition(position: 2)!)
                                            } else {
                                                PlayerItem(player: Player()).hidden()
                                            }
                                            
                                            if self.viewModel.hasPlayerInThatPosition(position: 3){
                                                PlayerItem(player : self.viewModel.getPlayerByPosition(position: 3)!)
                                            } else {
                                                PlayerItem(player: Player()).hidden()
                                            }
                                            
                                        }.offset(x: geometry.size.height / -2.5)
                                        
                                        VStack (spacing: 20){
                                            if self.viewModel.hasPlayerInThatPosition(position: 7){
                                                PlayerItem(player : self.viewModel.getPlayerByPosition(position: 7)!)
                                            } else {
                                                PlayerItem(player: Player()).hidden()
                                            }
                                            
                                            if self.viewModel.hasPlayerInThatPosition(position: 5){
                                                PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!)
                                            } else {
                                                PlayerItem(player: Player()).hidden()
                                            }
                                        }.offset(x: geometry.size.height / 2.5)
                                    })
                            }
                        }
                        
                        // Center Table
                        VStack {
                            if viewModel.smallRoundWinner == nil {
                                Text(viewModel.game!.message!)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                
                                Text(viewModel.game!.hunchTime! ? "Rodade de palpítes" : "Rodada \(viewModel.game!.currentRound!)")
                                    .font(.body)
                                    .foregroundColor(Color.customLighter2Gray)
                                
                            } else {
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 150, style: .circular)
                                        .fill(Color.darkGreen)
                                        .frame(width: geometry.size.width / 3.2, height: geometry.size.height / 3.6)
                                        .overlay(
                                            HStack {
                                                Text("\(self.viewModel.smallRoundWinner!.shortName!) venceu a rodada com")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color.white)
                                                
                                                CardItem(
                                                    card: self.viewModel.smallRoundWinner?.currentCard,
                                                    width: 40,
                                                    height: 67)
                                            }.padding(24)
                                        )
                                }
                            }
                        }
                        
                    }.offset(x: -35, y: -15)
                    
                    VStack (alignment: .trailing) {
                        
                        Spacer().frame(maxHeight: .infinity)
                        
                        // Start game button
                        if viewModel.shouldShowStartGameButton(){
                            HStack {
                                Button(action: {
                                    self.viewModel.startGame(gameId: self.viewModel.game!._id!)
                                }) {
                                    Text("Começar jogo")
                                }.buttonStyle(PrimaryButton())
                                
                                ActivityIndicator(shouldAnimate: self.$viewModel.loadingStartGame)
                            }
                        }
                        
                        // Play card button
                        if viewModel.isPlayersTurnToPlay(){
                            HStack {
                                Button(action: {
                                    self.viewModel.playCard()
                                }) {
                                    Text("Jogar carta")
                                }.buttonStyle(PrimaryButton())
                                
                                ActivityIndicator(shouldAnimate: self.$viewModel.loadingPlay)
                            }
                        }
                        
                        // Hunch view
                        if viewModel.isPlayersTurnToHunch() {
                            HunchView(
                                choices: self.viewModel.choices,
                                players: self.viewModel.game!.players,
                                viewModel: self.viewModel)
                        }
                        
                        Spacer()
                        
                        // Footer with cards and points
                        HStack (alignment: .bottom){
                            //                        ScrollView (.horizontal) {
                            //                            HStack (alignment: .lastTextBaseline) {
                            //                                ForEach (viewModel.game!.players, id: \.playerId) { player in
                            //                                    Text("\(player.name!) (\(player.points!) pontos)")
                            //                                        .font(.caption)
                            //                                        .foregroundColor(Color.customLighter2Gray)
                            //                                }
                            //                            }
                            //                            .frame(maxWidth: .infinity)
                            //                            .frame(height: 30)
                            //                        }
                            //                        .frame(maxWidth: .infinity)
                            //                        .frame(height: 35)
                            //                        .padding(.leading, 16)
                            //                        .padding(.trailing, 16)
                            //                        .background(RoundedRectangle(cornerRadius: 4)
                            //                        .fill(Color.customLighterGray)
                            //                        .shadow(radius: 3))
                            
                            //                        if self.viewModel.currentPlayer != nil {
                            //                            HStack {
                            //                                ForEach(0 ..< (viewModel.currentPlayer?.cards.count)!, id: \.self) { index in
                            //                                    Button(action: {
                            //                                        self.viewModel.selectCard(position: index)
                            //                                    }) {
                            //                                        CardItem(card: self.viewModel.currentPlayer?.cards[index],
                            //                                                 width: 55, height: 91)
                            //                                            .animation(.easeOut)
                            //                                            .offset(y: (self.viewModel.currentPlayer?.cards[index] != nil && self.viewModel.currentPlayer?.cards[index]!.selected == true) ? -10 : 0)
                            //                                    }
                            //                                }
                            //                            }
                            //                        }
                        }.edgesIgnoringSafeArea(.leading)
                        
                    }.frame(maxHeight: .infinity)
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if !self.gameLoaded {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        self.gameLoaded = true
                    }
                }
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
        
    }
    
}

struct TableGameView_Previews: PreviewProvider {
    static var previews: some View {
        TableGameView(gameId: "")
            .previewLayout(.fixed(width: 768, height: 320))
    }
}
