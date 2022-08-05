//
//  DetailViewController.swift
//  DragonBall-Practica
//
//  Created by Rodrigo Latorre on 14/07/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UITextView!

    private var hero: Hero?
    
    private var transformations: [Transformations] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let hero = hero else {
            return
        }
        self.title = hero.name
        
        self.heroName.text = hero.name
        self.heroDescription.text = hero.description
        self.heroImage.setImage(url: hero.photo)
    }
    
    @IBAction func onTransformationsButtonTap(_ sender: Any) {
        guard let token = LocalDataModel.getToken() else {return}
        
        let heroesData = NetworkModel(token: token)
        
        heroesData.getTransformations(id: hero?.id) { [weak self] transformations, error in
            if transformations.count < 1 {
                DispatchQueue.main.async {
                    self?.showAlert()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    let nextVC = TransformationsTableViewController()
                    nextVC.set(data: transformations)
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }

        }
        

    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Este personaje no tiene transformaciones", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func set(model: Hero) {
        hero = model
    }
    
}
