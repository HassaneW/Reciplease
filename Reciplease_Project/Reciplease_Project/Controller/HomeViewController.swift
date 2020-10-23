//
//  HomeViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak private var textIngredientField: UITextField!
    @IBOutlet weak private var ingredientsTableView: UITableView!
    @IBOutlet weak private var searchButton: UIButton!
    @IBOutlet weak private var add : UIButton!
    @IBOutlet weak private var clear : UIButton!
    
    private var ingredientData: [String] = []
    private enum Constant {
        static let ingredientCellId = "ingredientsCell"
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        setupView()
    }
    // MARK: Action Methods
    @IBAction func addIngredient(_ sender: UIButton) {
        guard let textIngredient = textIngredientField.text, !textIngredient.isEmptyOrWhitespace else {
            print("invalid textfield value")
            return
        }
        ingredientData.append(textIngredient)
        textIngredientField.text = ""
        ingredientsTableView.reloadData()
    }
    @IBAction func clear(_ sender: Any) {
        ingredientData.removeAll()
        ingredientsTableView.reloadData()
    }
    @IBAction func searchRecipies(){
        // Tout réunir dans le guard let
        if ingredientData.count == 0 {
            return
        }
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.listViewController) as? ListViewController else { return }
        vc.ingredients = ingredientData.joined(separator: ",")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: Private Methods
    private func configureDelegate() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        textIngredientField.delegate = self
    }
    private func setupView() {
        clear.layer.cornerRadius = 10
        add.layer.cornerRadius = 10
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
    }
}
// MARK: - UITableView datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ingredientCellId, for: indexPath)
        cell.textLabel?.text = "- \(ingredientData[indexPath.row])"
        return cell
    }
}
// MARK: - UITextField delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
