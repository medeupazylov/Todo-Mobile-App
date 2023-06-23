//
//  ViewController.swift
//  TodoApp
//
//  Created by Medeu Pazylov on 17.06.2023.
//

import UIKit


class DetailsViewController: UIViewController {

    
    var textViewHeightConstraint: NSLayoutConstraint!
    var multiselection: UICalendarSelectionSingleDate!
    var todoItem: TodoItem? {
        didSet {
            guard let todoItem = todoItem else { return }
            taskText.text = todoItem.text
            detailsStack.priority = todoItem.priority
            if let deadline = todoItem.deadline {
                multiselection.selectedDate = detailsStack.calendarView.calendar.dateComponents(in: .current, from: deadline)
                detailsStack.setDateToDeadline(date: multiselection.selectedDate!)
            }
            taskText.textColor = Constants.labelPrimary
            detailsStack.toggleSwitch.isOn = true
            detailsStack.toggleAction(detailsStack.toggleSwitch)
        }
    }
    var saveActionClosure: ((TodoItem) -> Void)?
    var deleteActionClosure: ((String) -> Void)?
    
    var gesture: UIGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backPrimary
        setupView()
        setupLayout()
        setupNavigationBar()
        setupTapAndButtons()
        
        gesture = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        gesture.isEnabled = true
        view.addGestureRecognizer(gesture)
        detailsStack.disableGestureClosure = { [weak self] in
            guard let some = self else {return}
            some.gesture.isEnabled = !(some.gesture.isEnabled)
        }
        
        detailsStack.resignFirstResponderClosure = { [weak self] in
            guard let some = self else {return}
            some.taskText.resignFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)


    }
    
    @objc func orientationDidChange() {
        let device = UIDevice.current
        switch device.orientation {
        case .portrait:
            // Handle portrait orientation
            print("Portrait")
            for item in horizontalConstraints { item.isActive = false }
            for item in verticalConstraints { item.isActive = true }
        case .landscapeLeft, .landscapeRight:
            // Handle landscape orientation
            print("Landscape")
            for item in verticalConstraints { item.isActive = false }
            for item in horizontalConstraints { item.isActive = true }
        default:
            break
        }
        view.layoutSubviews()
        
    }
    
    
    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStack)
        mainStack.addArrangedSubview(taskText)
        mainStack.addArrangedSubview(detailsStack)
        mainStack.addArrangedSubview(deleteButton)
        taskText.delegate = self
    }
    
    var verticalConstraints: [NSLayoutConstraint] = []
    var horizontalConstraints: [NSLayoutConstraint] = []
    
    private func setupLayout() {
        setupVerticalandHorizontalLayout()
        
        NSLayoutConstraint.activate([
            
            mainScrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mainStack.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 16.0),
            mainStack.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -16),
            
            
            taskText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            taskText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            
            detailsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            detailsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),

            deleteButton.heightAnchor.constraint(equalToConstant: 56.0),
        ])
        
        textViewHeightConstraint = taskText.heightAnchor.constraint(equalToConstant: 120.0)
        textViewHeightConstraint.isActive = true
    }
    
    func setupVerticalandHorizontalLayout() {
        verticalConstraints = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        for constraint in verticalConstraints {
            constraint.isActive = true
        }
        
        horizontalConstraints = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = todoItem != nil
    }
    
    private func setupTapAndButtons() {
        multiselection = UICalendarSelectionSingleDate(delegate: self)
        detailsStack.calendarView.selectionBehavior = multiselection
        multiselection.selectedDate = detailsStack.calendarView.calendar.dateComponents(in: .current, from: Date(timeIntervalSinceNow: 24*60*60))
        detailsStack.setDateToDeadline(date: multiselection.selectedDate!)
        
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    @objc private func saveAction() {
        print("save")
        if todoItem == nil {
            let deadline = detailsStack.deadline
            let newTodoItem = TodoItem(text: taskText.text, priority: detailsStack.priority, deadline: deadline ,isDone: false)
            saveActionClosure?(newTodoItem)
        } else {
            guard let todoItem = todoItem else {return}
            let newTodoItem = TodoItem(id: todoItem.id, text: taskText.text, priority: detailsStack.priority,deadline: todoItem.deadline, isDone: todoItem.isDone, createDate: todoItem.createDate, changeDate: todoItem.changeDate)
            saveActionClosure?(newTodoItem)
        }
    }
    
    @objc private func deleteAction() {
        print("delete")
        guard let id = todoItem?.id else {
            return
        }
        deleteActionClosure?(id)
    }
    
    @objc private func cancelAction() {
        taskText.resignFirstResponder()
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    
    private let mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    } ()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    } ()
    
    private let taskText: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 16, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Constants.backSecondary
        textView.layer.cornerRadius = 16.0
        textView.isScrollEnabled = false
        textView.text = Constants.placeholderText
        textView.textColor = Constants.labelTertiary
        textView.font = Constants.SFProRegularFont
        return textView
    } ()
    
    private let detailsStack: DetailsStackView = {
        let stack = DetailsStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = Constants.backSecondary
        stack.layer.cornerRadius = 16.0
        return stack
    } ()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.backSecondary
        button.layer.cornerRadius = 16.0
        button.setAttributedTitle(NSAttributedString(string: "Удалить", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .light),
            NSAttributedString.Key.foregroundColor : Constants.colorRed
        ]), for: .normal)
        return button
    } ()

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}


extension DetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        gesture.isEnabled = true
        detailsStack.hideCalendar()
        if textView.text == Constants.placeholderText {
            textView.text = ""
            textView.textColor = Constants.labelPrimary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholderText
            textView.textColor = Constants.labelTertiary
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        navigationItem.rightBarButtonItem?.isEnabled = (textView.text != "")
    }
    
    func updateTextViewHeight() {
        let fixedWidth = taskText.frame.size.width
        let newSize = taskText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if(newSize.height<=120)  {
            textViewHeightConstraint.constant = 120
        } else {
            textViewHeightConstraint.constant = newSize.height
        }
        view.layoutIfNeeded()
    }
}

extension DetailsViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else {return}
        detailsStack.setDateToDeadline(date: dateComponents)
    }
}

