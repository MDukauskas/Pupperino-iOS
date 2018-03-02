//
//  SourceListViewController.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class SourceListViewController: BaseViewController, SourceListDataModelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Declarations
    private var dataModel: SourceListDataModel!
    
    @IBOutlet private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!
    
    // MARK: - Methods -
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        dataModel = SourceListDataModel(withDelegate: self)
        tabBarItem.title = "Articles".localized
        tabBarItem.image = #imageLiteral(resourceName: "tabbar_news_icon")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(withType: SourceListTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero) // To hide redundant separators
        
        setupRefreshControl()
        
        dataModel.loadDataIfNecessary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    private func navigateToArticleListWithSource(_ source: SourceEntity) {
        // TODO: discuss cheking for nav. controller (printing error, etc.)
        
        let articleListViewController = ArticleListViewController(withSource: source)
        navigationController?.pushViewController(articleListViewController, animated: true)
    }
    
    // MARK: - UI actions
    
    @objc private func didTriggerRefreshControl(_ refreshControl: UIRefreshControl) {
        dataModel.loadDataIfNecessary()
        refreshControl.endRefreshing()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.sourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sourceListTableViewCell: SourceListTableViewCell = tableView.dequeueReusableCell() else {
            log("WARNING! could not deque cell with type \(SourceListTableViewCell.self) for indexPath \(indexPath)")
            return UITableViewCell()
        }
        
        sourceListTableViewCell.populateWithSource(dataModel.sourceAtIndex(indexPath.row))
        return sourceListTableViewCell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sourceListTableViewCell: SourceListTableViewCell = tableView.cellForRow(at: indexPath) as? SourceListTableViewCell else {
            log("WARNING! unexpected cell at indexpath \(indexPath)")
            return
        }
        
        guard let source = sourceListTableViewCell.source else {
            log("WARNING! source not set for cell \(sourceListTableViewCell)")
            return
        }
        
        navigateToArticleListWithSource(source)
    }
    
    // MARK: - SourceListDataModelDelegate
    
    func sourceListDataModelStartedDataLoading(_ dataModel: SourceListDataModel) {
        showActivityIndicator()
    }
    
    func sourceListDataModelFinishedDataLoading(_ dataModel: SourceListDataModel) {
        tableView.reloadData()
        hideActivityIndicator()
    }
    
    func sourceListDataModelFailedDataLoading(_ dataModel: SourceListDataModel) {
        hideActivityIndicator()
        showAlertForGenericNetworkError()
    }
    
    // MARK: - Helpers
    
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
}
