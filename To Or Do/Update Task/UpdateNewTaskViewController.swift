//
//  AddNewTaskViewController.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import Bond
import FaveButton
class UpdateTaskViewController: BaseViewController {
    
    private let viewModel = UpdateTaskViewModel()

    private let containerView = UpdateTaskView()
    private var doneBarButtonItem: UIBarButtonItem!
    let datePicker = UIDatePicker()
    
    var oldTextFieldText: String!
    var activeTextField = UITextField()
    
    var keyboardHeight: CGFloat = 0.0
    var keyboardDifference: CGFloat = 0.0
    
    var taskType: ListType?
    var task: Task?
    
    private var isDeleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDoneBarButtonItem()
        setupView()
        
        viewModel.title.bidirectionalBind(to: containerView.taskNameTextView.reactive.text)
        viewModel.detailNote.bidirectionalBind(to: containerView.noteView.reactive.text)
        //viewModel.dueDate.bidirectionalBind(to: containerView.dueDateView.label.reactive.text)
        
        
        
        _ = viewModel.isDone.observeNext(with: { [weak self] boolVal in
            self?.containerView.doneCheckBox.isChecked = boolVal
        })
        _ = viewModel.isFav.observeNext(with: { [weak self] boolVal in
            self?.containerView.favIcon.setSelected(selected: boolVal, animated: true)
        })
        
        _ = viewModel.dueDate.observeNext(with: { [weak self] stringVal in
            self?.containerView.dueDateView.labelText = stringVal
            if let val = stringVal, val != "" {
                self?.containerView.dueDateView.isCloseBtnShowing = true
            } else {
                self?.containerView.dueDateView.isCloseBtnShowing = false
            }
        })
        _ = viewModel.isToday.observeNext(with: { [weak self] boolVal in
            self?.containerView.myDayViewChoosed = boolVal
        })
        _ = viewModel.createdDate.observeNext(with: { [weak self] stringVal in
            if let unwrappedDate = stringVal {
                self?.containerView.createdDate.text = "Created at \(String(describing: unwrappedDate))"
            }
        })
        
        
        containerView.dueDateView.closeBtn.addTarget(self, action: #selector(dueDateCloseBtnTapped(_:)), for: UIControl.Event.touchUpInside)
        let myDayTapGesture = UITapGestureRecognizer(target: self, action: #selector(myDayViewTapped(_:)))
        containerView.myDayView.addGestureRecognizer(myDayTapGesture)
        
        containerView.doneCheckBox.addTarget(self, action: #selector(doneCheckBoxTapped(_:)), for: UIControl.Event.touchUpInside)
        
        containerView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        if let unwrappedTask = self.task {
            viewModel.task = unwrappedTask
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isDeleted {
            viewModel.updateDatabase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        self.title = "Update Task"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(containerView)
        self.containerView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        containerView.noteView.delegate = self
        containerView.taskNameTextView.delegate = self
        containerView.favIcon.addTarget(self, action: #selector(favButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        containerView.dueDateView.label.delegate = self
        let toolbar = KeyboardToolbar()
        toolbar.toolBarDelegate = self
        toolbar.setup(leftButtons: [.cancel] , rightButtons: [.done])
        containerView.dueDateView.label.inputAccessoryView = toolbar
        
    }

    private func showBarButton() {
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    private func hideBarButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        isDeleted = viewModel.deleteTask()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addDoneBarButtonItem() {
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Done", for: UIControl.State.normal)
        btn1.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn1.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: .touchUpInside)
        doneBarButtonItem = UIBarButtonItem(customView: btn1)
    }
    
    @objc func doneCheckBoxTapped(_ sender: Any) {
        viewModel.isDone.value = !viewModel.isDone.value
    }

    @objc func favButtonTapped(_ sender: UIButton) {
        viewModel.isFav.value = !viewModel.isFav.value
    }
    
    //TODO: Change this If put whole view inside UIScrollView
    @objc override func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        if let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, containerView.noteView.isFirstResponder {
            keyboardHeight = frameValue.cgRectValue.size.height
            if self.view.frame.height - keyboardHeight < containerView.noteView.frame.maxY {
                keyboardDifference = self.view.frame.height - keyboardHeight - containerView.noteView.frame.maxY
                self.view.frame.origin.y += keyboardDifference
            }
        }
        
    }
    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y -= keyboardDifference
            keyboardDifference = 0.0
        }
    }
    
    @objc func myDayViewTapped(_ sender: UITapGestureRecognizer) {
        viewModel.isToday.value = !viewModel.isToday.value
    }
    
    @objc func dueDateCloseBtnTapped(_ sender: UIButton) {
        containerView.dueDateView.label.text = ""
        containerView.dueDateView.isCloseBtnShowing = false
        viewModel.dueDate.value = nil
    }
    
    @objc func doneButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    // Called when the date picker changes.
    @objc func updateDateField(sender: UIDatePicker) {
        
        activeTextField.text = viewModel.setDueDateReturnPrettyString(date: sender.date)
        datePicker.date = sender.date
        
    }
    
    deinit {
        print("Everything is correct")
    }
}

extension UpdateTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        self.oldTextFieldText = textField.text
        
        if(textField.accessibilityIdentifier == "duedate-input"){
            // Create a date picker for the date field.
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
            //Change the language of date picker
            let loc = Locale(identifier: "en")
            datePicker.locale = loc
            datePicker.addTarget(self, action: #selector(updateDateField(sender:)), for: UIControl.Event.valueChanged)
            
            // If the date field has focus, display a date picker instead of keyboard.
            // Set the text to the date currently displayed by the picker.
            textField.inputView = datePicker
            textField.text = viewModel.setDueDateReturnPrettyString(date: datePicker.date)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.accessibilityIdentifier == "duedate-input"){
            if let unwrappedText = textField.text, unwrappedText != "" {
                containerView.dueDateView.isCloseBtnShowing = true
            } else {
                containerView.dueDateView.isCloseBtnShowing = false
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showBarButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        hideBarButton()
    }
}

extension UpdateTaskViewController: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, tappedIn toolbar: KeyboardToolbar) {
        if(type == .cancel){
            if let oldText = self.oldTextFieldText {
                activeTextField.text = oldText
                activeTextField.resignFirstResponder() }
        } else if (type == .done) {
            activeTextField.resignFirstResponder()
        } else {
            return
        }
    }
}

