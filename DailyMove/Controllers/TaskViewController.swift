//
//  TaskViewController.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/27.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoTableView: UITableView!
    var todo: Results<Task>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        title = "TODO"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let item = todo?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.backgroundColor = UIColor(hexString: item.color)
        }
        return cell
    }
}
