//
//  AddTaskViewController.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/29.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var parentVC: TaskViewController?
    let realm = try! Realm()
    let cellIdentifier: String = "cell"
    var sectionHeader: [String] = ["MOVE"  , "Priority" , "Due date"]
    var placeholders: [String] = ["task", "memo(optional)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        title = "Add TODO"
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "AddTaskTextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
        self.tableView.register(UINib(nibName: "AddTaskDateTableViewCell", bundle: nil), forCellReuseIdentifier: "dateCell")
        self.tableView.register(UINib(nibName: "AddTaskPriorityTableViewCell", bundle: nil), forCellReuseIdentifier: "priorityCell")
        
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        var taskTitle = ""
        var taskMemo = ""
        var priority = 0
        var dueDate = Date()
        
        var idx = IndexPath(row: 0, section: 0)
        let cell1 = tableView.cellForRow(at: idx) as! AddTaskTextTableViewCell
        taskTitle = cell1.taskLabel.text ?? ""
        taskMemo = cell1.memoLabel.text ?? ""
        
        idx = IndexPath(row: 0, section: 1)
        let cell2 = tableView.cellForRow(at: idx) as! AddTaskPriorityTableViewCell
        priority = cell2.segment.selectedSegmentIndex
        
        idx = IndexPath(row: 0, section: 2)
        let cell3 = tableView.cellForRow(at: idx) as! AddTaskDateTableViewCell
        dueDate = cell3.datePicker.date
        
        if taskTitle != "" {
            do {
                try self.realm.write({
                    let newItem = Task()
                    newItem.name = taskTitle
                    newItem.detail = taskMemo
                    newItem.dueDate = dueDate
                    newItem.priority = priority
                    newItem.color = UIColor.randomFlat().hexValue()
                    realm.add(newItem)
                })
            } catch {
                print("Error occured during adding new Task")
            }
            dismiss(animated: true) {
                self.parentVC?.loadData()
            }
        }
    }
}
extension AddTaskViewController: UITableViewDelegate {
    
}
extension AddTaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.darkGray
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.rowHeight * 2
        }
        return tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            // with TextField
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! AddTaskTextTableViewCell
            cell.taskLabel.placeholder = placeholders[0]
            cell.memoLabel.placeholder = placeholders[1]
            
            return cell
        case 1:
            // with Priority
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "priorityCell", for: indexPath) as! AddTaskPriorityTableViewCell
//            cell.label.text = headerLabel[indexPath.section+1]
            return cell
        default:
            // with Date Picker
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! AddTaskDateTableViewCell
//            cell.label.text = headerLabel[indexPath.section+1]
            cell.datePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: Date().self)!, animated: true)
            
            return cell
        }
    }
    
}
