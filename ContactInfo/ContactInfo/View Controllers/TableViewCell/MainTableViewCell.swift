//
//  MainTableViewCell.swift
//  ContactInfo
//
//  Created by Matthew  on 27.04.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var statusLabel: UILabel!

    func setData(data: TableViewCellData) {
        title.text = data.title
        statusLabel.text = data.status
        titleImage.image = data.image
    }
}

