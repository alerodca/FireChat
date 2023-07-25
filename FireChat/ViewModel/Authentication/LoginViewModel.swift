//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Alejandro Rodríguez Cañete on 24/7/23.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
    }
}
