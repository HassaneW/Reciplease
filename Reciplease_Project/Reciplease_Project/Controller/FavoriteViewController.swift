//
//  FavoriteViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit

// favorritelistvc
// listviewcontroller

// listviewc
//recipelist

class FavoriteViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        getDataFromDatabase()
    }
    
    func getDataFromDatabase() {
        do {
            recipes = try DatabaseService.shared.loadRecipes()
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Table Vied viez delegqtes
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.recipeCellId, for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailView) as? DetailViewController else { return }
        detailVC.recipe = recipes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //TODO: Swipe to delete recipes
}
