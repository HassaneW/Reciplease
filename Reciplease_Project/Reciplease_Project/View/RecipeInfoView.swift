//
//  RecipeInfoView.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 26/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import UIKit

final class RecipeInfoView: UIView {
    
    // MARK: -  variables RecipeInfoView
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
            
            durationLabel.text = dateComponentsFormatter.string(from: Double(duration * 60))
        }
    }

    private enum Constant {
        static let padding: CGFloat = 5
        static let cornerRadius: CGFloat = 8
    }
    
    private let portionLabel = UILabel()
    private let durationLabel = UILabel()
    private let clockImageView = UIImageView(image: UIImage(systemName: "stopwatch.fill"))
    
    private var dateComponentsFormatter: DateComponentsFormatter {
        let dtc = DateComponentsFormatter()
        dtc.unitsStyle = .brief
        dtc.allowedUnits = [.hour, .minute]
        return dtc
    }
   
    // MARK: - init RecipeInfoView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - SetupView RecipeInfoView
    private func setupView() {
        backgroundColor = UIColor(named: "brown")
        
        layer.cornerRadius = Constant.cornerRadius
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        
        clockImageView.contentMode = .scaleAspectFit
        clockImageView.tintColor = UIColor.white
        clockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.textColor = .white
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let durationStackView = UIStackView(arrangedSubviews: [durationLabel, clockImageView])
        durationStackView.axis = .horizontal
        durationStackView.alignment = .fill
        durationStackView.distribution = .fill
        durationStackView.spacing = Constant.padding
        durationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let portionImageView = UIImageView(image: UIImage(systemName: "chart.pie.fill"))
        portionImageView.contentMode = .scaleAspectFit
        portionImageView.tintColor = UIColor.white
        portionImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        portionLabel.textColor = UIColor.white
        portionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let portionStackView = UIStackView(arrangedSubviews: [portionLabel, portionImageView])
        portionStackView.axis = .horizontal
        portionStackView.alignment = .fill
        portionStackView.distribution = .fill
        portionStackView.spacing = Constant.padding
        portionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStackView = UIStackView(arrangedSubviews: [durationStackView, portionStackView])
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = Constant.padding
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
