//
//  MachineDataVC.swift
//  Image Machine Hans
//
//  Created by Hans Christian Yulianto on 05/03/20.
//  Copyright © 2020 Hans Christian Yulianto. All rights reserved.
//

import UIKit
import CoreData

class MachineDataVC: UIViewController {
    
    var machines:[Machines] = []
    var filteredMachines:[Machines] = []
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var machineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            machines = try context.fetch(machineFetch) as! [Machines]
        } catch {
            print(error.localizedDescription)
        }
        self.machineTableView.reloadData()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Machine Lists"

        searchController.searchBar.placeholder = "Find Machine"
        searchController.hidesNavigationBarDuringPresentation = true
        
        machineTableView.tableHeaderView = searchController.searchBar
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
