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
        
        let user: String = userTextField.text!
        let password: String = passwordTextField.text!
        let login = NetworkModel()
        
        guard !user.isEmpty, !password.isEmpty else {
            let alert = UIAlertController(title: "Empty fields", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertAction)
            present(alert, animated: true)
            return
        }
        
        loginButton.isEnabled = false
        activityIndicator.startAnimating()
        
        login.login(user: user, password: password) { [weak self] token, error in
            DispatchQueue.main.async {
            
                self?.loginButton.isEnabled = true
                self?.activityIndicator.stopAnimating()
                
                guard let token = token, !token.isEmpty else {
                    let alert = UIAlertController(title: "Usuario o contraseña incorrectos", message: "", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(alertAction)
                    self?.present(alert, animated: true)
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
