//
//  ExerciciosViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 22/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseFirestore

class ExerciciosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var treino: Dictionary<String, Any>!
    var auth: Auth!
    var db: Firestore!
    var idUsuarioLogado: String!
    var listaExercicios: [Dictionary<String, Any>] = []
    
    @IBOutlet weak var tableViewExercicios: UITableView!
    @IBOutlet weak var nomeTreinoLabel: UILabel!
    @IBOutlet weak var descricaoTreinoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = treino["nome"] as? String
        nomeTreinoLabel.text = "Exercícios:"
        /*
        nomeTreinoLabel.text = treino["nome"] as? String
        descricaoTreinoLabel.text = treino["descricao"] as? String
        */
                 
        tableViewExercicios.separatorStyle = .none
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        // Recupera id do usuário logado:
        if let id = auth.currentUser?.uid {
            self.idUsuarioLogado = id
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarExercicios()
    }
    
    func recuperarExercicios() {
        
        self.listaExercicios.removeAll()
        db.collection("usuarios")
        .document(idUsuarioLogado)
        .collection("treinos")
        .document(treino["id"] as! String)
        .collection("exercicios")
            .getDocuments { (snapshotResult, error) in
                
                if let snapshot = snapshotResult {
                    for document in snapshot.documents {
                        
                        let dadosExercicio = document.data()
                        self.listaExercicios.append(dadosExercicio)
                        
                    }
                    self.tableViewExercicios.reloadData()
                }
                
        }
        
    }
    
    
    @IBAction func addExercicioButton(_ sender: Any) {
        performSegue(withIdentifier: "addExercicioSegue", sender: self.treino)
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalExercicios = self.listaExercicios.count
        
        if totalExercicios == 0 {
            return 1
        }
        return totalExercicios
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "exercicioCelula", for: indexPath) as! ExercicioTableViewCell
        
        if self.listaExercicios.count == 0 {
            celula.nomeExercicioLabel.text = "Adicione um Exercício!"
            celula.observacaoExercicioLabel.text = "Adicione um exercício para começar a treinar!"
            celula.exercicioImagem.image = UIImage(named: "imagem-padrao-exercicio")
            return celula
        }
        
        let dadosExercicio = self.listaExercicios[indexPath.row]
        
        celula.nomeExercicioLabel.text = dadosExercicio["nome"] as? String
        celula.observacaoExercicioLabel.text = dadosExercicio["observacao"] as? String
        
        if let imagemExercicio = dadosExercicio["urlImagem"] as? String {
            celula.exercicioImagem.sd_setImage(with: URL(string: imagemExercicio), completed: nil)
        } else {
            celula.exercicioImagem.image = UIImage(named: "imagem-padrao-exercicio")
        }
        
        return celula
        
    }
    
    // Usado para abrir a tela de Detalhes Exercicio ao clicar em um exercício:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.listaExercicios.count > 0 {
            self.tableViewExercicios.deselectRow(at: indexPath, animated: true)
            let index = indexPath.row
            let exercicio = self.listaExercicios[index]
            
            self.performSegue(withIdentifier: "detalhesExercicioSegue", sender: exercicio)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExercicioSegue" {
            let viewDestino = segue.destination as! CriarExercicioViewController
            viewDestino.treinoExercicios = treino
        }
        else if segue.identifier == "detalhesExercicioSegue" {
            let viewDestino = segue.destination as! DetalhesExercicioViewController
            viewDestino.exercicioDetalhes = sender as? Dictionary
        }
    }
    
    // Método para remover Exercício
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let dadosExercicio = self.listaExercicios[indexPath.row]
    
            // Removendo do Firebase
            self.db
              .collection("usuarios")
            .document(idUsuarioLogado)
            .collection("treinos")
                .document(treino["id"] as! String)
            .collection("exercicios")
            .document(dadosExercicio["id"] as! String)
              .delete()
            
            // Removendo do Array
            self.listaExercicios.remove(at: indexPath.row)
            // Removendo da Table View
            self.tableViewExercicios.deleteRows(at: [indexPath], with: .automatic)
        }
            
    }
    

}
