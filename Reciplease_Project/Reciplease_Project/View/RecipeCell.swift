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
    
    var portions: Int? {
        didSet {
            guard let portions = portions else { return }
            portionLabel.text = "\(portions) p"
        }
    }
    
    var duration: Int? {
        didSet {
            guard let duration = duration, duration != 0 else {
                durationLabel.isHidden = true
                clockImageView.isHidden = true
                return
            }
            durationLabel.text = "\(duration) m" //TODO: Confirmer que c'est en min timeFormatter
        }
    }
    
    private let portionLabel = UILabel()
    private let durationLabel = UILabel()
    private let clockImageView = UIImageView(image: UIImage(systemName: "stopwatch.fill"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.brown
        
        clockImageView.contentMode = .scaleAspectFit
        clockImageView.tintColor = UIColor.label
        clockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.textColor = UIColor.label
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let durationStackView = UIStackView(arrangedSubviews: [durationLabel, clockImageView])
        durationStackView.axis = .horizontal
        durationStackView.alignment = .fill
        durationStackView.distribution = .fill
        durationStackView.spacing = UIStackView.spacingUseDefault
        durationStackView.translatesAutoresizingMaskIntoConstraints = false

        let portionImageView = UIImageView(image: UIImage(systemName: "chart.pie.fill")) //TODO: find a better image
        portionImageView.contentMode = .scaleAspectFit
        portionImageView.tintColor = UIColor.label
        portionImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        portionLabel.textColor = UIColor.label
        portionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let portionStackView = UIStackView(arrangedSubviews: [portionLabel, portionImageView])
        portionStackView.axis = .horizontal
        portionStackView.alignment = .fill
        portionStackView.distribution = .fill
        portionStackView.spacing = UIStackView.spacingUseDefault
        portionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStackView = UIStackView(arrangedSubviews: [durationStackView, portionStackView])
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = UIStackView.spacingUseDefault
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
            contentStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: contentStackView.trailingAnchor, multiplier: 1.0),
            bottomAnchor.constraint(equalToSystemSpacingBelow: contentStackView.bottomAnchor, multiplier: 1.0)
        ])
    }
}

final class RecipeCell: UITableViewCell {
    
    var recipe: Recipe? {
        didSet {
            recipeName.text = recipe?.title
            //TODO: comment convertir un tableau de string en une string separer par des virgules
            recipeIngredients.text = recipe?.ingredients.first
            recipeInfoView.duration = recipe?.totalTime
            recipeInfoView.portions = recipe?.portions
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
        
        //TODO: UIView shadown (decoration et degradés)
        
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.clipsToBounds = true
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeImage)
        
        recipeName.textColor = UIColor.label
        recipeName.translatesAutoresizingMaskIntoConstraints = false
        
        recipeIngredients.textColor = UIColor.secondaryLabel
        recipeIngredients.translatesAutoresizingMaskIntoConstraints = false
        
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
            recipeImage.heightAnchor.constraint(equalToConstant: 120.5),
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: textStackView.trailingAnchor, multiplier: 1.5),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: textStackView.bottomAnchor, multiplier: 1.0),
            
            recipeInfoView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: recipeInfoView.trailingAnchor, multiplier: 1.0)
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
