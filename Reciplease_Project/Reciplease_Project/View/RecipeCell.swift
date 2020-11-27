//
//  RecipeCell.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import UIKit

// TODO: deplacer dans sa propre classe
//final class RecipeInfoView: UIView {
//
//    // MARK: -  variables RecipeInfoView
//    var portions: Float? {
//        didSet {
//            guard let portions = portions else { return }
//            portionLabel.text = "\(portions) p"
//        }
//    }
//
//    var duration: Float? {
//        didSet {
//            guard let duration = duration, duration != 0 else {
//                durationLabel.isHidden = true
//                clockImageView.isHidden = true
//                return
//            }
//
//            durationLabel.text = dateComponentsFormatter.string(from: Double(duration * 60))
//        }
//    }
//
//
//    private enum Constant {
//        static let padding: CGFloat = 5
//        static let cornerRadius: CGFloat = 8
//    }
//
//    private let portionLabel = UILabel()
//    private let durationLabel = UILabel()
//    private let clockImageView = UIImageView(image: UIImage(systemName: "stopwatch.fill"))
//
//    private var dateComponentsFormatter: DateComponentsFormatter {
//        let dtc = DateComponentsFormatter()
//        dtc.unitsStyle = .brief
//        dtc.allowedUnits = [.hour, .minute]
//        return dtc
//    }
//
//    // MARK: - init RecipeInfoView
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    // MARK: - SetupView RecipeInfoView
//    private func setupView() {
//        backgroundColor = UIColor(named: "brown")
//
//        layer.cornerRadius = Constant.cornerRadius
//        layer.borderColor = UIColor.white.cgColor
//        layer.borderWidth = 1
//
//        clockImageView.contentMode = .scaleAspectFit
//        clockImageView.tintColor = UIColor.white
//        clockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        clockImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        durationLabel.textColor = .white
//        durationLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let durationStackView = UIStackView(arrangedSubviews: [durationLabel, clockImageView])
//        durationStackView.axis = .horizontal
//        durationStackView.alignment = .fill
//        durationStackView.distribution = .fill
//        durationStackView.spacing = Constant.padding
//        durationStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        let portionImageView = UIImageView(image: UIImage(systemName: "chart.pie.fill"))
//        portionImageView.contentMode = .scaleAspectFit
//        portionImageView.tintColor = UIColor.white
//        portionImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//
//        portionLabel.textColor = UIColor.white
//        portionLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let portionStackView = UIStackView(arrangedSubviews: [portionLabel, portionImageView])
//        portionStackView.axis = .horizontal
//        portionStackView.alignment = .fill
//        portionStackView.distribution = .fill
//        portionStackView.spacing = Constant.padding
//        portionStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        let contentStackView = UIStackView(arrangedSubviews: [durationStackView, portionStackView])
//        contentStackView.axis = .vertical
//        contentStackView.alignment = .fill
//        contentStackView.distribution = .fill
//        contentStackView.spacing = Constant.padding
//        contentStackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(contentStackView)
//
//        NSLayoutConstraint.activate([
//            contentStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
//            contentStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
//            trailingAnchor.constraint(equalToSystemSpacingAfter: contentStackView.trailingAnchor, multiplier: 1.0),
//            bottomAnchor.constraint(equalToSystemSpacingBelow: contentStackView.bottomAnchor, multiplier: 1.0)
//        ])
//    }
//}



final class RecipeCell: UITableViewCell {
    
    // MARK: - variables RecipeCell
    var recipe: Recipe? {
        didSet {
            recipeName.text = recipe?.title
            recipeIngredients.text = recipe?.ingredients.joined(separator: ", ")
            recipeInfoView.duration = recipe?.totalTime
            recipeInfoView.portions = recipe?.portions
            setupImage()
        }
    }
    lazy var gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.cyan.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()
    
    private let recipeName = UILabel()
    private let recipeIngredients = UILabel()
    private let recipeImage = UIImageView()
    private let recipeInfoView = RecipeInfoView()
    
    
    // MARK: - init RecipeCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - SetupView RecipeCell
    
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        
        recipeImage.contentMode = .scaleAspectFill
        recipeImage.clipsToBounds = true
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recipeImage)
        
        
        let gradientView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gradientView)
        
        recipeName.textColor = UIColor.label
        recipeName.translatesAutoresizingMaskIntoConstraints = false
        
        recipeIngredients.numberOfLines = 1
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
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: textStackView.topAnchor)
        ])
    }
    
    // MARK: - setupImage
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

// MARK: - UITableViewCell
class TitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - displayData
    func
        displayData(recipe : Recipe) {
        titleLabel.text = recipe.title
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

