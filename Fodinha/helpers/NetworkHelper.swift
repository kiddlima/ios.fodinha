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
    
    func socialLogin(networkDelegate: NetworkRequestDelegate) {
        getAuthHeader { authHeader in
            Alamofire.request(
                "\(self.URL)/login/social",
                method: .post,
                headers: authHeader)
                .responseString { response in
                    
                    if response.response!.statusCode >= 400 {
                        networkDelegate.fail(errorMessage: "Erro ao logar")
                    } else {
                        networkDelegate.success(response: nil)
                    }
                }
        }
        
    }
    
    func login (user: String, password: String, callback: @escaping ((String?) -> Void)) {
        
        let parameters: Parameters =
            [
                "user": user,
                "password": password
            ]
        
        Alamofire.request(
            "\(URL)/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: defaultHeader)
            .validate()
            .responseString { response in
                
                switch response.result{
                case .success( _):
                    callback("Usuário logado com sucesso")
                case .failure( _):
                    callback(nil)
                }
            }
    }
    
    
}
