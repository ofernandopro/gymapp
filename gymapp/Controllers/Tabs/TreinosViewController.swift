//
//  TreinosViewController.swift
//  gymapp
//
//  Created by Fernando Moreira on 21/06/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class TreinosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var treinosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        treinosTableView.separatorStyle = .none
        treinosTableView.allowsSelection = false

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "treinoCelula", for: indexPath) as! TreinoTableViewCell
        
        celula.nomeTreinoLabel.text = "Treino 1"
        
        return celula
        
    }

}
