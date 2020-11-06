//
//  DetailViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
import CoreData //delete
import SafariServices

class DetailViewController: UIViewController {
    @IBOutlet weak var recipeImageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getDirectonButton: UIButton!
    @IBOutlet weak var recipeInfoView: RecipeInfoView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var recipe: Recipe?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupView()
    }
    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupView() {
        getDirectonButton.layer.cornerRadius = 10
        titleLabel.text = recipe?.title
        recipeInfoView.duration = recipe?.totalTime
        recipeInfoView.portions = recipe?.portions
        setupFavoriteButton()
        setupImage()
        tableView.reloadData()
    }
    private func setupFavoriteButton() {
        // TODO: check the state properly
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: isFavorite ? "star.fill" : "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped))
    }
    private func setupImage() {
        guard let recipeImageURLString = recipe?.imageUrl,
            let recipeImageURL = URL(string: recipeImageURLString)  else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: recipeImageURL) {
                let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                }
            }
        }
    }
    // For testing purposes
    var isFavorite = false
    @objc
    private func favoriteTapped() {
        // checker si la recette est en favoris get d
        // comment savoir si faut rajouter ou supprimer ?
        if isFavorite {
            do {
                try deleteFromFavorites()
            } catch let error {
                print(error.localizedDescription)
                factorisationErrorMessage(messageError: "Cannot delete recipe")
            }
        } else {
            do {
                try addToFavorites()
            } catch let error {
                print(error.localizedDescription)
                factorisationErrorMessage(messageError: "Unable to add recipe")
            }
        }
        isFavorite.toggle()
        setupFavoriteButton()
        
    }
    @IBAction func getDirection(sender: UIButton) {
        guard let recipeURLString = recipe?.url,
            let recipeURL = URL(string: recipeURLString) else {
                return
        }
        let safariVC = SFSafariViewController(url: recipeURL)
        present(safariVC, animated: true, completion: nil)
    }
    private func addToFavorites() throws {
        guard let recipe = recipe else { return }
        do { try DatabaseService.shared.save(recipe: recipe) }
        catch let error { throw error }
    }
    private func deleteFromFavorites() throws {
        guard let recipe = recipe else { return  }
        do { try DatabaseService.shared.delete(recipe: recipe) }
        catch let error { throw error }
    }
    // TODO: afficher une alert avec le message ... message params
    private func factorisationErrorMessage(messageError: String) {
        let alertVC = UIAlertController(title: "Recette local Database", message: messageError, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
extension DetailViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipe?.ingredients.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.ingredientsCellId, for: indexPath)
        cell.textLabel?.text = "- \(recipe?.ingredients[indexPath.row] ?? "")"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
