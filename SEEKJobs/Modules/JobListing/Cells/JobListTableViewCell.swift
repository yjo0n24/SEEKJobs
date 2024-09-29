//
//  JobListTableViewCell.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 29/09/2024.
//

import UIKit

class JobListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtCompanyName: UILabel!
    @IBOutlet weak var txtApplicationStatus: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var cstTxtDescTopCompanyName: NSLayoutConstraint!
    @IBOutlet weak var cstTxtDescTopStatus: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func initData(job: Job?) {
        txtTitle.text = job?.positionTitle
        txtCompanyName.text = job?.company.name
        txtDescription.text = job?.description
        
        if job?.haveIApplied ?? false {
            txtApplicationStatus.isHidden = false
            cstTxtDescTopCompanyName.isActive = false
            cstTxtDescTopStatus.isActive = true
        }
        else {
            txtApplicationStatus.isHidden = true
            cstTxtDescTopCompanyName.isActive = true
            cstTxtDescTopStatus.isActive = false
        }
    }
}
