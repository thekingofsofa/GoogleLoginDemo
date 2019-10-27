//
//  LoginViewController.swift
//  GoogleLoginDemo
//
//  Created by Иван Барабанщиков on 10/24/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: BaseViewController {
    
    var onLogInSuccess: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.Login
        setupViews()
        
        GoogleAuthManager.instance.prepareViewToLogin(presentingViewController: self, onSuccess: onLogInSuccess)
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        self.view.backgroundColor = .red
        setupGIDButton()
    }
    
    private func setupGIDButton() {
        
        let signInButton = GIDSignInButton()
        signInButton.style = .standard
        signInButton.colorScheme = .light
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }
}
