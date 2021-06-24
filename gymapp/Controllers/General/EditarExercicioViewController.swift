//
//  EditarExercicioViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 24/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class EditarExercicioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var exercicioEditar: Dictionary<String, Any>!
    var treinoEditar: Dictionary<String, Any>!
    
    @IBOutlet weak var nomeExercicioLabel: UITextField!
    @IBOutlet weak var imagemExercicio: UIImageView!
    @IBOutlet weak var observacaoExercicio: UITextView!
    
    var auth: Auth!
    var storage: Storage!
    var db: Firestore!
    var urlImagem = ""
    var idUsuarioLogado: String!
    var imagePicker = UIImagePickerController()
    
    @IBAction func selecionarImagemButton(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        storage = Storage.storage()
        db = Firestore.firestore()
        
        /*
        nomeExercicioLabel.text = exercicioEditar["nome"] as? String
        observacaoExercicio.text = exercicioEditar["observacao"] as? String
        
        if let imagemExercicioEditada = exercicioEditar["urlImagem"] as? String {
            imagemExercicio.sd_setImage(with: URL(string: imagemExercicioEditada), completed: nil)
        } else {
            imagemExercicio.image = UIImage(named: "imagem-padrao-exercicio")
        }
         */
        nomeExercicioLabel.text = exercicioEditar["nome"] as? String
        observacaoExercicio.text = exercicioEditar["observacao"] as? String
        
        
        
        if let usuarioAtual = auth.currentUser {
            self.idUsuarioLogado = usuarioAtual.uid
        }

    }
    
    // Chama o método para salvar imagem no firebase ao finalizar
    // a escolha da imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[
            UIImagePickerController.InfoKey.originalImage
        ] as! UIImage
        
        self.imagemExercicio.image = imagemRecuperada
        
        //atualizarImagemExercicioFirebase(imagemRecuperada: imagemRecuperada)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func atualizarImagemExercicioFirebase(imagemRecuperada: UIImage) {
        
        self.imagemExercicio.image = imagemRecuperada
        
        let imagens = storage
            .reference()
            .child("imagens")
        
        if let imagemUpload = imagemRecuperada.jpegData(compressionQuality: 0.5) {
            
            if let usuarioLogado = auth.currentUser {
                
                let uuid = UUID().uuidString
                
                let idUsuario = usuarioLogado.uid
                let nomeImagem = "\(uuid).jpg"
                
                
                let fotoPerfilRef = imagens.child("exercicio").child(nomeImagem)
                    fotoPerfilRef.putData(imagemUpload, metadata: nil) { (metaData, error) in
                        
                        if error == nil {
                            
                            fotoPerfilRef.downloadURL { (url, error) in
                                if let urlImagem = url?.absoluteString {
                                    self.db
                                      .collection("usuarios")
                                    .document(idUsuario)
                                    .collection("treinos")
                                        .document(self.treinoEditar["id"] as! String)
                                    .collection("exercicios")
                                        .document(self.exercicioEditar["id"] as! String)
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
    
    
    
    
    
    @IBAction func salvarButton(_ sender: Any) {
        
        if let nomeExercicio = nomeExercicioLabel.text {
            if let observacaoExercicio = observacaoExercicio.text {
                
                if nomeExercicio == "" {
                    exibirMensagem(titulo: "Erro", mensagem: "Digite um nome para o exercício!")
                } else {
                
                    if let idTreino = treinoEditar["id"] {
                        db.collection("usuarios")
                            .document(idUsuarioLogado)
                            .collection("treinos")
                            .document(String(describing: idTreino))
                        .collection("exercicios")
                        .document(exercicioEditar["id"] as! String)
                            .updateData([
                                "nome": nomeExercicio,
                                "observacao": observacaoExercicio
                            ])
                    }
                    
                    atualizarImagemExercicioFirebase(imagemRecuperada: self.imagemExercicio.image!)
                    
                    
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
