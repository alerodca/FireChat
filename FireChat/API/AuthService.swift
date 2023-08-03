//
//  AuthService.swift
//  FireChat
//
//  Created by Alejandro Rodríguez Cañete on 27/7/23.
//

import UIKit
import Firebase

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("DEBUG: Failed to login with error: \(error.localizedDescription)")
            }
        }
    }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")

        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }

            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }

                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
                        return
                    }

                    guard let uid = result?.user.uid else { return }

                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl": profileImageUrl,
                                "uid": uid,
                                "username": credentials.username] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)

                }
            }
        }
        
    }
    
}

