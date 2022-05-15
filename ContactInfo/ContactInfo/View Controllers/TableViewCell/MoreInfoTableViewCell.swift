//
//  MoreInfoTableViewCell.swift
//  ContactInfo
//
//  Created by Matthew  on 30.04.2022.
//

import UIKit

class MoreInfoTableViewCell: UITableViewCell {
    @IBOutlet var moreInfoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    func setMoreData(data: ContactStruct) {
        moreInfoImageView.image = data.profilePicture
        nameLabel.text = data.givenName
        phoneNumberLabel.text = data.phoneNumber
        emailLabel.text = data.email
    }
}
