//
//  IngredientsListViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 02/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit

// MARK: - Enum RecipeListeMode

enum RecipeListMode {
    case api
    case database
    
    var title: String {
        switch self {
        case .api:
            return "Search"
        case .database:
            return "Favorites"
        }
    }
}

class RecipesListViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipeMode: RecipeListMode
    var ingredients: String = ""
    
    private let tableView = UITableView()
    private var recipes: [Recipe] = []
    
    // MARK: - Init
    
    init(recipeMode: RecipeListMode) {
        self.recipeMode = recipeMode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        self.recipeMode = .database
        super.init(coder: coder)
    }
        
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getRecipes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recipeMode == .database {
            getRecipesFromDatabase()
        }
    }
    // MARK: - Private methods
    
    private func setupView() {
        title = recipeMode.title
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(RecipeCell.self, forCellReuseIdentifier: Constants.Storyboard.recipeCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - private function
    
    private func getRecipes() {
        switch recipeMode {
        case .api:
            getRecipesFromApi()
        case .database:
            getRecipesFromDatabase()
        }
    }
    private func getRecipesFromApi() {
        NetworkService.shared.getRecipes(ingredients: ingredients) { [weak self] result in
            switch result {
            case .success(let reciplease):
                self?.recipes = reciplease.recipes
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error fetching recipes \(error.localizedDescription)")
            }
        }
    }
    private func getRecipesFromDatabase() {
        do {
            recipes = try DatabaseService.shared.loadRecipes()
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
            //TODO: display error alert
        }
    }
}

// MARK: - Table View delegate

extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailView) as? DetailViewController else { return }
        detailVC.recipe = recipes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard recipeMode == .database else { return nil }
    
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") { (action, view, completionHandler) in
                let recipeToDelete = self.recipes[indexPath.row]
                do {
                    try DatabaseService.shared.delete(recipe: recipeToDelete)
                    self.tableView.reloadData()
                    completionHandler(true)
                } catch let error {
                    print("Error deleting recipe: \(error.localizedDescription)")
                    //TODO: Display alert
                    completionHandler(false)
                }
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Table View datasource

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.recipeCellId, for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.row]
        return cell
    }
}
