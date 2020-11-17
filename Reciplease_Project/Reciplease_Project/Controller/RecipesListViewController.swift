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
    private let errorView = UIView() // TODO
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
        
        //Configure errorView
        
//        errorView.isHidden = true
//        errorView = UIView(frame: self.view.bounds)
//        errorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//        errorView.translatesAutoresizingMaskIntoConstraints = false
//        errorView.addSubview(labelCuistotText)
//        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // emptyView
//            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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




/*
 
 Error View and EmptyView
 //
 //  ViewController.swift
 //  ViewProgrammatically
 //
 //  Created by Wandianga hassane on 16/11/2020.
 //  Copyright © 2020 Wandianga hassane. All rights reserved.
 //
 
 import UIKit
 
 class ViewController: UIViewController {
 
 private let myView : UIView = {
 let myView = UIView()
 myView.translatesAutoresizingMaskIntoConstraints = false
 myView.backgroundColor = .link
 return myView
 }()
 
 let imageCuistotView : UIImageView = {
 var imageCuistotView = UIImageView()
 imageCuistotView.translatesAutoresizingMaskIntoConstraints = false
 imageCuistotView.contentMode = .scaleAspectFit
 imageCuistotView = UIImageView(image: UIImage(named: "imageCuistot"))
 
 return imageCuistotView
 }()
 
 
 let labelCuistotText : UILabel = {
 var labelCuistotText = UILabel()
 
 labelCuistotText.translatesAutoresizingMaskIntoConstraints = false
 //        imageCuistotView.contentMode = .scaleAspectFit
 //        imageCuistotView = UIImageView(image: UIImage(named: "imageCuistot"))
 labelCuistotText.backgroundColor = UIColor.black
 labelCuistotText.adjustsFontSizeToFitWidth = true
 labelCuistotText.contentMode = .center
 labelCuistotText.numberOfLines = 0
 labelCuistotText.text = "Hello Les Cuistots"
 labelCuistotText.textColor = UIColor.red
 labelCuistotText.font.withSize(15)
 
 return labelCuistotText
 }()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 view.addSubview(myView)
 //        myView.addSubview(imageCuistotView)
 myView.addSubview(labelCuistotText)
 addConstraints()
 
 }
 
 func addConstraints() {
 
 var constraints = [NSLayoutConstraint]()
 // Add myView
 constraints.append(myView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
 constraints.append(myView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
 constraints.append(myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
 constraints.append(myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
 
 // Add imageCuistotView
 
 //        constraints.append(imageCuistotView.leadingAnchor.constraint(equalTo: myView.leadingAnchor))
 //        constraints.append(imageCuistotView.trailingAnchor.constraint(equalTo: myView.trailingAnchor))
 //         constraints.append(imageCuistotView.topAnchor.constraint(equalTo: myView.topAnchor))
 //        constraints.append(imageCuistotView.bottomAnchor.constraint(equalTo: myView.bottomAnchor))
 
 // Add imageCuistotView
 
 constraints.append(labelCuistotText.leadingAnchor.constraint(equalTo: myView.leadingAnchor))
 constraints.append(labelCuistotText.trailingAnchor.constraint(equalTo: myView.trailingAnchor))
 constraints.append(labelCuistotText.topAnchor.constraint(equalTo: myView.topAnchor))
 constraints.append(labelCuistotText.bottomAnchor.constraint(equalTo: myView.bottomAnchor))
 
 // Activate
 NSLayoutConstraint.activate(constraints)
 
 
 }
 }
 
 
 */

