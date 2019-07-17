//
//  AddUpdateTaskView.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import FaveButton

class UpdateTaskView: UIView {
    
    private let topContainerView = UIView()
    
    let doneCheckBox: Checkbox = {
        let i = Checkbox()
        i.borderStyle = .circle
        i.checkmarkStyle = Checkbox.CheckmarkStyle.tick
        i.borderWidth = 6
        i.uncheckedBorderColor = Colors.darkTextColor
        i.checkedBorderColor = Colors.lightPurple
        i.checkmarkSize = 0.5
        i.checkmarkColor = UIColor.white
        i.isChecked = false
        return i
    }()
    
    let taskNameTextView = RSKPlaceholderTextView()
    let favIcon = FaveButton(
        frame: CGRect(x:200, y:200, width: 44, height: 44),
        faveIconNormal: UIImage(named: "star"))
    
    private let horizontalStackView: UIStackView = {
      let h = UIStackView()
        h.axis = .vertical
        h.distribution = UIStackView.Distribution.fillEqually
        h.spacing = 10
        
        return  h
    }()
    
    let myDayView = OptionWithLeftIconView(icon: UIImage(named: "myday")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
    let dueDateView = OptionWithLeftIconView(icon: UIImage(named: "dueDate")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
    
    let noteView = RSKPlaceholderTextView()
    private let bottomContainerView = UIView()
    let createdDate = UILabel()
    let deleteButton = UIButton(type: .custom)
    
    var myDayViewChoosed: Bool = false {
        didSet {
            if myDayViewChoosed {
                myDayView.layer.borderWidth = 1.0
                myDayView.labelText = "Add to My Day"
            } else {
                myDayView.labelText = ""
                myDayView.layer.borderWidth = 0.0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        doneCheckBox.translatesAutoresizingMaskIntoConstraints = false
        taskNameTextView.translatesAutoresizingMaskIntoConstraints = false
        favIcon.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        noteView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        createdDate.translatesAutoresizingMaskIntoConstraints = false
        
        topContainerView.addSubview(doneCheckBox)
        topContainerView.addSubview(taskNameTextView)
        topContainerView.addSubview(favIcon)
        
        bottomContainerView.addSubview(createdDate)
        createdDate.font = UIFont.systemFont(ofSize: 12)
        createdDate.textColor = UIColor.lightGray
        createdDate.text = ""
        createdDate.anchorCenterSuperview()
        
        deleteButton.setImage(UIImage(named: "trash")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal) 
        deleteButton.tintColor = Colors.iconsColor
        
        bottomContainerView.addSubview(deleteButton)
        deleteButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.bottomContainerView.rightAnchor, constant: -20).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        self.addSubview(topContainerView)
        self.addSubview(horizontalStackView)
        self.addSubview(noteView)
        self.addSubview(bottomContainerView)
        
        //TextView Properties
        taskNameTextView.font = UIFont.systemFont(ofSize: 22)
        
        favIcon.selectedColor = Colors.lightPurple
        favIcon.normalColor = Colors.lightTextColor
        favIcon.setImage(UIImage(named: "star-1")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.selected)
        favIcon.tintColor = Colors.lightPurple
        
        taskNameTextView.placeholder = "Write a title"
        taskNameTextView.tag = 1
        taskNameTextView.textColor = Colors.darkTextColor
       
        myDayView.layer.borderColor = Colors.lightPurple.cgColor
        myDayView.label.textColor = Colors.lightPurple
        myDayView.label.isUserInteractionEnabled = false
        myDayView.placeholderText = "Add to My Day"
        dueDateView.placeholderText = "Add Due Date"
        dueDateView.label.accessibilityIdentifier = "duedate-input"

        noteView.textColor = Colors.darkTextColor
        noteView.placeholder = "Write a detail note"
        noteView.tag = 2
        noteView.font = UIFont.systemFont(ofSize: 16)
        //MARK: TODO
        let maxHeightOfNameTextView = topContainerView.heightAnchor.constraint(lessThanOrEqualToConstant: 150)
        //maxHeightOfNameTextView.priority = UILayoutPriority(50)
        maxHeightOfNameTextView.isActive = true
        
        topContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topContainerView.backgroundColor = UIColor.white
        
        doneCheckBox.topAnchor.constraint(equalTo: self.topContainerView.topAnchor,constant: 30).isActive = true
        doneCheckBox.leftAnchor.constraint(equalTo: self.topContainerView.leftAnchor,constant: 20).isActive = true
        doneCheckBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        doneCheckBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        taskNameTextView.leftAnchor.constraint(equalTo: doneCheckBox.rightAnchor, constant: 20).isActive = true
        taskNameTextView.rightAnchor.constraint(equalTo: favIcon.leftAnchor, constant: -20).isActive = true
        taskNameTextView.topAnchor.constraint(equalTo: self.topContainerView.topAnchor, constant: 25).isActive = true
        taskNameTextView.bottomAnchor.constraint(equalTo: self.topContainerView.bottomAnchor).isActive = true
        
        favIcon.centerYAnchor.constraint(equalTo: doneCheckBox.centerYAnchor).isActive = true
        favIcon.rightAnchor.constraint(equalTo: self.topContainerView.rightAnchor, constant: -20).isActive = true
        favIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        horizontalStackView.addArrangedSubview(myDayView)
        horizontalStackView.addArrangedSubview(dueDateView)
        
        horizontalStackView.anchor(topContainerView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        noteView.anchor(horizontalStackView.bottomAnchor, left: self.leftAnchor, bottom: bottomContainerView.topAnchor, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bottomContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bottomContainerView.backgroundColor = UIColor.white
        
        
    }
    
}
class OptionWithLeftIconView: UIView {
    
    private let icon = UIImageView()
    let closeBtn = UIButton(type: .custom)
    let label = UITextField()
    
    var iconImage: UIImage? {
        didSet {
            self.icon.image = iconImage!
        }
    }
    
    var labelText: String? {
        didSet {
            guard let unwrappedText = labelText else { return }
            self.label.text = unwrappedText
        }
    }
    
    var placeholderText: String? {
        didSet {
            self.label.placeholder = placeholderText!
        }
    }
    
    var isCloseBtnShowing: Bool = false {
        didSet {
            if isCloseBtnShowing {
                closeBtn.alpha = 1.0
            } else {
                closeBtn.alpha = 0.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(icon: UIImage) {
        self.init()
        self.iconImage = icon
        self.icon.image = icon
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        self.addSubview(label)
        self.addSubview(closeBtn)
        self.backgroundColor = UIColor.white
        
        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        icon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true

        icon.anchorCenterYToSuperview()
        icon.tintColor = Colors.iconsColor

        label.anchorCenterYToSuperview()
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        label.textColor = Colors.darkTextColor
        
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        closeBtn.alpha = 0.0
        closeBtn.anchorCenterYToSuperview()
        closeBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
}
