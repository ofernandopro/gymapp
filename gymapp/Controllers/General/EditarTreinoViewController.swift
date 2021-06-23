//
//  EditarTreinoViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 23/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class EditarTreinoViewController: UIViewController {

    var treinoEditar: Dictionary<String, Any>!
    
    @IBOutlet weak var nomeTreinoLabel: UITextField!
    @IBOutlet weak var descricaoTreinoLabel: UITextView!
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(treinoEditar.count)
        
        /*
        nomeTreinoLabel.text = treinoEditar["nome"] as? String
        descricaoTreinoLabel.text = treinoEditar["descricao"] as? String
*/
    }
    
    @IBAction func salvarButton(_ sender: Any) {
        
    }
    
}
