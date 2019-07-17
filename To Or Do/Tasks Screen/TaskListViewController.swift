//
//  TaskListViewController.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit

class TaskListViewController: BaseViewController {
    
    private let tasksTableView = UITableView()
    private let cellID = "taskListTableViewCell"
    
    private let addTaskTextField = AddNewView(icon: UIImage(named: "plusicon")!)
    
    var listType: ListType! {
        didSet {
            self.taskListViewModel = TaskListViewModel(listType: listType)
        }
    }
    private var taskListViewModel: TaskListViewModel!
    
    private var keyboardHeight: CGFloat = 0.0
    private var textFieldBottomConstraint: NSLayoutConstraint!
    
    private var doneBarButtonItem: UIBarButtonItem!
    
    var customList: CustomList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupTableView()
        taskListViewModel.fetchList(customListName: customList?.listName)
        taskListViewModel.list.data.addAndNotify(observer: self) { [weak self] _ in
            //Do Something With Here
            DispatchQueue.main.async {
                self?.tasksTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldBottomConstraint.constant = 0
        
        taskListViewModel.fetchList(customListName: customList?.listName)
        self.tasksTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadows()
    }

    private func setupTableView() {
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(tasksTableView, belowSubview: addTaskTextField)
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: cellID)
        tasksTableView.rowHeight = 60.0
        
        tasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tasksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tasksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tasksTableView.bottomAnchor.constraint(equalTo: self.addTaskTextField.topAnchor).isActive = true
        
    }

    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        addTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addTaskTextField)
        
        addTaskTextField.label.attributedPlaceholder = NSAttributedString(string: "Add New Task", attributes: [NSAttributedString.Key.foregroundColor: Colors.lightPurple])
        addTaskTextField.label.delegate = self
        
        addTaskTextField.layer.borderWidth = 0.5
        addTaskTextField.layer.borderColor = Colors.lightTextColor.cgColor
        addTaskTextField.label.tintColor = Colors.lightPurple
        
        textFieldBottomConstraint = addTaskTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        textFieldBottomConstraint.isActive = true
        addTaskTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        addTaskTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        addTaskTextField.heightAnchor.constraint(equalToConstant: 60 + (bottomPadding ?? 0.0)).isActive = true
        
        let addTaskTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addTaskTapped(sender:)))
        addTaskTextField.addGestureRecognizer(addTaskTapGesture)
        self.addDoneBarButtonItem()
    }

    private func setupShadows() {
        if(addTaskTextField.layer.shadowOpacity == 0.0){
            addTaskTextField.layer.applySketchShadow(color: UIColor(red:0.56, green:0.56, blue:0.56, alpha:1), alpha: 1.0, x: 0, y: 3, blur: 15, spread: 1.0)
        }
    }

    @objc func doneButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard let unwrappedText = addTaskTextField.label.text, unwrappedText != "" else { return }
        taskListViewModel.addModel(title: unwrappedText, customList: self.customList)
        addTaskTextField.label.text = ""
    }
    
    @objc func addTaskTapped(sender: UITapGestureRecognizer) {
        addTaskTextField.label.becomeFirstResponder()
    }
    
    private func addDoneBarButtonItem() {
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Done", for: UIControl.State.normal)
        btn1.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn1.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: .touchUpInside)
        doneBarButtonItem = UIBarButtonItem(customView: btn1)
    }
    
    private func showBarButton() {
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    private func hideBarButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    //TODO: Change this If put whole view inside UIScrollView
    @objc override func keyboardWillShow(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        if let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, addTaskTextField.label.isFirstResponder, self.textFieldBottomConstraint.constant == 0 {
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
            keyboardHeight = frameValue.cgRectValue.size.height
            self.textFieldBottomConstraint.constant -= self.keyboardHeight
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.addTaskTextField.iconImage = UIImage(named: "type")!
            }
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            textFieldBottomConstraint.constant += keyboardHeight
            self.addTaskTextField.iconImage = UIImage(named: "plusicon")!
        }
    }
    
}

extension TaskListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showBarButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideBarButton()
    }
}
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.taskListViewModel.list.data.value.isEmpty {
            self.tasksTableView.setEmptyView(message: "Please add a new task")
        } else {
            self.tasksTableView.restore()
        }
        return taskListViewModel.list.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TaskListTableViewCell
        guard let model = taskListViewModel.viewModelForTask(at: indexPath.row) else {
            return UITableViewCell(frame: .zero)
        }
        cell.data = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = taskListViewModel.viewModelForTask(at: indexPath.row) {
            let controller = UpdateTaskViewController()
            controller.task = model
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskListViewModel.removeTask(at: indexPath.row)
        }
    }
    
}
