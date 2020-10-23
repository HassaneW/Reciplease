//
//  FavoriteViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
import CoreData// delete

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [NSManagedObject]()
    var ingredients = "rice"
    var recipes: [Recipe] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        getDataFromDatabase()
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
    @IBAction func refreshData() {
        self.getData()
    }*/
    func getDataFromDatabase() {
        //TODO: do catch
        
        // Faire apparaître toutes les donnés d'un tableau dans un playground
        
//        guard let recipeAll = try? DatabaseService.shared.loadRecipes() else { return }
//
//        for recipe in recipeAll {
//
//            let recipeTitle = recipe.title
//            let recipeUrl = recipe.url
//        }
        
        
        
        /*
         func getDataFromApi() {
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
             }
         }
         */
        
        /*
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            dataArray = try context.fetch(request) as! [NSManagedObject]
            if dataArray.count == 0 {
                return
            }
            var recipeArray = [Recipe]()
            for selectedData in dataArray {
                let recipe =
                    Recipe(title: selectedData.value(forKey: "title") as? String ?? "not Title",
                           imageUrl: selectedData.value(forKey: "imageUrl") as? String ?? "not Image",
                           url: selectedData.value(forKey: "url") as? String ?? "not url",
                           portions: selectedData.value(forKey: "portions") as? Int ?? 0,
                           ingredients: (selectedData.value(forKey: "ingredients") as? String ?? "not Ingredients").components(separatedBy: ","), totalTime: selectedData.value(forKey: "totalTime") as? Int ?? 0
                )
                recipeArray.append(recipe)
            }
            arrayRecipe = Reciplease(recipes: recipeArray)
            tableView.reloadData()
            
        } catch {
            
            print("Failed")
        }
 */
    }
    func deleteData(index : Int){
        /*
        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(dataArray[index])
            try context.save()
            self.getData()
            
        } catch {
            print("fail delete")
        }
        */
    }
}
extension FavoriteViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.arrayRecipe.recipes.count
        recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.cellID, for: indexPath) as! RecipeCell
//        cell.recipe = arrayRecipe.recipes[indexPath.row]
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailView) as? DetailViewController else { return }
//        detailVC.recipe = arrayRecipe.recipes[indexPath.row]
        detailVC.recipe = recipes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //    objects.remove(at: indexPath.row)
            //  tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteData(index: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
