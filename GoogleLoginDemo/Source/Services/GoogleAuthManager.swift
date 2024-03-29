//
//  GoogleAuthManager.swift
//  GoogleLoginDemo
//
//  Created by Иван Барабанщиков on 10/24/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleAuthManager: NSObject, GIDSignInDelegate {
    
    static let instance = GoogleAuthManager()
    private let datastore = GoogleProfileDatastore()
    
    var onLogInSuccess: (()->Void)?
    var isAuthorized = {
        return GIDSignIn.sharedInstance()?.hasPreviousSignIn()
    }
    
    // MARK: - Service methods
    func prepareViewToLogin(presentingViewController: UIViewController, onSuccess: (()->Void)?) {
        GIDSignIn.sharedInstance()?.presentingViewController = presentingViewController
        self.onLogInSuccess = onSuccess
    }
    
    func restorePreviousLogin() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
        NotificationCenter.default.post(Notification(name: .init(Constants.Notifications.UserLogedOut)))
    }
    
    func fetchProfile(completion: @escaping (GoogleProfile)->Void) {
        if let profile = datastore.fetchProfile() {
            completion(profile)
        }
    }
    
    // MARK: - GIDSignInDelegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Perform any operations on signed in user here.
        let profile = GoogleProfile(context: datastore.managedContext)
        profile.userId = user.userID                  // For client-side use only!
        profile.idToken = user.authentication.idToken // Safe to send to the server
        profile.fullName = user.profile.name
        profile.givenName = user.profile.givenName
        profile.familyName = user.profile.familyName
        profile.email = user.profile.email
        profile.imageURL = user.profile.imageURL(withDimension: 400)
        
        datastore.appendProfile(profileInfo: profile)
        
        onLogInSuccess?()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        datastore.clearAllData()
    }
}
