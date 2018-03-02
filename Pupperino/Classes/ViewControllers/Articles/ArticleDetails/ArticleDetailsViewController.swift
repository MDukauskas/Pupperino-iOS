//
//  ArticleDetailsViewController.swift
//  MVC SampleProject
//
//  Created by Admin on 15/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: BaseViewController, ArticleDetailsDataModelDelegate {
    
    // MARK: - Declarations
    private var dataModel: ArticleDetailsDataModel!
    private weak var delegate: ArticleDetailsDataModelDelegate?
    
    @IBOutlet private weak var scrollPanelView: UIView!
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    // MARK: - Methods -
    
    init(withArticle article: ArticleEntity) {
        super.init(nibName: nil, bundle: nil)
        
        dataModel = ArticleDetailsDataModel(withArticle: article, delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateWithArticle(dataModel.article)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI actions
    
    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
        dataModel.changeArticleFavouriteStatus()
    }
    
    // MARK: - ArticleDetailsDataModelDelegate
    
    func articleDetailsDataModelDidUpdateArticleFavouriteStatus(_ dataModel: ArticleDetailsDataModel) {
        updateFavouriteButton()
    }
    
    // MARK: - Helpers
    
    private func populateWithArticle(_ article: ArticleEntity) {
        
        articleImageView.sd_setImage(with: article.imageURL, placeholderImage: nil)
        titleLabel.text = article.title
        if let publishDate = article.publishDate {
            publishDateLabel.text = GenericTools.commonDateFormatter.string(from: publishDate)
        }
        descriptionLabel.text = article.description
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {

        switch dataModel.articleFavouriteStatus() {
            
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
