//
//  BottomBar.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 04/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit

protocol BottomBarDelegate {
    func touchUpInsideVetMessages()
    func touchUpInsideActivityTracker()
    func touchUpInsideVetList()
    func touchUpInsideClinicsList()
}
class BottomBar: UIView {
    @IBOutlet weak var contentView: UIView!
    
    var delegate: BottomBarDelegate?
    
    // MARK: - # Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentFromNib()
    }
    
    // MARK: - UI Actions
    @IBAction func touchUpInsideVetMessages(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = MessageListViewController.tabBarController
    }

    @IBAction func touchUpInsideActivityTracker(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = CreateExerciseViewController.tabBarController
    }

    @IBAction func touchUpInsideVetList(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = VetListViewController.tabBarController
    }

    @IBAction func touchUpInsideClinicsList(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.rootViewController = ClinicsListViewController.tabBarController
    }

    @IBAction func touchUpInsideEmergencyCall(_ sender: UIButton) {
        let url = URL(string: "tel://+37065823049")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
