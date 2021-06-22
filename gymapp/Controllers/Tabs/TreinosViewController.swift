//
//  TreinosViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class TreinosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var treinosTableView: UITableView!
    var auth: Auth!
    var handler: AuthStateDidChangeListenerHandle!
    var cont = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        treinosTableView.separatorStyle = .none
        treinosTableView.allowsSelection = false
        
        self.checaSeEstaLogado()

    }
    
    // Verifica se o usuário está logado ou não (usado para redirecionar
    // o usuário para a tela de login se não estiver logado):
    func checaSeEstaLogado() {
        handler = auth.addStateDidChangeListener { (authentication, user) in
            if user == nil {
                self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cont + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let celula = tableView.dequeueReusableCell(withIdentifier: "treinoPadraoCelula", for: indexPath) as! TreinoPadraoTableViewCell
            
            celula.nomeTreinoPadrao.text = "Treino Padrao"
            
            return celula
            
        } else {
            
            let celula = tableView.dequeueReusableCell(withIdentifier: "treinoCelula", for: indexPath) as! TreinoTableViewCell
            
            celula.nomeTreinoLabel.text = "Treino 1"
            
            return celula
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        auth.removeStateDidChangeListener(handler)
    }

}
