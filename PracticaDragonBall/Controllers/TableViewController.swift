//
//  TableViewController.swift
//  DragonBall-Practica
//
//  Created by Rodrigo Latorre on 14/07/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var heroes: [Hero] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        
        self.title = "Dragon Ball"
        
        guard let token = LocalDataModel.getToken() else {return}
        
        let heroesData = NetworkModel(token: token)
        
        heroesData.getHeroes { [weak self] heroes, error in
            guard let self = self else {return}
            self.heroes = heroes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        // Configure the cell...
        
        cell.set(model: heroes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailViewController()
        nextVC.set(model: heroes[indexPath.row])
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
