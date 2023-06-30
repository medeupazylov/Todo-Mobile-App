import UIKit



class TodoItemCell: UITableViewCell {
    var todoItem: TodoItem? {
        didSet{
            setupCell()
        }
    }
    var doneButtonClosure: ((TodoItem) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
        setupCell()
    }
    
    @objc func doneAction() {
        print("Done is pressed")
        guard let todoItem = todoItem else {return}
        let newTodoItem = TodoItem(id: todoItem.id, text: todoItem.text, priority: todoItem.priority,deadline: todoItem.deadline ,isDone: !(todoItem.isDone), createDate: todoItem.createDate, changeDate: todoItem.changeDate)
        doneButtonClosure?(newTodoItem)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = Constants.backSecondary
        guard let todoItem = todoItem else {return}
        if todoItem.isDone == true {
            checkMark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkMark.tintColor = Constants.colorGreen
        } else {
            checkMark.setImage(UIImage(systemName: "circle"), for: .normal)
            checkMark.tintColor = Constants.supportSeparator
        }
        
        title.text = todoItem.text
        deadlineStack.isHidden = (todoItem.deadline == nil) ? true : false
        priorityIcon.isHidden = false
        switch todoItem.priority {
        case .high:
            priorityIcon.image = Constants.highPriorityIcon
        case .medium:
            priorityIcon.isHidden = true
        case .low:
            priorityIcon.image = Constants.lowPriorityIcon
        }
        
        if(todoItem.priority == .high && todoItem.isDone == false) {
            checkMark.tintColor = Constants.colorRed
        }
        
        guard let deadline = todoItem.deadline else {return}
        let months = ["января","февраля","марта","апреля","мая","июня","июля","августа","сентября","октября","ноября","декабря"]
        let date = Calendar.current.dateComponents(in: .current, from: deadline)
        deadlineLabel.text = "\(date.day!) \(months[date.month!-1])"
        
    }
    
    private func setupViews() {
        contentView.addSubview(checkMark)
        contentView.addSubview(chevronButton)
        contentView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(priorityIcon)
        contentStack.addArrangedSubview(infoStack)
        infoStack.addArrangedSubview(title)
        infoStack.addArrangedSubview(deadlineStack)
        deadlineStack.addArrangedSubview(calendarIcon)
        deadlineStack.addArrangedSubview(deadlineLabel)
        checkMark.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    }
    
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            checkMark.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.heightAnchor.constraint(equalToConstant: 24.0),
            checkMark.widthAnchor.constraint(equalToConstant: 24.0),
            
            chevronButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            chevronButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronButton.heightAnchor.constraint(equalToConstant: 11.9),
            chevronButton.widthAnchor.constraint(equalToConstant: 11.9),
            
            contentStack.leadingAnchor.constraint(equalTo: checkMark.trailingAnchor, constant: 12.0),

            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            infoStack.trailingAnchor.constraint(equalTo: chevronButton.trailingAnchor, constant: -16),
    

            priorityIcon.heightAnchor.constraint(equalToConstant: 20),
            priorityIcon.widthAnchor.constraint(equalToConstant: 18),

            title.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: infoStack.trailingAnchor),
            
            calendarIcon.heightAnchor.constraint(equalToConstant: 16.0),
            calendarIcon.widthAnchor.constraint(equalToConstant: 16.0),
            
        ])
    }
    
    private let checkMark: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = Constants.supportSeparator
        button.clipsToBounds = true
        return button
    } ()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = UIButton.Configuration.plain()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = Constants.colorGray
        button.clipsToBounds = true
        return button
    } ()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 3.0
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    } ()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        return stack
    } ()
    
    private let priorityIcon: UIImageView = {
        let imageView = UIImageView(image: Constants.highPriorityIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()
    
    private let title: UITextView = {
        let textView = UITextView()
        textView.text = "Сделать домашку по ШМР"
        textView.font = Constants.SFProRegularFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.backgroundColor = .clear
        textView.textColor = Constants.labelPrimary
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.sizeToFit()
        return textView
    } ()
    
    private let deadlineStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2.0
        return stack
    } ()
    
    private let calendarIcon: UIImageView = {
        let imageView = UIImageView(image: Constants.calendarIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.labelTertiary
        return imageView
    } ()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "14 июня"
        label.font = Constants.SFProRegularFont15
        label.textColor = Constants.labelTertiary
        return label
    } ()
    
}


