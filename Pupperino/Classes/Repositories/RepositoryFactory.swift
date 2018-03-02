//
//  RepositoryFactory.swift
//  MVC SampleProject
//
//  Created by Admin on 02/03/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import Foundation

class RepositoryFactory {
    
    // MARK: - Declarations
    static var repository: RepositoryProtocol = {
        if #available(iOS 11.0, *) {
            return RealmRepository.sharedRepository
        } else {
            return FMDBRepository.sharedRepository
        }
    } ()
}
