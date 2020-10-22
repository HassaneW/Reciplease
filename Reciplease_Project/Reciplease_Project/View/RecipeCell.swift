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
    
    var portions: Float? {
        didSet {
            guard let portions = portions else { return }
            portionLabel.text = "\(portions) p"
        }
    }
    
    var duration: Float? {
        didSet {
            guard let duration = duration, duration != 0 else {
                durationLabel.isHidden = true
                clockImageView.isHidden = true
                return
            }
            //1 Récupérer valeur API
            let convertedTime = "\(duration)"
            
            // Créer format dateFormatter
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH-mm-ss"
            timeFormatter.dateStyle = .medium
            
            // Créer format Date
            guard let time = timeFormatter.date(from: convertedTime) else { return }
           
            // Transformer la date en String afin que le label le récupére
            durationLabel.text = timeFormatter.string(from: time)
            
          return
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
        
        let portionImageView = UIImageView(image: UIImage(systemName: "chart.pie.fill"))
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
        
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.clipsToBounds = true
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeImage)
        
        //TODO: colorier une view avec un degrade UIView shadown (decoration et degradés)
        //1: contrainte sont bien
        let mainView = UIView()
        mainView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        mainView.layer.shadowRadius = 8
        mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.cornerRadius = 20
        mainView.translatesAutoresizingMaskIntoConstraints = false
               
        
        // pas besoin ?
        var contentsLayer: UIView = {
            let view = UIView()
            view.backgroundColor = .orange
            view.layer.cornerRadius = 20
            
            view.layer.shadowRadius = 8
            view.layer.shadowOffset = CGSize(width: 3, height: 3)
            view.layer.shadowOpacity = 0.5
      
            
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        contentView.addSubview(mainView)
        mainView.addSubview(contentsLayer)
        
        
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
            
            recipeImage.heightAnchor.constraint(equalToConstant: 121),
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: textStackView.trailingAnchor, multiplier: 1.5),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: textStackView.bottomAnchor, multiplier: 1.0),
            
            recipeInfoView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: recipeInfoView.trailingAnchor, multiplier: 1.0),
            
            // Constrains your mainView to the ViewController's view
            // shadowView doit prendre toute la largeur
            // largeur leading trailing
            // top bottom equal top bottom stack view ?
//            mainView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            mainView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            mainView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.5),
//            mainView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
//            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            mainView.topAnchor.constraint(equalTo: topAnchor),
//
            //mainView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.7),
            
            // Constrains your contentsLayer to the mainView
            contentsLayer.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            contentsLayer.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            contentsLayer.heightAnchor.constraint(equalTo: mainView.heightAnchor),
//            contentsLayer.widthAnchor.constraint(equalTo: mainView.widthAnchor)
            contentsLayer.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            contentsLayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentsLayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentsLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentsLayer.topAnchor.constraint(equalTo: textStackView.topAnchor)
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
