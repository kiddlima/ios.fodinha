//
//  NetworkHelper.swift
//  Fodinha
//
//  Created by Vinicius Lima on 02/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import FirebaseAuth

protocol NetworkRequestDelegate {
    func success(response: Any?)
    func fail(errorMessage: String)
}

class NetworkHelper: NSObject {
    
    let URL = "http://api.truquero.com.br/api/v1"
    
    let defaultHeader: HTTPHeaders = [
        "Content-Type":"application/json"]
    
    func getAuthHeader(completion: @escaping (([String: String]?) -> Void)){
        var map = [String: String]()
        
        Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
            if error == nil {
                map["Authorization"] = "Bearer \(token!)"
                map["Content-Type"] = "application/json"
                
                completion(map)
            } else {
                completion(nil)
            }
        })
    }
    
    func register(name: String, email: String, password: String, callback: @escaping ((String?) -> Void)) {
        
        let parameters: Parameters =
            [
                "name": name,
                "email": email,
                "password": password
            ]
        
        Alamofire.request(
            "\(URL)/user",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: defaultHeader)
            .validate()
            .responseString { response in
                
                switch response.result{
                case .success( _):
                    callback("Usuário cadastrado com sucesso")
                case .failure( _):
                    callback(nil)
                }
            }
    }
    
    func getGames(networkDelegate: NetworkRequestDelegate) {
        Alamofire.request(
            "\(URL)/game",
            method: .get,
            headers: defaultHeader)
            .validate()
            .responseJSON { response in
                
                switch response.result{
                
                case .success( _):
                    
//                    do {
//                        try JSONDecoder().decode([Game].self, from: response.data!)
//                    } catch let error {
//                        print(error)
//                    }
                    
                    if let gamesResponse = try? JSONDecoder().decode([Game].self, from: response.data!){
                        networkDelegate.success(response: gamesResponse)
                    } else {
                        networkDelegate.fail(errorMessage: "Erro ao carregar jogos")
                    }
                case .failure( _):
                    networkDelegate.fail(errorMessage: "Erro ao carregar jogos")
                }
            }
    }
    
    func getGame(gameId: String, callback: @escaping (Game?, String?) -> Void) {
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/\(gameId)",
                method: .get,
                headers: authHeader)
                .validate()
                .responseJSON { response in
                    
                    switch response.result{
                    
                    case .success( _):
                        
                        if let gameResponse = try? JSONDecoder().decode(Game.self, from: response.data!){
                            callback(gameResponse, nil)
                        } else {
                            callback(nil, "Erro ao carregar jogo")
                        }
                    case .failure( _):
                        callback(nil, "Erro ao carregar jogo")
                    }
                }
        }
        
    }
    
    func socialLogin(networkDelegate: NetworkRequestDelegate) {
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/login/social",
                method: .post,
                headers: authHeader)
                .responseString { response in
                    
                    if (response.response?.statusCode ?? 500) >= 400 {
                        networkDelegate.fail(errorMessage: "Erro ao logar")
                    } else {
                        networkDelegate.success(response: nil)
                    }
                }
        }
        
    }
    
    func createGame(name: String, password: String?, callback: @escaping (String?, String?) -> Void) {
        
        let parameters: Parameters
        
        if password != nil || ((password?.isEmpty) != nil){
            parameters = [
                "name": name,
                "password": password!
            ]
        } else {
            parameters = [
                "name": name
            ]
        }
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .validate()
                .responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .success( _):
                        if let gameId = try? JSONDecoder().decode(String.self, from: response.data!) {
                            callback(gameId, nil)
                        } else {
                            callback(nil, "Erro ao criar jogo")
                        }
                    case .failure( _):
                        callback(nil, "Erro ao criar jogo")
                    }
                })
        }
    }
    
    func joinGame(gameId: String, password: String?, callback: @escaping (String?) -> Void ) {
        
        let parameters: Parameters
        
        if password != nil || ((password?.isEmpty) != nil){
            parameters = [
                "gameId": gameId,
                "password": password!
            ]
        } else {
            parameters = [
                "gameId": gameId
            ]
        }
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/player",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao entrar no jogo")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
    
    func makeHunch(gameId: String, hunch: Int, callback: @escaping (String?) -> Void) {
        
        let parameters: Parameters =
            [
                "gameId": gameId,
                "hunch": hunch
            ]
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/player/hunch",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao realizar hunch")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
    
    func playCard(gameId: String, card: Card, callback: @escaping (String?) -> Void) {
        let parameters: Parameters =
            [
                "gameId": gameId,
                "card": [
                    "value": card.value!,
                    "rank": card.rank!,
                    "suit": card.suit!
                ]
            ]
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/player/play",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao jogar carta")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
    
    func startGame(gameId: String, callback: @escaping (String?) -> Void) {
        
        let parameters: Parameters =
            [
                "gameId": gameId
            ]
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/start",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao iniciar jogo")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
    
    func leaveGame(gameId: String, callback: @escaping (String?) -> Void) {
        let parameters: Parameters =
            [
                "gameId": gameId
            ]
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/player/leave",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao sair do jogo")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
    
    func rejoinGame(gameId: String, callback: @escaping (String?) -> Void) {
        let parameters: Parameters =
            [
                "gameId": gameId
            ]
        
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/game/player/confirm",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response?.statusCode ?? 500 >= 400 {
                        callback("Erro ao confirmar rematch")
                    } else {
                        callback(nil)
                    }
                }
        }
    }
}
