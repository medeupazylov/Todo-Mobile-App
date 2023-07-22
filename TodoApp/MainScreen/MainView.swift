//
//  MainViewController.swift
//  TodoApp
//
//  Created by Medeu Pazylov on 26.06.2023.
//

import UIKit
//import FileCache


enum TodoListState {
    case all
    case undone
}

class MainView: UIViewController {
    
    let mainPresenter: MainPresenterProtocol
    var todoListState: TodoListState = .all {
        didSet {
            self.tableView.reloadData()
        
            hideLabel.text = todoListState == .all ? "Скрыть" : "Показать"
        }
    }
    
    init(newMainPresenter: MainPresenterProtocol) {
        self.mainPresenter = newMainPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backPrimary
        setupNavigationBar()
        setupViews()
        setupLayout()
        setupActionAndTaps()
        updateCountLabel()
    }
    
    private func setupViews() {
        view.addSubview(mainStack)
        mainStack.addArrangedSubview(headerView)
        mainStack.addArrangedSubview(tableView)
        headerView.addSubview(countLabel)
        headerView.addSubview(hideLabel)

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            headerView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 32),
            headerView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -32),
            headerView.heightAnchor.constraint(equalToConstant: 16.0),
            
            countLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            hideLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            hideLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            

            tableView.leftAnchor.constraint(equalTo: mainStack.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: mainStack.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 32.0
    }
    
    private func setupActionAndTaps() {
        print("setupTap")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideButtonAction))
        gesture.isEnabled = true
        hideLabel.addGestureRecognizer(gesture)
        hideLabel.isUserInteractionEnabled = true

    }
    
    private func updateCountLabel() {
        let doneCount = mainPresenter.getCountTodoList() - mainPresenter.getCountUndoneList()
        countLabel.text = "Выполнено - \(doneCount)"
    }
    
    @objc private func hideButtonAction() {
        print("hereeee")
        todoListState = (todoListState == .all) ? .undone : .all
        print(todoListState)
    }
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12.0
        stack.distribution = .fill
        stack.alignment = .center
        stack.layer.cornerRadius = 16.0
        return stack
    } ()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выполнено - 5"
        label.textColor = Constants.labelTertiary
        label.font = Constants.SFProText400
        return label
    } ()
    
    private let hideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скрыть"
        label.textColor = Constants.colorBlue
        label.font = Constants.SFProText600
//        label.backgroundColor = .gray
        return label
    } ()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16.0
        table.register(TodoItemCell.self, forCellReuseIdentifier: "reusableCell")
        table.register(NewItemCell.self, forCellReuseIdentifier: "newCell")
        table.showsVerticalScrollIndicator = false
        table.separatorInset.left = 52
        return table
    } ()
    
}

extension MainView: MainViewProtocol {
    
}

extension MainView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here")
        if(indexPath.row == mainPresenter.getCountTodoList()) {
            let detailsScreen = setupDetailsScreen(withTodoItem: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            self.present(detailsScreen, animated: true)
            return
        }
        let detailsScreen = setupDetailsScreen(withTodoItem: mainPresenter.getTodoItem(atIndex: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(detailsScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < mainPresenter.getCountTodoList() else {return nil}
        let leadingAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            guard let todoItem = self.mainPresenter.getTodoItem(atIndex: indexPath.row) else {return}
            let newTodoItem = TodoItem(id: todoItem.id, text: todoItem.text, priority: todoItem.priority,deadline: todoItem.deadline ,isDone: !(todoItem.isDone), createDate: todoItem.createDate, changeDate: todoItem.changeDate)
            self.mainPresenter.addTodoItem(todoItem: newTodoItem)
            self.tableView.reloadData()
            self.updateCountLabel()
            completion(true)
        }
        
        leadingAction.backgroundColor = Constants.colorGreen
        leadingAction.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white)
        
        let configuration = UISwipeActionsConfiguration(actions: [leadingAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < mainPresenter.getCountTodoList() else {return nil}
        
        let infoAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            completion(true)
        }
        infoAction.backgroundColor = Constants.colorGrayLight
        infoAction.image = UIImage(systemName: "info.circle.fill")?.withTintColor(.white)
        
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            guard let todoItem = self.mainPresenter.getTodoItem(atIndex: indexPath.row) else {return}
            self.mainPresenter.removeTodoItem(id: todoItem.id)
            self.tableView.reloadData()
            self.updateCountLabel()
            completion(true)
        }
        deleteAction.backgroundColor = Constants.colorRed
        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.white)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoListState == .all {
            return mainPresenter.getCountTodoList() + 1
        }
        return mainPresenter.getCountUndoneList() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let maxSize = (todoListState == .all) ? mainPresenter.getCountTodoList() : mainPresenter.getCountUndoneList()
        if(indexPath.row == maxSize) {
            guard let newcell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as? NewItemCell else {
                return UITableViewCell()
            }
            newcell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return newcell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }
        if todoListState == .all {
            cell.todoItem = mainPresenter.getTodoItem(atIndex: indexPath.row)
        } else {
            cell.todoItem = mainPresenter.getUndoneItem(atIndex: indexPath.row)
        }
        cell.doneButtonClosure = { [weak self] newTodoItem in
            self?.mainPresenter.addTodoItem(todoItem: newTodoItem)
            self?.tableView.reloadData()
            self?.updateCountLabel()
        }
        
        return cell
    }
    
    
    private func setupDetailsScreen(withTodoItem todoItem: TodoItem?) -> UINavigationController{
        let vc = DetailsViewController()
        vc.todoItem = todoItem
        vc.saveActionClosure = { [weak self] newTodoItem in
            print("save in main")
            self?.mainPresenter.addTodoItem(todoItem: newTodoItem)
            self?.tableView.reloadData()
            self?.updateCountLabel()
        }
    
        vc.deleteActionClosure = { [weak self] id in
            print("delete in main")
            print(self?.mainPresenter.removeTodoItem(id: id)!)
            self?.tableView.reloadData()
            self?.updateCountLabel()
        }
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }

}

extension MainView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UITableView else {return}
        if scrollView.contentOffset.y > 60 {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            guard headerView.isHidden == false else {return}
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn , animations: {
                self.headerView.isHidden = true
            })
        } else {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            guard headerView.isHidden == true else {return}
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn , animations: {
                self.headerView.isHidden = false
            })
        }
    }
}
