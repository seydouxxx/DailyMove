//
//  TaskViewController.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/27.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    

    @IBOutlet weak var todoTableView: UITableView!
    var todo: Results<Task>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        title = "TODO"
        todoTableView.rowHeight = 50
        todoTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        self.loadData()
    }
    func saveData(item: Task) {
        do {
            try realm.write({
                realm.add(item)
            })
        } catch {
            print("Error occured during saving data. \(error)")
        }
        todoTableView.reloadData()
    }
    func loadData() {
        todo = realm.objects(Task.self)
        todoTableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var field = UITextField()
        var dField = UITextField()
        
        let alert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let confirm = UIAlertAction(title: "Done", style: .default) { (aciton) in
            let newItem = Task()
            newItem.name = field.text!
            newItem.createdDate = Date()
            newItem.color = UIColor.randomFlat().hexValue()
            newItem.detail = dField.text!
            
            self.saveData(item: newItem)
        }
        
        alert.addTextField { (tField) in
            tField.placeholder = "Create new Task"
            field = tField
        }
        
        alert.addTextField { (detailField) in
            detailField.placeholder = "Note for Task(optional)"
            dField = detailField
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let item = todo?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.backgroundColor = UIColor(hexString: item.color)
            
            let selectedCellView = UIView()
            selectedCellView.backgroundColor = cell.backgroundColor
            cell.selectedBackgroundView = selectedCellView
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                if let item = self.todo?[indexPath.row] {
                    do {
                        try self.realm.write({
                            self.realm.delete(item)
                        })
                        self.todoTableView.reloadData()
                    } catch {
                        print("Error occured during Deleting element. \(error)")
                    }
                }
                
            }
            // customize the action appearance
    //        deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
        } else {
            let doneAction = SwipeAction(style: .default, title: "Done") { action, indexPath in
                if let item = self.todo?[indexPath.row] {
                    do {
                        try self.realm.write {
                            item.done = !item.done
                        }
//                        self.todoTableView.reloadData()
                    } catch {
                        print("Error occured during Changing state. \(error)")
                    }
                }
            }
            return [doneAction]
        }
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        return options
    }
}
