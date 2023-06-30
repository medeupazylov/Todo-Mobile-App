import UIKit

class NewItemCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackground()
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(background)
        contentView.addSubview(curvedBackground)
        contentView.addSubview(label)
    }
    
    private func setupBackground() {
        contentView.backgroundColor = Constants.backPrimary
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            background.heightAnchor.constraint(equalToConstant: 30),
            curvedBackground.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            curvedBackground.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52.0),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let curvedBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backSecondary
        view.layer.cornerRadius = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новое"
        label.font = Constants.SFProRegularFont
        label.textColor = Constants.labelTertiary
        return label
    } ()
        
}
