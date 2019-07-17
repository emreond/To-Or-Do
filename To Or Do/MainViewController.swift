//
//  MainViewController.swift
//  To Or Do Project
//
//  Created by Emre on 20.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import RealmSwift
class MainViewController: BaseViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    private let listTableView = UITableView()
    private let cellID = "TaskTypeCell"
    
    private let mainViewModel = MainViewListViewModel()

    private let addListTextField = AddNewView(icon: UIImage(named: "plusicon")!)

    private var keyboardHeight: CGFloat = 0.0
    private var textFieldBottomConstraint: NSLayoutConstraint!
    
    private var doneBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavBarImage()
        self.setupView()
        self.setupTableView()
        
        mainViewModel.fetchCustomList()
        mainViewModel.stickyTableViewItems.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
        mainViewModel.customList.data.addAndNotify(observer: self) { [weak self] _ in
            if self?.listTableView.numberOfRows(inSection: 1) == 0 {
                DispatchQueue.main.async {
                self?.listTableView.reloadData()
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldBottomConstraint.constant = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadows()
    }

    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        addListTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addListTextField)
        
        addListTextField.label.attributedPlaceholder = NSAttributedString(string: "Add New List", attributes: [NSAttributedString.Key.foregroundColor: Colors.lightPurple])
        addListTextField.label.delegate = self
        
        addListTextField.layer.borderWidth = 0.5
        addListTextField.layer.borderColor = Colors.lightTextColor.cgColor
        addListTextField.label.tintColor = Colors.lightPurple
        
        textFieldBottomConstraint = addListTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        textFieldBottomConstraint.isActive = true
        addListTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        addListTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        addListTextField.heightAnchor.constraint(equalToConstant: 60 + (bottomPadding ?? 0.0)).isActive = true
        
        let addListTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addListTapped(sender:)))
        addListTextField.addGestureRecognizer(addListTapGesture)
        
        self.addDoneBarButtonItem()
    }
    
    private func setupNavBarImage() {
        let resetButton = UIButton(type: .custom)
        resetButton.setImage(UIImage(named: "reset"), for: UIControl.State.normal)
        resetButton.addTarget(self, action: #selector(self.resetButtonTapped(_:)), for: .touchUpInside)
        let resetBarButton = UIBarButtonItem(customView: resetButton)
        self.navigationItem.leftBarButtonItem = resetBarButton
        self.title = "TO-DO"
    }
    
    private func setupTableView() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(listTableView, belowSubview: addListTextField)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "TableViewCellWithIcon", bundle: nil), forCellReuseIdentifier: cellID)
        listTableView.separatorStyle = .none
        listTableView.rowHeight = 60.0
        
        listTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: self.addListTextField.topAnchor).isActive = true
        
    }
    
    private func setupShadows() {
        if(addListTextField.layer.shadowOpacity == 0.0){
            addListTextField.layer.applySketchShadow(color: UIColor(red:0.56, green:0.56, blue:0.56, alpha:1), alpha: 1.0, x: 0, y: 3, blur: 15, spread: 1.0)
        }
    }
    private func showBarButton() {
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    private func hideBarButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    private func addDoneBarButtonItem() {
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Done", for: UIControl.State.normal)
        btn1.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn1.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: .touchUpInside)
        doneBarButtonItem = UIBarButtonItem(customView: btn1)
    }

    @objc func addListTapped(sender: UITapGestureRecognizer) {
        self.addListTextField.label.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard let unwrappedText = addListTextField.label.text, unwrappedText != "" else { return }
        
        mainViewModel.addCustomList(taskName: unwrappedText)
        addListTextField.label.text = ""
        self.listTableView.reloadData()
    }

    @objc func resetButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Message", message: "Do you wanna reset the app?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            do {
                RealmManager().deleteAllDataForObject(Task.self)
                RealmManager().deleteAllDataForObject(CustomList.self)
                self.mainViewModel.customList.data.value.removeAll()
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
                try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)

            } catch {
                print(error)
                //Do Something With Error
            }

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in

        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //TODO: Change this If put whole view inside UIScrollView
    @objc override func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        if let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, addListTextField.label.isFirstResponder, self.textFieldBottomConstraint.constant == 0 {
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
            keyboardHeight = frameValue.cgRectValue.size.height
            self.textFieldBottomConstraint.constant -= self.keyboardHeight
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.addListTextField.iconImage = UIImage(named: "type")!
            }
        }
        
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 && self.textFieldBottomConstraint.constant != 0 {
            textFieldBottomConstraint.constant += keyboardHeight
            self.addListTextField.iconImage = UIImage(named: "plusicon")!
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showBarButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideBarButton()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainViewModel.removeCustomListItem(at: indexPath.row)
            if mainViewModel.customList.data.value.count == 0 {
                self.listTableView.reloadData()
            } else {
                self.listTableView.beginUpdates()
                self.listTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                self.listTableView.endUpdates()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listType = mainViewModel.selectedTaskType(section: indexPath.section, indexPath: indexPath.row)
        let controller = TaskListViewController()
        controller.listType = listType
        controller.title = (tableView.cellForRow(at: indexPath) as! TableViewCellWithIcon).taskTitle.text ?? ""
        if listType == .other {
            guard let model = mainViewModel.viewModelForCustomList(at: indexPath.row) else { return }
            controller.customList = model
        }
        self.listTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.frame.size = CGSize(width: self.view.frame.width, height: 20)
            view.backgroundColor = UIColor.white
            
            view.drawLine(yPosition: 20, sideMargins: 20)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if mainViewModel.customList.data.value.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mainViewModel.stickyTableViewItems.data.value.count
        } else {
            return mainViewModel.customList.data.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCellWithIcon
        if indexPath.section == 0 {
            guard let model = mainViewModel.viewModelForStickyList(at: indexPath.row) else {
                return UITableViewCell(frame: .zero)
            }
            
            cell.data = model
            return cell
        } else {
            guard let model = mainViewModel.viewModelForCustomList(at: indexPath.row) else {
                return UITableViewCell(frame: .zero)
            }
            
            cell.data = model
            return cell
        }
    }
    
}

