//
//  CustomView.swift
//  iOSPractice
//
//  Created by 이태영 on 2023/05/21.
//

import UIKit

final class CustomButton: UIButton {
    init() {
        super.init(frame: .zero)
        setTitle("하이", for: .normal)
        setTitleColor(.red, for: .normal)
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}

final class CustomView: UIView {
    let button = CustomButton()
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        
    }
}

extension CustomView {
    private func configureLayout() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
