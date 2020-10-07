//
//  RecipeCell.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import UIKit

final class RecipeInfoView: UIView {
    
    var recipe: Recipe? {
        
        // portions
        didSet {
            guard let time = recipe?.totalTime else {
                // diration
                return
            }
            durationLabel.text = "\(recipe?.totalTime ?? 0) min"
            // like
        }
    }
    
    private let durationLabel = UILabel()
    // like
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        // lieStackView = 1 image view / 1 uilabel
        // durationStackView = 1 iamge view / 1 uilabel
    // contentStackView = 2 = Puis ajouter les contraintes
        
        durationLabel.textColor = UIColor.label
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            durationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
}

class RecipeCell: UITableViewCell {
    
    var recipe: Recipe? {
        didSet {
            recipeName.text = recipe?.title
            //comment convertir un tableau de string en une string separer par des virgules
            recipeIngredients.text = recipe?.ingredients.first
            recipeInfoView.recipe = recipe
            setupImage()
        }
    }
    
    private let recipeName = UILabel()
    private let recipeIngredients = UILabel()
    private let recipeImage = UIImageView()
    private let recipeInfoView = RecipeInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        
        recipeImage.contentMode = .scaleAspectFit
        recipeImage.clipsToBounds = true
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeImage)
        
        recipeName.textColor = UIColor.label
        recipeName.translatesAutoresizingMaskIntoConstraints = false
        
        recipeIngredients.textColor = UIColor.secondaryLabel
        recipeIngredients.translatesAutoresizingMaskIntoConstraints = false
        
        recipeInfoView.backgroundColor = UIColor.brown
        recipeInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeInfoView)

        let textStackView = UIStackView(arrangedSubviews: [recipeName, recipeIngredients])
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fill
        textStackView.spacing = UIStackView.spacingUseDefault
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            recipeImage.heightAnchor.constraint(equalToConstant: 120),
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: textStackView.trailingAnchor, multiplier: 1.5),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: textStackView.bottomAnchor, multiplier: 1.0),
            
            recipeInfoView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: recipeInfoView.trailingAnchor, multiplier: 1.0),
            recipeInfoView.heightAnchor.constraint(equalToConstant: 60),
            recipeInfoView.widthAnchor.constraint(equalToConstant: 60)
            
//            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0)
            
           
        ])
    }
    
    private func setupImage() {
        guard let recipeImageURLString = recipe?.imageUrl,
            let recipeImageURL = URL(string: recipeImageURLString)  else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: recipeImageURL) {
                let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    self?.recipeImage.image = image
                }
            }
        }
    }
}
// tab bar search / favoris
// search
// lecran resultats avec custom cell
// l ecran detail resultats

// changer le nom
//RecipeCell
class TitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    //    func setData(reciplease: Reciplease) {
    //        titleLabel.text = reciplease.hits[0].recipe.title
    //    }
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayData(recipe : Recipe) {
        titleLabel.text = recipe.title
        //descriptionLabel.text = recipe.url
        //timeLabel.text = "Time : \(recipe.totalTime)"
        ingredientsLabel.text = recipe.ingredients.first
        
        guard let urlIcon = URL(string: recipe.imageUrl)  else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlIcon) {
                let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    self?.imgView.image = image
                }
            }
        }
    }
}
