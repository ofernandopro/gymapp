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
    
    @IBOutlet weak var imagemDetalhesExercicio: UIImageView!
    @IBOutlet weak var nomeDetalhesExercicio: UILabel!
    @IBOutlet weak var observacaoDetalhesExercicio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeDetalhesExercicio.text = exercicioDetalhes["nome"] as? String
        observacaoDetalhesExercicio.text = exercicioDetalhes["observacao"] as? String
        
        if let imagemExercicio = exercicioDetalhes["urlImagem"] as? String {
            imagemDetalhesExercicio.sd_setImage(with: URL(string: imagemExercicio), completed: nil)
        } else {
            imagemDetalhesExercicio.image = UIImage(named: "imagem-padrao-exercicio")
        }
        
    }

}
