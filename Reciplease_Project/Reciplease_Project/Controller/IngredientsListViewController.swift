//
//  IngredientsListViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 02/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit


enum DataFrom {
    case Api
    case Database
}

class IngredientsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    var ingredients: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.dataSource = self
        //        tableView.delegate = self
        //        getDataFrom()
        
        // Do any additional setup after loading the view.
        
        func getDataFrom() {
            
            var dataFrom = DataFrom.Api
            
            if dataFrom == DataFrom.Api {
                NetworkService.shared.getRecipes(ingredients: ingredients) { [weak self] result in
                    switch result {
                    case .success(let reciplease):
                        //print(reciplease)
                        print("count : \(reciplease.recipes.count)")
                        self?.recipes = reciplease.recipes
                        
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error fetching recipes \(error.localizedDescription)")
                    }
                }
                
            } else {
                
                do {
                    recipes = try DatabaseService.shared.loadRecipes()
                    tableView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Table Vied viez delegqtes
extension IngredientsListViewController: UITableViewDelegate, UITableViewDataSource {
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
}

