//
//  SourceListTableViewCell.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class SourceListTableViewCell: UITableViewCell {

    // MARK: - Declaration
    private(set) var source: SourceEntity?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Public
    
    func populateWithSource(_ source: SourceEntity?) {
        resetCell()
        
        guard let source = source else {
            log("WARNING! source is nil")
            return
        }
        self.source = source
        
        titleLabel.text = source.name
        descriptionLabel.text = source.description
    }
    
    // MARK: - Helpers
    
    private func resetCell() {
        source = nil
        
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}
