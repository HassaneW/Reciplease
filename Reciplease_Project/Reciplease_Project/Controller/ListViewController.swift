//
//  ListViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
import  Alamofire


class ListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients = "rice"
    var arrayData = Reciplease(recipe: Recipe(title: "", imageUrl: "", url: "", portions: 0, ingredients: [""], totalTime: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.getDataFromApi()
    }
    
    @IBAction func refreshData() {
        self.getDataFromApi()
    }
    
    func getDataFromApi() {
        
        
        NetworkService.shared.getRecipes(ingredients: ingredients) { [weak self] result in
            switch result {
            case .success(let reciplease):
                //print(reciplease)
                print("count : \(reciplease.recipes.count)")
                //                let firstRecipe = reciplease.recipes.first
                //                let ingredients = firstRecipe?.ingredients
                //                let title = firstRecipe?.title
                
                self?.arrayData = reciplease
                self?.tableView.reloadData()
                print(reciplease.recipes.first.debugDescription)
            case .failure(let error):
                print("Error fetching recipes \(error.localizedDescription)")
            }
        }
    }
    
}

extension ListViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayData.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TitleCell
       // cell.recipe = arrayData.recipes[indexPath.row]
        cell.displayData(recipe: self.arrayData.recipes[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.detailView) as? DetailViewController else { return }
        vc.data = self.arrayData.recipes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
