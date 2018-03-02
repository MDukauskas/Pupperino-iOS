//
//  ArticleListViewController.swift
//  MVC SampleProject
//
//  Created by Admin on 13/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class ArticleListViewController: BaseViewController, ArticleListDataModelDelegate, ArticleListTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Declarations
    var dataModel: ArticleListDataModel!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private weak var refreshControl: UIRefreshControl!
    
    // MARK: - Methods -
    
    init(withSource source: SourceEntity) {
        super.init(nibName: nil, bundle: nil)
        
        dataModel = ArticleListDataModel(withSource: source, delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        KeyboardAvoiding.avoidingView = tableView
        tableView.registerCellNib(withType: ArticleListTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero) // To hide redundant separators
        
        searchBar.text = dataModel.searchText
        searchBar.autocapitalizationType = .none
        
        let sortBarButtonItem = UIBarButtonItem(title: "Sort".localized, style: .plain, target: self, action: #selector(didTapSortButton))
        navigationItem.rightBarButtonItem = sortBarButtonItem
        
        title = dataModel.source.name
        
        setupRefreshControl()
        
        dataModel.loadDataIfNecessary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Views
    
    private func setupRefreshControl() {
        
        guard self.refreshControl == nil else {
            log("WARNING! refreshControl is already set")
            return
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didTriggerRefreshControl(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    // MARK: - UI actions
    
    @objc private func didTriggerRefreshControl(_ refreshControl: UIRefreshControl) {
        dataModel.loadDataIfNecessary()
        refreshControl.endRefreshing()
    }
    
    @objc private func didTapSortButton() {
        
        let alertController = UIAlertController(title: "", message: "Select sort order".localized, preferredStyle: .actionSheet)
        
        let sortByPublishDateAction = UIAlertAction(title: "Publish date".localized, style: .default) { [weak self] (_: UIAlertAction) in
            self?.dataModel.setSortType(.publishDate)
        }
        alertController.addAction(sortByPublishDateAction)
        
        let sortByAuthorAction = UIAlertAction(title: "Author".localized, style: .default) { [weak self] (_: UIAlertAction) in
            self?.dataModel.setSortType(.author)
        }
        alertController.addAction(sortByAuthorAction)
        
        let sortByTitleAction = UIAlertAction(title: "Title".localized, style: .default) { [weak self] (_: UIAlertAction) in
            self?.dataModel.setSortType(.title)
        }
        alertController.addAction(sortByTitleAction)
        
        let sortByNoneAction = UIAlertAction(title: "None".localized, style: .default) { [weak self] (_: UIAlertAction) in
            self?.dataModel.setSortType(nil)
        }
        alertController.addAction(sortByNoneAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    private func navigateToArticleDetails(_ article: ArticleEntity) {
        
        let articleDetailsViewController = ArticleDetailsViewController(withArticle: article)
        navigationController?.pushViewController(articleDetailsViewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let articleListTableViewCell: ArticleListTableViewCell = tableView.dequeueReusableCell() else {
            log("WARNING! could not deque cell with type \(ArticleListTableViewCell.self) for indexPath \(indexPath)")
            return UITableViewCell()
        }

        let article: ArticleEntity? = dataModel.articleAtIndex(indexPath.row)
        var favouriteStatus: ArticleFavouriteStatus = .notFavourite
        if let article = article {
            favouriteStatus = dataModel.favouriteStatusOfArticle(article)
        }
        
        articleListTableViewCell.populateWithArticle(article, articleFavouriteStatus: favouriteStatus, delegate: self)
        return articleListTableViewCell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let articleListTableViewCell: ArticleListTableViewCell = tableView.cellForRow(at: indexPath) as? ArticleListTableViewCell else {
            log("WARNING! unexpected cell at indexpath \(indexPath)")
            return
        }
        
        guard let article = articleListTableViewCell.article else {
            log("WARNING! source not set for cell \(articleListTableViewCell)")
            return
        }
        
        navigateToArticleDetails(article)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataModel.setSearchText(searchText)
        
        searchBar.setShowsCancelButton(!searchText.isEmpty, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        dataModel.setSearchText("")
    }
    
    // MARK: - ArticleListDataModelDelegate
    
    func articleListDataModelStartedDataLoading(_ dataModel: ArticleListDataModel) {
        showActivityIndicator()
    }
    
    func articleListDataModelFinishedDataLoading(_ dataModel: ArticleListDataModel) {
        tableView.reloadData()
        hideActivityIndicator()
    }
    
    func articleListDataModelFailedDataLoading(_ dataModel: ArticleListDataModel) {
        hideActivityIndicator()
        showAlertForGenericNetworkError()
    }
    
    func articleListDataModelDidUpdateArticleList(_ dataModel: ArticleListDataModel) {
        tableView.reloadData()
        
        if tableView.visibleCells.isEmpty == false {
            // UI fix: if tableview content offset, was not zero, would display half of cell in some cases.
            //         So scroll to top, to avoid this issue
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func articleListDataModel(_ dataModel: ArticleListDataModel, didUpdateFavouriteStatusForArticle article: ArticleEntity) {
        
        guard let articleIndex = dataModel.articleList.index(of: article) else {
            return
        }
        
        guard let articleCell = tableView.cellForRow(at: IndexPath(row: articleIndex, section: 0)) as? ArticleListTableViewCell else {
            return
        }
        
        articleCell.updateArticleFavouriteStatus(dataModel.favouriteStatusOfArticle(article))
    }
    
    // MARK: - ArticleListTableViewCellDelegate
    
    func articleListTableViewCellDidTapFavouriteButton(_ cell: ArticleListTableViewCell) {
        
        guard let article = cell.article else {
            log("WARNING: article is nil in cell \(cell)")
            return
        }
        
        dataModel.changeFavouriteStatusForArticle(article)
    }
}
