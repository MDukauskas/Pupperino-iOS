//
//  ArticleListTableViewCell.swift
//  MVC SampleProject
//
//  Created by Admin on 15/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

import SDWebImage

protocol ArticleListTableViewCellDelegate: class {
    
    func articleListTableViewCellDidTapFavouriteButton(_ cell: ArticleListTableViewCell)
}

class ArticleListTableViewCell: UITableViewCell {
    
    // MARK: - Declarations
    private(set) var article: ArticleEntity?
    private weak var delegate: ArticleListTableViewCellDelegate?
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Public
    
    func populateWithArticle(_ article: ArticleEntity?, articleFavouriteStatus: ArticleFavouriteStatus, delegate: ArticleListTableViewCellDelegate?) {
        resetCell()
        
        self.article = article
        self.delegate = delegate
        
        guard let article = article else {
            log("WARNING! article is nil")
            return
        }
        
        titleLabel.text = article.title
        authorLabel.text = article.authorName
        descriptionLabel.text = article.description
        if let publishDate = article.publishDate {
            publishDateLabel.text = GenericTools.commonDateFormatter.string(from: publishDate)
        }
        articleImageView.sd_setImage(with: article.imageURL, placeholderImage: nil)
        updateArticleFavouriteStatus(articleFavouriteStatus)
    }
    
    func updateArticleFavouriteStatus(_ articleFavouriteStatus: ArticleFavouriteStatus) {
        updateFavoriteButtonWithStatus(articleFavouriteStatus)
    }
    
    // MARK: - UI actions
    
    @IBAction private func didTapFavouriteButton(_ sender: UIButton) {
        
        delegate?.articleListTableViewCellDidTapFavouriteButton(self)
    }
    
    // MARK: - Helpers
    
    private func resetCell() {
        article = nil
        delegate = nil
        
        titleLabel.text = ""
        authorLabel.text = ""
        descriptionLabel.text = ""
        publishDateLabel.text = ""
        
        articleImageView.sd_cancelCurrentImageLoad()
        articleImageView.image = nil
        
        updateFavoriteButtonWithStatus(.notFavourite)
    }
    
    private func updateFavoriteButtonWithStatus(_ articleFavouriteStatus: ArticleFavouriteStatus) {
        
        switch articleFavouriteStatus {
            
        case .notFavourite:
            favouriteButton.isEnabled = true
            favouriteButton.isSelected = false
            
        case .favourite:
            favouriteButton.isEnabled = true
            favouriteButton.isSelected = true
            
        case .favouriteStatusIsChanging:
            favouriteButton.isEnabled = false
            favouriteButton.isSelected = false
        }
    }
}
