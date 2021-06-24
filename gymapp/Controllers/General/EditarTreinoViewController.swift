//
//  EditarTreinoViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 23/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditarTreinoViewController: UIViewController {

    var treinoEditar: Dictionary<String, Any>!
    
    @IBOutlet weak var nomeTreinoEditado: UITextField!
    @IBOutlet weak var descricaoTreinoEditado: UITextView!
    
    var auth: Auth!
    var db: Firestore!
    var idUsuarioLogado: String!
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeTreinoEditado.text = treinoEditar["nome"] as? String
        descricaoTreinoEditado.text = treinoEditar["descricao"] as? String
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        if let usuarioAtual = auth.currentUser {
            self.idUsuarioLogado = usuarioAtual.uid
        }
        
    }
    
    @IBAction func salvarButton(_ sender: Any) {
        
        if let nomeTreino = nomeTreinoEditado.text {
            if let descricaoTreino = descricaoTreinoEditado.text {
                
                if nomeTreino == "" {
                    exibirMensagem(titulo: "Erro", mensagem: "Digite um nome para o treino!")
                } else {
                    
                        if let idTreino = treinoEditar["id"] {
                            db.collection("usuarios")
                                .document(idUsuarioLogado)
                                .collection("treinos")
                                .document(String(describing: idTreino))
                                .updateData([
                                    "nome": nomeTreino,
                                    "descricao": descricaoTreino
                                ])
                        }
                        dismiss(animated: true, completion: nil)
                
                }
            }
        }
        
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(okAction)
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
}
