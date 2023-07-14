import UIKit
//import FileCache

class DetailsViewController: UIViewController {
    
//MARK: - Properties
    var todoItem: TodoItem? { didSet {  } }
    
    var singleSelection: UICalendarSelectionSingleDate!
    var saveActionClosure: ((TodoItem) -> Void)?
    var deleteActionClosure: ((String) -> Void)?
    var cancelGesture: UIGestureRecognizer!
    
    var textViewHeightConstraint: NSLayoutConstraint!
    var verticalConstraints: [NSLayoutConstraint] = []
    var horizontalConstraints: [NSLayoutConstraint] = []
    var selectedColor: UIColor = .white

//MARK: - Lifecycle and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backPrimary
        setupView()
        setupLayout()
        setupNavigationBar()
        setupTapAndButtons()
        setupDetailsInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.size.height
//        mainScrollView.contentInset.bottom = keyboardHeight
        mainScrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight

        let rect = CGRect(x: 0, y: 0, width: 400, height: 800)
        mainScrollView.scrollRectToVisible(rect, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        mainScrollView.contentInset.bottom = 0
        mainScrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func setupDetailsInfo() {
        guard let todoItem = todoItem else { return }
        taskText.text = todoItem.text
        taskText.textColor = Constants.labelPrimary
        detailsStack.priority = todoItem.priority
        if let deadline = todoItem.deadline {
            singleSelection.selectedDate = detailsStack.calendarView.calendar.dateComponents(in: .current, from: deadline)
            detailsStack.setDateToDeadline(date: singleSelection.selectedDate!)
            detailsStack.toggleSwitch.isOn = true
        }
        detailsStack.toggleAction(detailsStack.toggleSwitch)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = todoItem != nil
    }
    
    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStack)
        mainStack.addArrangedSubview(taskText)
        mainStack.addArrangedSubview(detailsStack)
        mainStack.addArrangedSubview(deleteButton)
        containerView.addSubview(colorView)
        taskText.delegate = self
    }
    
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
            
            colorView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -32.0),
            colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32.0),
            colorView.heightAnchor.constraint(equalToConstant: 20.0),
            colorView.widthAnchor.constraint(equalToConstant: 20.0),
            
        ])
        textViewHeightConstraint = taskText.heightAnchor.constraint(equalToConstant: 120.0)
        textViewHeightConstraint.isActive = true
    }
    
    func setupVerticalandHorizontalLayout() {
        verticalConstraints = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    
        horizontalConstraints = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        if UIDevice.current.orientation == .landscapeLeft ||
           UIDevice.current.orientation == .landscapeRight 
        {
            for constraint in horizontalConstraints { constraint.isActive = true }
            print("here in hotizotal")
        } else {
            for constraint in verticalConstraints { constraint.isActive = true }
            print("here in vertical")
        }
        
    }
    
    private func setupTapAndButtons() {
        singleSelection = UICalendarSelectionSingleDate(delegate: self)
        detailsStack.calendarView.selectionBehavior = singleSelection
        singleSelection.selectedDate = detailsStack.calendarView.calendar.dateComponents(in: .current, from: Date(timeIntervalSinceNow: 24*60*60))
        detailsStack.setDateToDeadline(date: singleSelection.selectedDate!)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        cancelGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextView))
        cancelGesture.isEnabled = true
        view.addGestureRecognizer(cancelGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped(_:)))
           colorView.addGestureRecognizer(tapGesture)
        
        detailsStack.disableGestureClosure = { [weak self] in
            guard let some = self else {return}
            some.cancelGesture.isEnabled = !(some.cancelGesture.isEnabled)
        }
        detailsStack.resignFirstResponderClosure = { [weak self] in
            guard let some = self else {return}
            some.taskText.resignFirstResponder()
        }
    }
    
    
//MARK: - Button Actions
    @objc private func colorViewTapped(_ sender: UITapGestureRecognizer) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = selectedColor
        taskText.tintColor = selectedColor 
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func orientationDidChange() {
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
            print("nothing")
        }
        view.layoutSubviews()
        
    }
    
    @objc private func saveAction() {
        print("save")
        let deadline = detailsStack.getDeadline()

        if todoItem == nil {
            let newTodoItem = TodoItem(text: taskText.text, priority: detailsStack.priority, deadline: deadline,isDone: false)
            saveActionClosure?(newTodoItem)
        } else {
            guard let todoItem = todoItem else {return}
            let newTodoItem = TodoItem(id: todoItem.id, text: taskText.text, priority: detailsStack.priority,deadline: deadline, isDone: todoItem.isDone, createDate: todoItem.createDate, changeDate: todoItem.changeDate)
            saveActionClosure?(newTodoItem)
        }
        self.dismiss(animated: true)

    }
    
    @objc private func deleteAction() {
        print("delete")
        guard let id = todoItem?.id else { return }
        deleteActionClosure?(id)
        self.dismiss(animated: true)

    }
    
    @objc private func dismissTextView() {
        taskText.resignFirstResponder()
    }
    
    @objc private func cancelAction() {
        taskText.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    
//MARK: - UI Elements
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
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 16, right: 30)
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
            NSAttributedString.Key.foregroundColor : Constants.colorRed!
        ]), for: .normal)
        return button
    } ()
    
    lazy var colorView: UIView = {
        let view = UIView()
//        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = selectedColor
        view.layer.cornerRadius = 10
        return view
    } ()
}


//MARK: - UITextViewDelegate

extension DetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        cancelGesture.isEnabled = true
        detailsStack.hideCalendar()
        if textView.text == Constants.placeholderText {
            textView.text = ""
            textView.textColor = Constants.labelPrimary
        }
        if UIDevice.current.orientation == .landscapeLeft ||
           UIDevice.current.orientation == .landscapeRight 
        {
            detailsStack.isHidden = true
            deleteButton.isHidden = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholderText
            textView.textColor = Constants.labelTertiary
        }
        detailsStack.isHidden = false
        deleteButton.isHidden = false
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

//MARK: - UICalendarSelectionSingleDateDelegate
extension DetailsViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else {return}
        detailsStack.setDateToDeadline(date: dateComponents)
    }
}

//MARK: - UIColorPickerViewControllerDelegate
extension DetailsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorView.backgroundColor = selectedColor
    }
}
