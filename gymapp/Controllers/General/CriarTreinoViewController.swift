//
//  CriarTreinoViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class CriarTreinoViewController: UIViewController {
    
    
    @IBOutlet weak var nomeTreinoLabel: UITextField!
    @IBOutlet weak var descricaoTreinoLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func salvarTreinoButton(_ sender: Any) {
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
