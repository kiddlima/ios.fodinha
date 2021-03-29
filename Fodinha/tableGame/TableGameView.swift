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
        UserDefaults.standard.set(gameId, forKey: "CurrentGameId")
        
        chatViewModel = ChatViewModel(gameId: gameId)
        viewModel = TableGameViewModel(gameId: gameId)
    }
    
    var body: some View {
        if !self.viewModel.loadingGame {
            ZStack {
                ZStack (alignment: .leading) {
                    Color.dark6.edgesIgnoringSafeArea(.all).zIndex(1)
                    
                    if self.gameLoaded {
                        HStack {
                            //Side menu
                            VStack {
                                TableMenuItem(icon: "standings", active: self.$activeMenu[0], notification: .constant(false)) {
                                    let newValue = self.activeMenu[0] ? false : true
                                    
                                    withAnimation (.easeIn(duration: 0.1)) {
                                        self.activeMenu = [newValue, false, false]
                                    }
                                }
                                
                                TableMenuItem(icon: "chat", active: self.$activeMenu[1], notification: self.$chatViewModel.newMessage) {
                                    
                                    let newValue = self.activeMenu[1] ? false : true
                                    
                                    withAnimation (.easeIn(duration: 0.1)) {
                                        self.activeMenu = [false, newValue, false]
                                    }
                                }
                                
                                TableMenuItem(icon: "cards", active: self.$activeMenu[2], notification: .constant(false)) {
                                
                                    let newValue = self.activeMenu[2] ? false : true
                                    
                                    withAnimation (.easeIn(duration: 0.1)) {
                                        self.activeMenu = [false, false, newValue]
                                    }
                                }
                                
                                Spacer()
                                
                                TableMenuItem(active: .constant(false), notification: .constant(false), systemName: "arrow.turn.down.left") {
                                    
                                    withAnimation {
                                        self.viewModel.showLeaveGameModal.toggle()
                                    }
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                            .frame(minWidth: 0, maxWidth: 76, minHeight: 0, maxHeight: .infinity, alignment: .top)
                            .background(Color.dark8)
                            
                            //Table
                            ZStack{
                                GeometryReader { geometry in
                                    ZStack {
                                        TableView(width: geometry.size.width / 1.6,
                                                  height: geometry.size.height / 2.1)
                                            .offset(y: geometry.size.height * 0.06)
                                        
                                        if (self.viewModel.currentPlayer.id == self.viewModel.game.createdBy)
                                            && !(self.viewModel.game.active ?? false)
                                        {
                                            ZStack {
                                                Button(action: {
                                                    self.viewModel.startGame()
                                                }, label: {
                                                    Text("Iniciar jogo")
                                                })
                                                .buttonStyle(PrimaryButton())
                                                
                                                ActivityIndicator(shouldAnimate: self.$viewModel.loadingGame)
                                            }
                                            .offset(y: geometry.size.height * 0.19)
                                        }
                                        
                                        //Player
                                        ZStack {
                                            PlayerView(player: self.$viewModel.player7, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * -0.29, y: geometry.size.height * 0.30)
                                            
                                            PlayerView(player: self.$viewModel.player6, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * -0.35, y: geometry.size.height * 0.07)

                                            PlayerView(player: self.$viewModel.player5, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * -0.29, y: geometry.size.height * -0.15)
                                            
                                            //Topo
                                            PlayerView(player: self.$viewModel.player4, viewModel: self.viewModel)
                                                .offset(x: 0, y: geometry.size.height * -0.18)
                                            
                                            PlayerView(player: self.$viewModel.player3, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * 0.29, y: geometry.size.height * -0.15)

                                            PlayerView(player: self.$viewModel.player2, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * 0.35, y: geometry.size.height * 0.07)

                                            //Canto inferior direito
                                            PlayerView(player: self.$viewModel.player1, viewModel: self.viewModel)
                                                .offset(x: geometry.size.width * 0.29, y: geometry.size.height * 0.30)
                                        }
                                        
                                        SelfPlayerView(player: self.$viewModel.currentPlayer,
                                                       game: self.viewModel.game,
                                                       currentCards: self.viewModel.currentPlayerCards,
                                                       showingHunch: self.$viewModel.showHunchView,
                                                       viewModel: self.viewModel)
                                            .offset(y: geometry.size.height * 0.30)
                                        
                                        if self.viewModel.showHunchView {
                                            HunchView(choices: self.viewModel.choices, viewModel: self.viewModel)
                                                .offset(y: geometry.size.height * 0.50)
                                        }
                                    }
                                    .animation(.easeOut(duration: 0.3))
                                    .offset(x: self.activeMenu[0] || self.activeMenu[1] || self.activeMenu[2] ? geometry.size.width / 4 : geometry.size.width / 6, y: 0)
                                }
                            }
                        }
                        .zIndex(1)
                        
                        //Side menu shape view
                        if self.activeMenu[0] || self.activeMenu[1] || self.activeMenu[2] {
                            ZStack (alignment: .topLeading) {
                                LinearGradient(gradient:
                                                Gradient(colors: [Color.dark8,
                                                                  Color.dark8.opacity(0.7),
                                                                  Color.dark8.opacity(0.8),
                                                                  Color.dark8.opacity(0.9),
                                                                  Color.dark8.opacity(0)]), startPoint: .leading, endPoint: .trailing)
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
                                                            ChatMessageView(message: message, players: self.viewModel.players!).id(message.id)
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
                                                        .frame(width: 200, height: 40)
                                                    
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
                                            .padding(.bottom, 14)
                                        
                                        ScrollView {
                                            StandingsView(players: self.$viewModel.players)
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    .padding(.top, 12)
                                    .padding(.leading, 8)
                                }
                            }
                            .padding(.trailing, 36)
                            .zIndex(1)
                            .offset(x: 76, y: 0)
                            .frame(minWidth: 280, maxWidth: 280, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                }
                .blur(radius: self.viewModel.showLeaveGameModal ? 25 : 0)
                .onTapGesture {
                    withAnimation {
                        self.viewModel.showLeaveGameModal = false
                    }
                    
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
                
                ModalView(show: self.$viewModel.showLeaveGameModal) {
                    ConfirmModal(title: "Deseja sair do jogo?",
                                 subtitle: "Você ainda poderá voltar ao jogo",
                                 loading: self.$viewModel.loadingLeaveGame)
                    {
                        withAnimation {
                            self.viewModel.showLeaveGameModal = false
                        }
                        
                    } confirmAction: {
                        withAnimation {
                            self.activeMenu = [false, false, false]
                            self.viewModel.loadingLeaveGame = true
                        }
                        
                        NetworkHelper().leaveGame(gameId: self.viewModel.game._id!) { error in
                            
                            if error == nil {
                                self.presentation.wrappedValue.dismiss()
                                
                                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                UINavigationController.attemptRotationToDeviceOrientation()
                            } else {
                                withAnimation {
                                    self.viewModel.loadingLeaveGame = false
                                }
                                
                                self.viewModel.showLeaveGameModal = false
                            }
                        }
                    }

                }
            }
            
            
            
        }
        
        
    }
}

struct TableGameView_Previews: PreviewProvider {
    static var previews: some View {
        TableGameView(gameId: "")
            .previewLayout(.fixed(width: 1068, height: 420))
    }
}
