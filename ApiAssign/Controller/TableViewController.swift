//
//  TableViewController.swift
//  ApiAssign
//
//  Created by Rukhsar on 19/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import UIKit
import RealmSwift
import Reachability

class TableViewController: UITableViewController  {
    
    let reachability = try! Reachability()
    let realm = try! Realm()
    var newArrayy : Results<PostSave>?
    var isInternetAvailable : Bool = false
    
    var newArray = [holidaysDetails]() {
        didSet {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.newArray.count) Holidays Found In USA "
            }
        }
    }
    var postManager = PostManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        loadData()
        navigationItem.title = "\(newArrayy!.count)Found In Data"
        postManager.perfomRequest { [weak self] result in
            print("success")
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holiday):
                self?.newArray = holiday
                
            }
        }
    }
    @IBAction func refresh(_ sender: UIRefreshControl) {
        navigationItem.title = "\(newArrayy!.count) Found In Data" //realm
        //  print(loadData())
        sender.endRefreshing()
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isInternetAvailable == true {
            return newArray.count   //Api
        } else {
            return newArrayy!.count  //Realm
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isInternetAvailable == true {
            let holiday = newArray[indexPath.row]
            cell.textLabel?.text = holiday.name
            cell.detailTextLabel?.text = holiday.description
        } else {
            let dataSet = newArrayy![indexPath.row]              //realm
            cell.textLabel?.text = dataSet.nameSave              //realm
            cell.detailTextLabel?.text = dataSet.descriptionSave   //realm
        }
        //MARK: - Save Live Data into Realm Database
        if isInternetAvailable == true {
            if newArray.count != newArrayy?.count {
                let dataget = PostSave()
                dataget.nameSave = newArray[indexPath.row].name
                dataget.descriptionSave = newArray[indexPath.row].description
                save(newArray: dataget)
            } else { print("Data equal saved")}
        }else {print("you are offline")}
        
        return cell
    }
    //MARK: - delete tableView Row Method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isInternetAvailable == true{
                print("you are online")
            }else{
                updateModel(at: indexPath)
            }
        }
    }
    //MARK: - perform segue didSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellToView", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? DetailsViewController
        if isInternetAvailable == true{
            destinationVC!.newArray = newArray[(tableView.indexPathForSelectedRow?.row)!]
        }else{
            destinationVC!.newArrayyDeatail = newArrayy![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    //MARK: - data manipulation method
    func save(newArray : PostSave){
        do {
            try realm.write {
                realm.add(newArray)
            }
        }catch{
            print("Error saving Data")
        }
    }
    func loadData(){
        newArrayy = realm.objects(PostSave.self)
        tableView.reloadData()
        // print("Load Data \(newArrayy)")
    }
    //MARK: - Check Internet Availability
    func checkInternet() {
        if reachability.connection == .wifi {
            print("Reachable via WiFi")
            self.isInternetAvailable = true
        } else {
            print("UnReachable ")
            self.isInternetAvailable = false
        }
    }
    //MARK: - Delete RealmData Method for Offline
    func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.newArrayy?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    tableView.reloadData()
                    navigationItem.title = "\(newArrayy!.count) Found In Data"
                }
            }catch{
                print("error delete category  \(error)")
            }
        }
    }
}// end class



