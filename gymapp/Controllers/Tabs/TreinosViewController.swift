//
//  TreinosViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TreinosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var treinosTableView: UITableView!
    var auth: Auth!
    var handler: AuthStateDidChangeListenerHandle!
    var cont = 7
    var db: Firestore!
    var idUsuarioLogado: String!
    var listaTreinos: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        // Recupera id do usuário logado:
        if let id = auth.currentUser?.uid {
            self.idUsuarioLogado = id
        }
        
        treinosTableView.separatorStyle = .none
        treinosTableView.allowsSelection = false
        
        self.checaSeEstaLogado()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarTreinos()
    }
    
    func recuperarTreinos() {
        
        self.listaTreinos.removeAll()
        db.collection("usuarios")
        .document(idUsuarioLogado)
        .collection("treinos")
            .getDocuments { (snapshotResult, error) in
                
                if let snapshot = snapshotResult {
                    for document in snapshot.documents {
                        
                        let dadosTreino = document.data()
                        self.listaTreinos.append(dadosTreino)
                        
                    }
                    self.treinosTableView.reloadData()
                }
                
        }
        
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
        let totalTreinos = self.listaTreinos.count
        return totalTreinos + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let celula = tableView.dequeueReusableCell(withIdentifier: "treinoPadraoCelula", for: indexPath) as! TreinoPadraoTableViewCell
            
            celula.nomeTreinoPadrao.text = "Treino Padrão"
            celula.descricaoTreinoPadrao.text = "Treino padrão para braços e pernas."
            
            return celula
            
        } else {
            
            let celula = tableView.dequeueReusableCell(withIdentifier: "treinoCelula", for: indexPath) as! TreinoTableViewCell
            
            let dadosTreino = self.listaTreinos[indexPath.row-1]
            
            celula.nomeTreinoLabel.text = dadosTreino["nome"] as? String
            celula.descricaoTreinoLabel.text = dadosTreino["descricao"] as? String
            celula.dataTreinoLabel.text = dadosTreino["data"] as? String
            
            return celula
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        auth.removeStateDidChangeListener(handler)
    }

}
