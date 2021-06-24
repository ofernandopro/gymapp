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
    var db: Firestore!
    var idUsuarioLogado: String!
    var listaTreinos: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        // Recupera id do usuário logado:
        if let id = self.auth.currentUser?.uid {
            self.idUsuarioLogado = id
        }
        
        treinosTableView.separatorStyle = .none
        
        //self.checaSeEstaLogado()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.checaSeEstaLogado()
        self.recuperarTreinos()
    }
    
    func recuperarTreinos() {
        self.listaTreinos.removeAll()
        self.db.collection("usuarios")
            .document(idUsuarioLogado)
        .collection("treinos")
            .order(by: "data", descending: false)
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
    
    /*
    // Verifica se o usuário está logado ou não (usado para redirecionar
    // o usuário para a tela de login se não estiver logado):
    func checaSeEstaLogado() {
        handler = auth.addStateDidChangeListener { (authentication, user) in
            if user == nil {
                self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
            }
        }
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalTreinos = self.listaTreinos.count
        return totalTreinos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let celula = tableView.dequeueReusableCell(withIdentifier: "treinoCelula", for: indexPath) as! TreinoTableViewCell
        
        let dadosTreino = self.listaTreinos[indexPath.row]

        // Converte data de timestamp para string
        let dataTimestamp = dadosTreino["data"] as! Timestamp
        let data = dataTimestamp.dateValue()
        
        celula.nomeTreinoLabel.text = dadosTreino["nome"] as? String
        celula.descricaoTreinoLabel.text = dadosTreino["descricao"] as? String
        celula.dataTreino.text = data.asString()
        
        return celula
                    
    }
    
    // Usado para abrir a tela de exercícios ao clicar em um treino:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.treinosTableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        let treino = self.listaTreinos[index]
        
        self.performSegue(withIdentifier: "exerciciosSegue", sender: treino)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exerciciosSegue" {
            let viewDestino = segue.destination as! ExerciciosViewController
            viewDestino.treino = sender as? Dictionary
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //auth.removeStateDidChangeListener(handler)
    }
    
    // Método para remover Treino
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let dadosTreino = self.listaTreinos[indexPath.row]
    
            // Removendo do Firebase
            self.db
              .collection("usuarios")
            .document(idUsuarioLogado)
            .collection("treinos")
                .document(dadosTreino["id"] as! String)
              .delete()
            
            /*
            self.db
              .collection("usuarios")
            .document(idUsuarioLogado)
            .collection("treinos")
                .document(dadosTreino["id"] as! String)
            .collection("exercicios")
                .document()
            */
            // Removendo do Array
            self.listaTreinos.remove(at: indexPath.row)
            // Removendo da Table View
            self.treinosTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
            
    }
        

}

extension Date {
    func asString() -> String {
        let dataFormatada = DateFormatter()
        dataFormatada.dateFormat = "dd/MM/yyyy"
        return dataFormatada.string(from: self)
    }
}
