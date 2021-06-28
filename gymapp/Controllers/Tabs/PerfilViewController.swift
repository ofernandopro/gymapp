//
//  PerfilViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var fotoPerfilImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var auth: Auth!
    var storage: Storage!
    var db: Firestore!
    
    var imagePicker = UIImagePickerController()
    var idUsuario: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        auth = Auth.auth()
        storage = Storage.storage()
        db = Firestore.firestore()
        
        self.recuperarIdUsuarioLogado()
        self.recuperarDadosUsuario()
        
    }
    
    func recuperarIdUsuarioLogado() {
        if let id = auth.currentUser?.uid {
            self.idUsuario = id
        }
    }
    
    func recuperarDadosUsuario() {
        
        let usuariosRef = self.db
          .collection("usuarios")
        .document(idUsuario)
        
        usuariosRef.getDocument { (snapshot, error) in
            
            if let data = snapshot?.data() {
                
                let nomeUsuario = data["nome"] as? String
                let emailUsuario = data["email"] as? String

                self.nomeLabel.text = nomeUsuario
                self.emailLabel.text = emailUsuario
                
                if let urlImagem = data["urlImagem"] as? String {
                    self.fotoPerfilImageView.sd_setImage(with: URL(string: urlImagem), completed: nil)
                }
                
            }
            
        }
        
    }
    
    @IBAction func escolherImagemButton(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Chama o método para salvar imagem no firebase ao finalizar
    // a escolha da imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[
            UIImagePickerController.InfoKey.originalImage
        ] as! UIImage
        
        salvarImagemPerfilFirebase(imagemRecuperada: imagemRecuperada)
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func salvarImagemPerfilFirebase(imagemRecuperada: UIImage) {
        
        self.fotoPerfilImageView.image = imagemRecuperada
        
        let imagens = storage
            .reference()
            .child("imagens")
        
        if let imagemUpload = imagemRecuperada.jpegData(compressionQuality: 0.5) {
            
            if let usuarioLogado = auth.currentUser {
                
                let idUsuario = usuarioLogado.uid
                let nomeImagem = "\(idUsuario).jpg"
                
                let fotoPerfilRef = imagens.child("perfil").child(nomeImagem)
                    fotoPerfilRef.putData(imagemUpload, metadata: nil) { (metaData, error) in
                        
                        if error == nil {
                            
                            fotoPerfilRef.downloadURL { (url, error) in
                                if let urlImagem = url?.absoluteString {
                                    self.db
                                      .collection("usuarios")
                                    .document(idUsuario)
                                      .updateData([
                                          "urlImagem": urlImagem
                                      ])
                                }
                            }
                            
                        } else {
                            self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao atualizar a foto de perfil. Tente novamente!")
                        }
                }
            }
        }
    }
    
    // Fazer logout
    @IBAction func sairButton(_ sender: Any) {
        
        do {
            try auth.signOut()
            self.performSegue(withIdentifier: "sairSegue", sender: nil)
        } catch {
            self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao deslogar. Tente novamente!")
        }
        
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerta.addAction(okAction)
        
        self.present(alerta, animated: true, completion: nil)
        
    }

}
