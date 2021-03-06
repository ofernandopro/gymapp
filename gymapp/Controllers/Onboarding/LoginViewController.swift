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
        
        self.checaSeEstaLogado()

    }
    
    // Verifica se o usuário está logado ou não (usado para redirecionar
    // o usuário para a tela de treinos se já estiver logado):
    func checaSeEstaLogado() {
        handler = auth.addStateDidChangeListener { (authentication, user) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
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
        
        // Remove listener que checa se usuário está ou não
        // logado quando o usuário sai da tela de login
        auth.removeStateDidChangeListener(handler)
        
        super.viewWillAppear(animated)
        
        // Configura a cor da Status Bar para branco
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    // Configura a cor da Status Bar para branco
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

}
