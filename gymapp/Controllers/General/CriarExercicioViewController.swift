//
//  CriarExercicioViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 22/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class CriarExercicioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nomeExercicioLabel: UITextField!
    @IBOutlet weak var imagemExercicio: UIImageView!
    @IBOutlet weak var observacoesExercicioLabel: UITextView!
    
    var auth: Auth!
    var storage: Storage!
    var db: Firestore!
    var urlImagem = ""
    
    var treinoExercicios: Dictionary<String, Any>!
    
    var idUsuarioLogado: String!
    var emailUsuarioLogado: String!
    let uuid = UUID().uuidString
    var imagePicker = UIImagePickerController()
    
    
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        auth = Auth.auth()
        storage = Storage.storage()
        db = Firestore.firestore()
        
        
        if let usuarioAtual = auth.currentUser {
            self.idUsuarioLogado = usuarioAtual.uid
            self.emailUsuarioLogado = usuarioAtual.email
        }

    }
    
    @IBAction func pegarImagemExercicioButton(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func salvarExercicioButton(_ sender: Any) {
        
        if let nomeExercicio = nomeExercicioLabel.text {
            if let observacaoExercicio = observacoesExercicioLabel.text {
                
                let dadosExercicio: Dictionary<String, Any> = [
                    "id": uuid,
                    "idUsuario": idUsuarioLogado!,
                    "nome": nomeExercicio,
                    "urlImagem": self.urlImagem,
                    "observacao": observacaoExercicio
                ]
                
                salvarImagemExercicioFirebase(imagemRecuperada: self.imagemExercicio.image!)
                
                self.salvarExercicioFirebase(dadosExercicio: dadosExercicio)
                
            }
        }
        
    }
    
    // Chama o método para salvar imagem no firebase ao finalizar
    // a escolha da imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[
            UIImagePickerController.InfoKey.originalImage
        ] as! UIImage
        
        self.imagemExercicio.image = imagemRecuperada
        
        //salvarImagemExercicioFirebase(imagemRecuperada: imagemRecuperada)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func salvarImagemExercicioFirebase(imagemRecuperada: UIImage) {
        
        self.imagemExercicio.image = imagemRecuperada
        
        let imagens = storage
            .reference()
            .child("imagens")
        
        if let imagemUpload = imagemRecuperada.jpegData(compressionQuality: 0.5) {
            
            if let usuarioLogado = auth.currentUser {
                
                let uuid = UUID().uuidString
                
                let idUsuario = usuarioLogado.uid
                let nomeImagem = "\(uuid).jpg"
                
                
                let fotoPerfilRef = imagens.child("perfil").child(nomeImagem)
                    fotoPerfilRef.putData(imagemUpload, metadata: nil) { (metaData, error) in
                        
                        if error == nil {
                            
                            fotoPerfilRef.downloadURL { (url, error) in
                                if let urlImagem = url?.absoluteString {
                                    self.db
                                      .collection("usuarios")
                                    .document(idUsuario)
                                    .collection("treinos")
                                        .document(self.treinoExercicios["id"] as! String)
                                    .collection("exercicios")
                                        .document(self.uuid)
                                      .updateData([
                                          "urlImagem": urlImagem
                                      ])
                                }
                            }
                            
                        } else {
                            self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao atualizar a imagem do exercício. Tente novamente!")
                        }
                }
            }
        }
    }
        
    
    func salvarExercicioFirebase(dadosExercicio: Dictionary<String, Any>) {
        
        if let idExercicio = dadosExercicio["id"] {
            db.collection("usuarios")
            .document(idUsuarioLogado)
            .collection("treinos")
            .document(self.treinoExercicios["id"] as! String)
            .collection("exercicios")
            .document(String(describing: idExercicio))
                .setData(dadosExercicio) { (error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
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
