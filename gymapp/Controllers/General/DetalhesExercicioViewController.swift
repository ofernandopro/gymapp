//
//  DetalhesExercicioViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 23/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class DetalhesExercicioViewController: UIViewController {
    
    var exercicioDetalhes: Dictionary<String, Any>!
    var treinoAux: Dictionary<String, Any>!
    
    @IBOutlet weak var imagemDetalhesExercicio: UIImageView!
    @IBOutlet weak var nomeDetalhesExercicio: UILabel!
    @IBOutlet weak var observacaoDetalhesExercicio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarDadosUsuario()
    }
    
    func recuperarDadosUsuario() {
        
        nomeDetalhesExercicio.text = exercicioDetalhes["nome"] as? String
        observacaoDetalhesExercicio.text = exercicioDetalhes["observacao"] as? String
        
        if let imagemExercicio = exercicioDetalhes["urlImagem"] as? String {
            imagemDetalhesExercicio.sd_setImage(with: URL(string: imagemExercicio), completed: nil)
        } else {
            imagemDetalhesExercicio.image = UIImage(named: "imagem-padrao-exercicio")
        }
        
    }
    
    @IBAction func editarButton(_ sender: Any) {
        performSegue(withIdentifier: "editarExercicioSegue", sender: exercicioDetalhes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarExercicioSegue" {
            let viewDestino = segue.destination as! EditarExercicioViewController
            viewDestino.exercicioEditar = sender as? Dictionary
            viewDestino.treinoEditar = treinoAux
        }
    }

}
