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

class EmptyView: UIView  {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "imageCuistot")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label
        titleLabel.text = "Sorry no recipes were found"
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.text = "Please try with different ingredients"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let contentStackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = UIStackView.spacingUseSystem
        contentStackView.alignment = .top
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
                        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                        contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                        contentStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
                        trailingAnchor.constraint(equalToSystemSpacingAfter: contentStackView.trailingAnchor, multiplier: 1.0),
        ])
    }
}

class ErrorView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "kitchenOne")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label
        titleLabel.text = "Sorry no recipes were found"
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.text = "Please try with different ingredients"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let contentStackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = UIStackView.spacingUseSystem
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            //contentStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
            //contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: -20),
            //topAnchor.constraint(equalTo: contentStackView.topAnchor),
            //contentStackView.topAnchor.constraint(equalTo: topAnchor),
            //imageView.heightAnchor.constraint(equalToConstant: 100),
              contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: contentStackView.trailingAnchor, multiplier: 1.0),
        ])
    }
}

class RecipesListViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipeMode: RecipeListMode
    var ingredients: String = ""
    var recipe: Recipe?
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyView = EmptyView()
    private let errorView = ErrorView() // TODO
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        title = recipeMode.title
        navigationItem.rightBarButtonItem = (recipeMode == .database) ? editButtonItem : nil
        
        view.backgroundColor = UIColor(named: "brown")
        
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(RecipeCell.self, forCellReuseIdentifier: Constants.Storyboard.recipeCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        errorView.isHidden = true
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
        loadingIndicator.startAnimating()
        NetworkService.shared.getRecipes(ingredients: ingredients) { [weak self] result in
            self?.loadingIndicator.stopAnimating()
            switch result {
            case .success(let reciplease) where reciplease.recipes.isEmpty:
                print("no recipes found")
                self?.emptyView.isHidden = false
                
            case .success(let reciplease):
                self?.tableView.isHidden = false
                self?.recipes = reciplease.recipes
                self?.tableView.reloadData()
            case .failure(let error):
                //TODO
                self?.errorView.isHidden = false
                print("Error fetching recipes \(error.localizedDescription)")
            }
        }
    }
    
    private func getRecipesFromDatabase() {
        do {
            recipes = try DatabaseService.shared.loadRecipes()
            if recipes.isEmpty {
                print("no favorites recipes found")
                emptyView.isHidden = false
                
            } else {
                tableView.isHidden = false
                tableView.reloadData()
            }
        } catch let error {
            errorView.isHidden = false
            print(error.localizedDescription)
            displayAlert(title: "Database Core Data error", message: "Cannot be download recipe")
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
                    //TODO: refresh not working on Edit nav bar
                    completionHandler(true)
                } catch let error {
                    print("Error deleting recipe: \(error.localizedDescription)")
                    completionHandler(false)
                    self.displayAlert(title: "Database Core Data error", message: "Cannot be download favorite recipe")
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


