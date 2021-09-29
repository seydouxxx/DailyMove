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
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var todoTableView: UITableView!
    var todo: Results<Task>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        title = "MOVE"
        todoTableView.rowHeight = 50
        todoTableView.separatorStyle = .none
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
        self.loadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTaskViewController
        vc.parentVC = self
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
        todo = realm.objects(Task.self).filter("done == false").sorted(byKeyPath: "createdDate", ascending: true).sorted(byKeyPath: "dueDate", ascending: true).sorted(byKeyPath: "priority", ascending: false)
        todoTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo?.count ?? 1
    }
    
    //  indexPath.row 번째 셀 정의
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
    
    //  swipe 정의
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
                        self.loadData()
                    } catch {
                        print("Error occured during Changing state. \(error)")
                    }
                }
            }
            return [doneAction]
        }
    }
    //  swipe 옵션
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        return options
    }
}

extension TaskViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todo = todo?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
//        print("searched")
//        todoTableView.reloadData()
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            todo = todo?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
            todoTableView.reloadData()
        }
    }
}
