//
//  StateView.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 23/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import UIKit

final class StateView: UIView  {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let contentStackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = UIStackView.spacingUseSystem
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: contentStackView.trailingAnchor, multiplier: 1.0),
        ])
    }
    
}
