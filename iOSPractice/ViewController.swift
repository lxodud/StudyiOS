//
//  ViewController.swift
//  iOSPractice
//
//  Created by 이태영 on 2023/05/02.
//

import UIKit

final class ViewController: UIViewController {
    let someView = CustomView()
    
    override func viewDidLoad() {
        configureLayout()
    }
}

extension ViewController {
    private func configureLayout() {
        view.addSubview(someView)
        someView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            someView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            someView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            someView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.5),
            someView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
        ])
    }
}
