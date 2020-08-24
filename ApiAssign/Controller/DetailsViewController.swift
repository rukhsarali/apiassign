//
//  DetailsViewController.swift
//  ApiAssign
//
//  Created by Rukhsar on 20/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    var newArray : holidaysDetails?
    var newArrayyDeatail : PostSave?
    var tableViewController = TableViewController()
    var isInternetAvailable : Bool = false
    let reachability = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        if isInternetAvailable == true{
            detailLabel.text = newArray?.description
            navigationItem.title = "\(newArray?.name ?? "no rec data true")"
            
        }else {
            detailLabel.reloadInputViews()
            detailLabel.text = newArrayyDeatail?.descriptionSave
            navigationItem.title = "\(newArrayyDeatail?.nameSave ?? "no rec data false")"
         }
    }
    //MARK: - Check internet Reachability
    func checkInternet() {
        if reachability.connection == .wifi {
            print("Reachable via WiFi")
            self.isInternetAvailable = true
        } else {
            print("UnReachable ")
            self.isInternetAvailable = false
        }
    }
}
