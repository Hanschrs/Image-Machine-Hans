//
//  MachineDataDetailsVC.swift
//  Image Machine Hans
//
//  Created by Hans Christian Yulianto on 05/03/20.
//  Copyright © 2020 Hans Christian Yulianto. All rights reserved.
//

import UIKit
import CoreData

class MachineDataDetailsVC: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var lastMantainDateLabel: UILabel!
    
    var machineID = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
        machineFetch.fetchLimit = 1
        machineFetch.predicate = NSPredicate(format: "id == \(machineID)")
        
        let result = try! context.fetch(machineFetch)
        let machine: Machines = result.first as! Machines
        idLabel.text = String(machine.id)
        nameLabel.text = machine.name
        typeLabel.text = machine.type
        qrLabel.text = String(machine.qr)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        lastMantainDateLabel.text = dateFormatter.string(from: machine.maintain_date!)

        self.navigationItem.title = "\(machine.name ?? "MACHINE DETAIL")"
    }
    
    func setupView() {
        let editBtn = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(edit))
        let removeBtn = UIBarButtonItem(title: "remove", style: .plain, target: self, action: #selector(remove))
        self.navigationItem.rightBarButtonItems = [removeBtn, editBtn]
    }
    
    @objc func edit() {
        let controller = self.storyboard?.instantiateViewController(identifier: "machineForm") as! MachineFormVC
        
        controller.machineID = machineID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func remove() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure to remove this machine?", preferredStyle: .actionSheet)
        let alertActionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            machineFetch.fetchLimit = 1
            machineFetch.predicate = NSPredicate(format: "id == \(self.machineID)")
            
            let result = try! self.context.fetch(machineFetch)
            let machineToRemove: Machines = result.first as! Machines
            self.context.delete(machineToRemove)
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let alertActionCancel = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionCancel)
        self.present(alertController, animated: true, completion: nil)
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
