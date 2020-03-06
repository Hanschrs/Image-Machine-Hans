//
//  MachineFormVC.swift
//  Image Machine Hans
//
//  Created by Hans Christian Yulianto on 05/03/20.
//  Copyright © 2020 Hans Christian Yulianto. All rights reserved.
//

import UIKit
import CoreData

class MachineFormVC: UIViewController {

    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var qrTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var machineID = 0
    var isNew = false
    let imagePicker = UIImagePickerController()
    
    let dateFormatter = DateFormatter()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Add Machine"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        if machineID != 0 {
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            machineFetch.fetchLimit = 1
            machineFetch.predicate = NSPredicate(format: "id == \(machineID)")
            
            let result = try! context.fetch(machineFetch)
            let machine: Machines = result.first as! Machines
            idTF.text = String(machine.id)
            nameTF.text = machine.name
            typeTF.text = machine.type
            qrTF.text = String(machine.qr)
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            datePicker.date = machine.maintain_date!
        }
        
        datePicker.datePickerMode = .date
        
        //generate ID
        if machineID == 0 {
            isNew = true
            let machines = Machines(context: context)
            let request: NSFetchRequest = Machines.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptors]
            request.fetchLimit = 1
            
            var latestID = 0
            do {
                let lastMachine = try context.fetch(request)
                latestID = Int(lastMachine.first?.id ?? 0)
            } catch {
                print(error.localizedDescription)
            }
            machineID = latestID + 1
            idTF.text = "\(machineID)"
        }

        
    }
    
    @IBAction func addImage(_ sender: Any) {
        self.selectPhotoFromLibrary()
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let id = idTF.text, id != "" else {
            let alertController = UIAlertController(title: "Warning", message: "ID must not be empty!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let name = nameTF.text, name != "" else {
            let alertController = UIAlertController(title: "Warning", message: "Name must not be empty!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let type = typeTF.text, type != "" else {
            let alertController = UIAlertController(title: "Warning", message: "Type must not be empty!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let qr = qrTF.text, qr != "" else {
            let alertController = UIAlertController(title: "Warning", message: "QR must not be empty!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let maintainDate = datePicker.date
        
        
        //check where it comes from
        if isNew {
            //add new
            let addMachine = Machines(context: context)
            
            let request: NSFetchRequest = Machines.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptors]
            request.fetchLimit = 1
            
            var maxID = 0
            do {
                let lastMachine = try context.fetch(request)
                maxID = Int(lastMachine.first?.id ?? 0)
            } catch {
                print(error.localizedDescription)
            }
            
            addMachine.id = Int32(maxID) + 1
            addMachine.name = name
            addMachine.type = type
            addMachine.qr = Int32(qr)!
            addMachine.maintain_date = maintainDate
            
            //add image
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        else {
            //from list
            let machineFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Machines")
            machineFetch.fetchLimit = 1
            machineFetch.predicate = NSPredicate(format: "id == \(machineID)")
            
            let result = try! context.fetch(machineFetch)
            let machine: Machines = result.first as! Machines
            
            machine.id = Int32(id)!
            machine.name = name
            machine.type = type
            machine.qr = Int32(qr)!
            machine.maintain_date = maintainDate
            
            //add image
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func selectPhotoFromLibrary(){
        self.present(imagePicker, animated: true, completion: nil)
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

extension MachineFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.imageMachine.contentMode = .scaleToFill
//            self.imageMachine.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
