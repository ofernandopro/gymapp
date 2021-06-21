//
//  PerfilViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class PerfilViewController: UIViewController {
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        
    }
    
    @IBAction func sairButton(_ sender: Any) {
        
        do {
            try auth.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao deslogar. Tente novamente!")
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

}
