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
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var machineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Machine Lists"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            machineFetch.sortDescriptors = [sortDescriptor]
            machines = try context.fetch(machineFetch) as! [Machines]
        } catch {
            print(error.localizedDescription)
        }
        self.machineTableView.reloadData()
    }
}

extension MachineDataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let machine = machines[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath) as! MachineTableViewCell
        cell.nameLabel.text = machine.name
        cell.typeLabel.text = machine.type
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(identifier: "machineDetailID") as! MachineDataDetailsVC
        controller.machineID = Int(machines[indexPath.row].id)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
