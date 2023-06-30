import UIKit

class DetailsStackView: UIStackView {
    
//MARK: - Properties
    var priority: Priority = .high {
        didSet {
            changePriority(priority: priority)
        }
    }
    private(set) var deadline: Date?
    var deadlineGesture: UIGestureRecognizer!
    var disableGestureClosure: (()->Void)?
    var resignFirstResponderClosure: (()->Void)?
    
    
//MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupStack()
        setupPriorityStack()
        setupViews()
        setupLayout()
        setupTapAndButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Setup methods
    private func setupStack() {
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .center
        guard let singleSelection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate else {return}
        deadlineSubtitle.text = "\(singleSelection.selectedDate!)"
    }
    
    private func setupViews() {
        self.addArrangedSubview(priorityView)
        self.addArrangedSubview(line)
        self.addArrangedSubview(deadlineView)
        self.addArrangedSubview(line2)
        self.addArrangedSubview(calendarView)
        
        priorityView.addSubview(priorityTitle)
        priorityView.addSubview(priorityStack)
        deadlineView.addSubview(deadlineStack)
        deadlineView.addSubview(toggleSwitch)
        deadlineStack.addArrangedSubview(deadlineTitle)
        deadlineStack.addArrangedSubview(deadlineSubtitle)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            priorityView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            priorityView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            priorityView.heightAnchor.constraint(equalToConstant: 56.0),
            
            priorityTitle.centerYAnchor.constraint(equalTo: priorityView.centerYAnchor),
            priorityTitle.leadingAnchor.constraint(equalTo: priorityView.leadingAnchor, constant: 16.0),
            priorityStack.trailingAnchor.constraint(equalTo: priorityView.trailingAnchor, constant: -12.0),
            priorityStack.centerYAnchor.constraint(equalTo: priorityView.centerYAnchor),
            priorityStack.heightAnchor.constraint(equalToConstant: 36.0),
            
            deadlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            deadlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deadlineView.heightAnchor.constraint(equalToConstant: 56.0),
            deadlineStack.leadingAnchor.constraint(equalTo: deadlineView.leadingAnchor, constant: 16.0),
            deadlineStack.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor),
            
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            line.heightAnchor.constraint(equalToConstant: 0.5),
            line2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            line2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            line2.heightAnchor.constraint(equalToConstant: 0.7),
            
            lowPriorityButton.heightAnchor.constraint(equalToConstant: 31.5),
            lowPriorityButton.widthAnchor.constraint(equalToConstant: 48.0),
            
            mediumPriorityButton.heightAnchor.constraint(equalToConstant: 31.5),
            mediumPriorityButton.widthAnchor.constraint(equalToConstant: 48.0),
            
            highPriorityButton.heightAnchor.constraint(equalToConstant: 31.5),
            highPriorityButton.widthAnchor.constraint(equalToConstant: 48.0),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: deadlineView.trailingAnchor, constant: -12.0),
            toggleSwitch.centerYAnchor.constraint(equalTo: deadlineView.centerYAnchor),
            
            calendarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0, constant: -18)
        ])
    }
    
    private func setupPriorityStack() {
        priorityStack.addArrangedSubview(UIView(frame: CGRect(x: .zero, y: .zero, width: 2, height: 0)))
        priorityStack.setCustomSpacing(2, after: priorityStack.arrangedSubviews[0])
        priorityStack.addArrangedSubview(lowPriorityButton)
        priorityStack.addArrangedSubview(mediumPriorityButton)
        priorityStack.addArrangedSubview(highPriorityButton)
        priorityStack.setCustomSpacing(2, after: highPriorityButton)
        priorityStack.addArrangedSubview(UIView(frame: CGRect(x: .zero, y: .zero, width: 2, height: 0)))
    }
    
    private func setupTapAndButtons() {
        lowPriorityButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        mediumPriorityButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        highPriorityButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        toggleSwitch.addTarget(self, action: #selector(toggleAction), for: .valueChanged)
        
        deadlineGesture = UITapGestureRecognizer(target: self, action: #selector(deadLineAction))
        deadlineGesture.isEnabled = false
        deadlineView.addGestureRecognizer(deadlineGesture)
    }
    
    
//MARK: - Private methods
    private func changePriority(priority: Priority) {
        lowPriorityButton.backgroundColor = .clear
        mediumPriorityButton.backgroundColor = .clear
        highPriorityButton.backgroundColor = .clear
        switch priority {
        case .low:
            lowPriorityButton.backgroundColor = Constants.backElevated
        case .medium:
            mediumPriorityButton.backgroundColor = Constants.backElevated
        case .high:
            highPriorityButton.backgroundColor = Constants.backElevated
        }
    }
    
    
//MARK: - Internal Methods
    
    func getDeadline() -> Date? {
        if toggleSwitch.isOn {
            return deadline
        }
        return nil
    }
    
    func setDateToDeadline(date: DateComponents) {
        let months = ["января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"]
        deadlineSubtitle.text = "\(date.day!) \(months[date.month!-1]) \(date.year!)"
        guard let singleSelection = self.calendarView.selectionBehavior as? UICalendarSelectionSingleDate,
              var selectedDate = singleSelection.selectedDate
        else { return }
        if ((selectedDate.date?.timeIntervalSince1970)!) > Date.now.timeIntervalSince1970+24*60*60 {
            selectedDate.day! += 1
        }
        self.deadline = selectedDate.date
    }
    
    func hideCalendar() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn , animations: {
            self.calendarView.isHidden = true
            self.line2.isHidden = true
        })
    }
    
    
//MARK: - Button Actions

    @objc func deadLineAction() {
        resignFirstResponderClosure?()
        disableGestureClosure?()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn , animations: {
            self.calendarView.isHidden = !(self.calendarView.isHidden)
            self.line2.isHidden = self.calendarView.isHidden
        })
    }
    
    @objc private func actionButton(_ sender: UIButton) {
        resignFirstResponderClosure?()
        switch sender {
        case lowPriorityButton:
            priority = .low
        case mediumPriorityButton:
            priority = .medium
        case highPriorityButton:
            priority = .high
        default:
            print("nothing")
        }
    }
    
    @objc func toggleAction(_ sender: UISwitch) {
        resignFirstResponderClosure?()
        
        deadlineGesture.isEnabled = sender.isOn ? true : false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn , animations: {
            self.deadlineSubtitle.isHidden = sender.isOn ? false : true
            if !sender.isOn {
                self.calendarView.isHidden = true
                self.line2.isHidden = self.calendarView.isHidden
                self.deadline = nil
            }
        })
    }
    

//MARK: - PriorityView Elements
    private let priorityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let priorityTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.priorityTitleText
        label.font = Constants.SFProRegularFont
        label.textColor = Constants.labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let priorityStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = Constants.supportOverlay
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.layer.cornerRadius = 8.91
        return stack
    } ()
    
    private let lowPriorityButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "lowPriorityIcon"), for: .normal)
        button.layer.cornerRadius = 6.93
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        return button
    } ()
    
    private let mediumPriorityButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "нет", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .medium),
            NSAttributedString.Key.foregroundColor : Constants.labelPrimary!
        ]), for: .normal)
        button.layer.cornerRadius = 6.93
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        return button
    } ()
    
    private let highPriorityButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.backElevated
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "highPriorityIcon"), for: .normal)
        button.layer.cornerRadius = 6.93
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        return button
    } ()
    
    private let line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Constants.supportSeparator
        return line
    } ()
    
    
//MARK: - DeadlineView Elements
    
    private let deadlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let deadlineStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    } ()
    
    private let deadlineTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.deadlineTitleText
        label.font = Constants.SFProRegularFont
        label.textColor = Constants.labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let deadlineSubtitle: UILabel = {
        let label = UILabel()
        label.text = "2 июня 2021"
        label.font = Constants.SFProRegularFont13
        label.textColor = Constants.colorBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    } ()
    
    let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    } ()
    
    private let line2: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Constants.supportSeparator
        line.isHidden = true
        return line
    } ()
    
    let calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.calendar = Calendar(identifier: .gregorian)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.isHidden = true
        calendar.availableDateRange = DateInterval(start: Date.distantPast, end: Date.distantFuture)
        return calendar
    } ()
    
}
