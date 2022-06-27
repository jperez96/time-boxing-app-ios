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
    
    private let updateTaskUseCase = UpdateTaskUseCase()
    
    func setData(obj: Task){
        task = obj
        titleLabel.text = obj.name
        checkBoxView.isSelected = obj.finished
        checkBoxView.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }
    
    private func updateTask(){
        if(self.task == nil){
            return
        }
        let _ = updateTaskUseCase.execute(self.task!).subscribe { response in
            if(!response.responseData){
                print(response.responseMessage)
            }
        } onFailure: { error in
            print(error)
        }

    }
    
}

extension TaskCellTableViewCell : CheckBoxDelegate {
    
    func onChangeCheck(_ isCheck: Bool) {
        if(self.task == nil){
            return
        }
        self.task!.finished = isCheck
        updateTask()
    }
    
}
