//
//  MoreInfoVC.swift
//  ContactInfo
//
//  Created by Matthew  on 28.04.2022.
//

import UIKit
import Contacts

class MoreInfoVC: UIViewController {

    @IBOutlet var moreInfoTableView: UITableView!
    var recievedData: [ContactStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreInfoTableView.rowHeight = 0.11*self.view.frame.height
        self.moreInfoTableView.delegate = self
        self.moreInfoTableView.dataSource = self
        
    }

}


extension MoreInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recievedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = recievedData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCell", for: indexPath) as! MoreInfoTableViewCell
        cell.setMoreData(data: cellData)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
