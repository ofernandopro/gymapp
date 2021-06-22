//
//  ExerciciosViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 22/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class ExerciciosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var treino: Dictionary<String, Any>!
    
    @IBOutlet weak var nomeTreinoLabel: UILabel!
    @IBOutlet weak var descricaoTreinoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeTreinoLabel.text = treino["nome"] as? String
        descricaoTreinoLabel.text = treino["descricao"] as? String
                
    }
    
    
    @IBAction func addExercicioButton(_ sender: Any) {
        performSegue(withIdentifier: "addExercicioSegue", sender: self.treino)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExercicioSegue" {
            let viewDestino = segue.destination as! CriarExercicioViewController
            viewDestino.treinoExercicios = treino
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "exercicioCelula", for: indexPath)
        return celula
        
    }
    

}
