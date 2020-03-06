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
    
    @IBOutlet weak var sortNameBtn: UIButton!
    @IBOutlet weak var sortTypeBtn: UIButton!
    @IBOutlet weak var machineTableView: UITableView!
    
    var sortNameAsc = true
    var sortTypeAsc = false
    
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
            print("fetch \(machines.count)")
        } catch {
            print(error.localizedDescription)
        }
        self.machineTableView.reloadData()
    }
    
    @IBAction func sort(_ sender: UIButton) {
        do {
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            var sortDescriptor = NSSortDescriptor()
            if sender.tag == 0 {
                if sortNameAsc {
                    sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
                    sortNameAsc = false
                } else {
                    sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                    sortNameAsc = true
                }
            } else if sender.tag == 1 {
                if sortTypeAsc {
                    sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
                    sortTypeAsc = false
                } else {
                    sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
                    sortTypeAsc = true
                }
            }
            
            print(sortNameAsc)
            print(sortTypeAsc)

            machineFetch.sortDescriptors = [sortDescriptor]
            machines = try context.fetch(machineFetch) as! [Machines]
        } catch {
            print(error.localizedDescription)
        }
        machineTableView.reloadData()
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
        print(indexPath)
        let controller = self.storyboard?.instantiateViewController(identifier: "machineDetailID") as! MachineDataDetailsVC
        controller.machineID = Int(machines[indexPath.row].id)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
