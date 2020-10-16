//
//  DetailViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getDirectonButton: UIButton!
    @IBOutlet weak var recipeInfoView: RecipeInfoView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var recipe: Recipe?
    
    //TODO: a bouger vers le constants global ?
    private enum Constant {
        static let ingredientCellId = "ingredientsCell"
    }

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
        getDirectonButton.layer.cornerRadius = 20
        //getDirectonButton.backgroundColor = #colorLiteral(red: 0.3419374526, green: 0.5654733181, blue: 0.3804852366, alpha: 1)
        
        //TODO: A faire sur le storyboard
        //titleLabel.backgroundColor = #colorLiteral(red: 0.3419374526, green: 0.5654733181, blue: 0.3804852366, alpha: 1)
        
        let button1 = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favoriteTapped)) // action:#selector(Class.MethodName) for swift 3
        navigationItem.rightBarButtonItem  = button1

        titleLabel.text = recipe?.title
        recipeInfoView.duration = recipe?.totalTime
        recipeInfoView.portions = recipe?.portions
        setupImage()
        tableView.reloadData()
        
        //tableView.register(RecipeCell.self, forCellReuseIdentifier: Constant.ingredientCellId)
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
    }
    
    private func setupImage() {
        guard let recipeImageURLString = recipe?.imageUrl,
            let recipeImageURL = URL(string: recipeImageURLString)  else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: recipeImageURL) {
                let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                    self?.recipeImageView.contentMode = .scaleToFill //TODO: a changer vers le storyboard
                }
            }
        }
    }
    
    @objc func favoriteTapped(){
        // recupe : fichier constante
        // CoreDataManager.saveRecipe(recipe)
        // func saveRecipe(_ recipe: Recipe?)
        // func loadRecipies() -> [Recipe]
        // func deleteRecipe(_ recipe: Recipe?)
        
        /*let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        
//        newUser.setValue(data.title, forKey: "title")
//        newUser.setValue(data.imageUrl, forKey: "imageUrl")
//        newUser.setValue(data.url, forKey: "url")
//        newUser.setValue(data.portions, forKey: "portions")
//        newUser.setValue(data.ingredients.joined(separator: ","), forKey: "ingredients")
//        newUser.setValue(data.totalTime, forKey: "totalTime")
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Failed saving")
        }
 */
    }
    
    @IBAction func getDirection(sender: UIButton) {
        guard let recipeURLString = recipe?.url,
            let recipeURL = URL(string: recipeURLString) else {
                return
        }
        let safariVC = SFSafariViewController(url: recipeURL)
        present(safariVC, animated: true, completion: nil)
    }
}

extension DetailViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ingredientCellId, for: indexPath)
        cell.textLabel?.text = "- \(recipe?.ingredients[indexPath.row] ?? "")"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
