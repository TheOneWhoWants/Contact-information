//
//  MainVC.swift
//  ContactInfo
//
//  Created by Matthew on 27.04.2022.
//

import UIKit
import Contacts

class MainVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var cells: [TableViewCellData] = []
    var contactStruct: [ContactStruct] = []
    
    //the data that we're gonna send to the moreInfoVC
    var allContacts: [ContactStruct] = []
    var theSameNumbers: [ContactStruct] = []
    var theSameNames: [ContactStruct] = []
    var withoutName: [ContactStruct] = []
    var withoutEmail: [ContactStruct] = []
    var withoutPhoneNumber: [ContactStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestContactsAccess()
        loadData()
        self.cells = createData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 0.11*self.view.frame.height
    }
    
    func requestContactsAccess() {
        contactStore.requestAccess(for: .contacts) { (success, error) in }
    }
    
    func loadData() {
        let key = [CNContactGivenNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
            let name = contact.givenName
            let email = contact.emailAddresses.first?.value
            let localizedEmail: String
            if email != nil {
                localizedEmail = (email as? String)!
            } else {
                localizedEmail = ""
            }
            let profilePicture = contact.imageData
            let defaultImage = UIImage(systemName: "person")?.pngData()
            let phoneNumber = contact.phoneNumbers.first?.value.stringValue
            let contactToAppend = ContactStruct(givenName: name, phoneNumber: phoneNumber ?? "There is no phone number",email: localizedEmail, profilePicture: UIImage(data: (profilePicture ?? defaultImage)!))
            self.allContacts.append(contactToAppend)
        }
        
        //search for contacts without a name
        for contact in allContacts {
            if contact.givenName == "" {
                withoutName.append(contact)
            }
        }
        
        //search for contacts without phone number
        for contact in allContacts {
            if contact.phoneNumber == "There is no phone number" {
                withoutPhoneNumber.append(contact)
            }
        }
        
        //search for contacts without email
        for contact in allContacts {
            if contact.email == "" {
                withoutEmail.append(contact)
            }
        }
        
        //search for the same phone numbers
        for i in 0..<allContacts.count {
            for j in i+1..<allContacts.count {
                if (allContacts[i].phoneNumber == allContacts[j].phoneNumber) {
                    theSameNumbers.append(allContacts[j])
                    theSameNumbers.append(allContacts[i])
                }
            }
        }
        
        //search for the same contact names
        for i in 0..<allContacts.count {
            for j in i+1..<allContacts.count {
                if (allContacts[i].givenName == allContacts[j].givenName) {
                    theSameNames.append(allContacts[j])
                    theSameNames.append(allContacts[i])
                }
            }
        }
        
    }
    
    func createData() -> [TableViewCellData] {
        
        var data: [TableViewCellData] = []
        
        let cell1 = TableViewCellData(image: UIImage(systemName: "person.crop.circle")!, title: "Контакты", status: String(allContacts.count))
        let cell2 = TableViewCellData(image: UIImage(systemName: "person.3")!, title: "Повторяющиеся имена", status: String(theSameNames.count))
        let cell3 = TableViewCellData(image: UIImage(systemName: "phone")!, title: "Дубликаты номеров", status: String(theSameNumbers.count))
        let cell4 = TableViewCellData(image: UIImage(systemName: "person.crop.circle.badge.questionmark")!, title: "Без имени", status: String(withoutName.count))
        let cell5 = TableViewCellData(image: UIImage(systemName: "iphone.slash")!, title: "Нет номера", status: String(withoutPhoneNumber.count))
        let cell6 = TableViewCellData(image: UIImage(systemName: "envelope")!, title: "Нет электронной почты", status: String(withoutEmail.count))
        
        data.append(cell1)
        data.append(cell2)
        data.append(cell3)
        data.append(cell4)
        data.append(cell5)
        data.append(cell6)
        
        return data
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.setData(data: cellData)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        currentCell?.setSelected(false, animated: false)
        let destination = storyboard?.instantiateViewController(withIdentifier: "moreInfoVC") as? MoreInfoVC
        destination?.recievedData = allContacts
        if indexPath?.row == 0 {
            destination?.title = "Контакты"
            destination?.recievedData = allContacts
        } else if indexPath?.row == 1 {
            destination?.title = "Повторяющиеся имена"
            destination?.recievedData = theSameNames
        } else if indexPath?.row == 2{
            destination?.title = "Дубликаты номеров"
            destination?.recievedData = theSameNumbers
        } else if indexPath?.row == 3{
            destination?.title = "Без имени"
            destination?.recievedData = withoutName
        } else if indexPath?.row == 4{
            destination?.title = "Нет номера"
            destination?.recievedData = withoutPhoneNumber
        } else if indexPath?.row == 5{
            destination?.title = "Нет электронной почты"
            destination?.recievedData = withoutEmail
        }
        navigationController?.pushViewController(destination!, animated: true)
    }
    
}
