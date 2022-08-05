//
//  ViewController.swift
//  DragonBall-Practica
//
//  Created by Rodrigo Latorre on 14/07/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HeroesTable" 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    @IBAction func onButtonTap(_ sender: Any) {
        
//        let user: String = userTextField.text ?? "rodrigo.latorre@outlook.com"
//        let password: String = passwordTextField.text ?? "rlq12345"
        let login = NetworkModel()
        let user: String = "rodrigo.latorre@outlook.com"
        let password: String = "rlq12345"
        
        guard !user.isEmpty, !password.isEmpty else {
            return print("no hay")
        }
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        login.login(user: user, password: password) { [weak self] token, error in
            DispatchQueue.main.async {
            
                self?.loginButton.isEnabled = true
                self?.activityIndicator.stopAnimating()
                
                guard let token = token, !token.isEmpty else {
                    return print("no hay token")
                }
                
                LocalDataModel.save(token: token)
                
                let nextVC = TableViewController()
                self?.navigationController?.setViewControllers([nextVC], animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
