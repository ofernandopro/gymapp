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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                         
        tableViewExercicios.separatorStyle = .none
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        self.recuperaIdLogado()
        
    }
    
    // Recupera id do usuário logado:
    func recuperaIdLogado() {
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
            .order(by: "data", descending: true)
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
    
    @IBAction func editarExercicioSegue(_ sender: Any) {
        performSegue(withIdentifier: "editarTreinoSegue", sender: treino)
    }
    
    @IBAction func addExercicioButton(_ sender: Any) {
        performSegue(withIdentifier: "addExercicioSegue", sender: self.treino)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalExercicios = self.listaExercicios.count
        return totalExercicios
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "exercicioCelula", for: indexPath) as! ExercicioTableViewCell
        
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
            viewDestino.treinoAux = treino
        }
        else if segue.identifier == "editarTreinoSegue" {
            let viewDestino = segue.destination as! EditarTreinoViewController
            viewDestino.treinoEditar = sender as? Dictionary
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
