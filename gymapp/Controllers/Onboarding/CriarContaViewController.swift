//
//  CriarContaViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CriarContaViewController: UIViewController {
    
    @IBOutlet weak var nomeLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var senhaLabel: UITextField!
    @IBOutlet weak var confirmarSenhaLabel: UITextField!
    
    var auth: Auth!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        db = Firestore.firestore()
        
    }
    
    @IBAction func criarContaButton(_ sender: Any) {
        self.criarConta()
    }
    
    func criarConta() {
        
        if let nomeUsuario = nomeLabel.text {
            if let emailUsuario = emailLabel.text {
                if let senhaUsuario = senhaLabel.text {
                    if let confirmarSenhaUsuario = confirmarSenhaLabel.text {
                        
                        if nomeUsuario == "" {
                            self.exibirMensagem(titulo: "Erro", mensagem: "Digite seu nome!")
                        } else {
                        
                            if senhaUsuario == confirmarSenhaUsuario {
                               
                                auth.createUser(withEmail: emailUsuario, password: senhaUsuario) { (resultData, error) in
                                    
                                    if error == nil {
                                        
                                        // Save user data on firebase firestore with name
                                        if let idUsuario = resultData?.user.uid {
                                            self.db.collection("usuarios")
                                            .document(idUsuario)
                                            .setData([
                                                "nome": nomeUsuario,
                                                "email": emailUsuario,
                                                "id": idUsuario
                                            ])
                                        }
                                        
                                        self.performSegue(withIdentifier: "criarContaSegue", sender: nil)
                                    } else {
                                        self.exibirMensagem(titulo: "Erro", mensagem: "Falha ao criar sua conta. Tente novamente!")
                                    }
                                    
                                }
                                
                            } else {
                                self.exibirMensagem(titulo: "Erro", mensagem: "Senha e Confirmar Senha não são iguais.")
                            }
                        }
                        
                    } else {
                        self.exibirMensagem(titulo: "Erro", mensagem: "Digite sua senha novamente!")
                    }
                } else {
                    self.exibirMensagem(titulo: "Erro", mensagem: "Digite seu senha!")
                }
            } else {
                self.exibirMensagem(titulo: "Erro", mensagem: "Digite seu email!")
            }
        }
        
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo,
                                      message: mensagem,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alerta.addAction(okAction)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
