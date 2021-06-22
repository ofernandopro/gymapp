//
//  CriarTreinoViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CriarTreinoViewController: UIViewController {
    
    @IBOutlet weak var nomeTreinoLabel: UITextField!
    @IBOutlet weak var descricaoTreinoLabel: UITextView!
    var auth: Auth!
    var db: Firestore!
    let uuid = UUID().uuidString
    
    var idUsuarioLogado: String!
    var emailUsuarioLogado: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        
        if let usuarioAtual = auth.currentUser {
            self.idUsuarioLogado = usuarioAtual.uid
            self.emailUsuarioLogado = usuarioAtual.email
        }
        
    }
    
    @IBAction func salvarTreinoButton(_ sender: Any) {
        
        if let nomeTreino = nomeTreinoLabel.text {
            if let descricaoTreino = descricaoTreinoLabel.text {
                
                let dadosTreino: Dictionary<String, Any> = [
                    "id": uuid,
                    "idUsuario": idUsuarioLogado!,
                    "nome": nomeTreino,
                    "descricao": descricaoTreino,
                    "data": FieldValue.serverTimestamp()
                ]
                
                self.salvarTreinoFirebase(dadosTreino: dadosTreino)
                
            }
        }
        
    }
    
    func salvarTreinoFirebase(dadosTreino: Dictionary<String, Any>) {
        
        if let idTreino = dadosTreino["id"] {
            db.collection("usuarios")
            .document(idUsuarioLogado)
            .collection("treinos")
            .document(String(describing: idTreino))
                .setData(dadosTreino) { (error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
        
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
