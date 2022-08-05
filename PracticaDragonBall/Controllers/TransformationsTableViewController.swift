//
//  TransformationsTableViewController.swift
//  DragonBall-Practica
//
//  Created by Rodrigo Latorre on 31/07/22.
//

import UIKit

class TransformationsTableViewController: UITableViewController {
    
    var transformations: [Transformations] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transformations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.set(model: transformations[indexPath.row])
        
        return cell
    }
    
    func set(data: [Transformations]) {
        transformations = data
    }
    
}
