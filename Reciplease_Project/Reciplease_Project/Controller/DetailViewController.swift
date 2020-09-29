//
//  DetailViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgView : UIImageView!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var recipe: Recipe?
       
       var data = Recipe(title: "", imageUrl: "", url: "", portions: 0, ingredients: [""], totalTime: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favoriteTapped)) // action:#selector(Class.MethodName) for swift 3
                self.navigationItem.rightBarButtonItem  = button1
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                titleLabel.text = data.title
                guard let urlIcon = URL(string: data.imageUrl)  else { return }
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: urlIcon) {
                        let image = UIImage.init(data: data)
                        DispatchQueue.main.async {
                            self?.imgView.image = image
                            self?.imgView.contentMode = .scaleToFill
                        }
                    }
                }
                // Do any additional setup after loading the view.
            }
            
            @objc func favoriteTapped(){
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                
                // recupe : fichier constante
                newUser.setValue(data.title, forKey: "title")
                newUser.setValue(data.imageUrl, forKey: "imageUrl")
                newUser.setValue(data.url, forKey: "url")
                newUser.setValue(data.portions, forKey: "portions")
                newUser.setValue(data.ingredients.joined(separator: ","), forKey: "ingredients")
                newUser.setValue(data.totalTime, forKey: "totalTime")
                
                do {
                    
                    try context.save()
                    
                } catch {
                    
                    print("Failed saving")
                }
            }
            
            func getDirection(sender: UIButton) {
                
            }
        }

        extension DetailViewController :UITableViewDelegate, UITableViewDataSource {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                self.data.ingredients.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                // identifnat unique
        //        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.cellID, for: indexPath) as! TitleCell
        //        cell.textLabel?.text = "- \(self.data.ingredients[indexPath.row])"
                //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TitleCell
                //        cell.titleLabel.text = "- \(self.data.ingredients[indexPath.row])"
                //return cell
                return UITableViewCell()
            }
        }
