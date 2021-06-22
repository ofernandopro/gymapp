//
//  LoginViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var senhaLabel: UITextField!
    
    var auth: Auth!
    var handler: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        auth = Auth.auth()
        
        

    }
    
    @IBAction func logInButton(_ sender: Any) {
        self.logIn()
    }
    
    func logIn() {
        
        if let emailUsuario = emailLabel.text {
            if let senhaUsuario = senhaLabel.text {
                       
                auth.signIn(withEmail: emailUsuario, password: senhaUsuario) { (user, error) in
                           
                    if error == nil {
                               
                        if user != nil {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                               
                    } else {
                        self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao logar. Tente novamente!")
                    }
                           
                }
                       
            } else {
                self.exibirMensagem(titulo: "Erro", mensagem: "Digite sua senha!")
            }
        } else {
            self.exibirMensagem(titulo: "Erro", mensagem: "Digite seu email!")
        }
        
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(okAction)
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        //auth.removeStateDidChangeListener(handler)
        
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

}
