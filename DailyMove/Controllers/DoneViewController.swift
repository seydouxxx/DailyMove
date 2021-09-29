//
//  DoneViewController.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/28.
//

import UIKit
import RealmSwift
import ChameleonFramework

class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var doneTableView: UITableView!
    let realm = try! Realm()
    var doneList: Results<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "DONE"

        doneTableView.rowHeight = 80
        doneTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.loadData()
    }
    
    func loadData() {
        doneList = realm.objects(Task.self).filter("done == true").sorted(byKeyPath: "createdDate", ascending: false)
        doneTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell", for: indexPath)
        if let item = doneList?[indexPath.row] {
            if let color = UIColor.flatWhite().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(doneList!.count)) {
                cell.textLabel?.text = item.name
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        
        return cell
    }
}
