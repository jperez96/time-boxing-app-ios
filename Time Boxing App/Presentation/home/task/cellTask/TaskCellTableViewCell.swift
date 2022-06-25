//
//  TaskCellTableViewCell.swift
//  Time Boxing App
//
//  Created by Julio Cesar Perez Rabines on 21/06/22.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxView: CheckBoxView!
    private var task : Task?
    
    @IBAction func checboxAction(_ sender: CheckBoxView) {
        guard task != nil else {
            return
        }
        task!.finished = !task!.finished
        sender.isSelected = task!.finished
    }
    
    func setData(obj: Task){
        task = obj
        titleLabel.text = obj.name
        checkBoxView.isSelected = obj.finished
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }
    
}
