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
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            
            // Removendo do Array
            self.listaTreinos.remove(at: indexPath.row)
            
            // Removendo da Table View
            self.treinosTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
            
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(okAction)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
        

}

// Extension para recuperar data formatada em dd/MM/yyyy
extension Date {
    func asString() -> String {
        let dataFormatada = DateFormatter()
        dataFormatada.dateFormat = "dd/MM/yyyy"
        return dataFormatada.string(from: self)
    }
}
