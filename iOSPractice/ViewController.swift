//
//  ViewController.swift
//  iOSPractice
//
//  Created by 이태영 on 2023/05/02.
//

import UIKit

final class ViewController: UIViewController {
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = .gray
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("돌리기", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(nil, action: #selector(tapStartButton), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("멈추기", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(nil, action: #selector(tapStopButton), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubview()
        configureLayout()
    }
}

// MARK: Action Method
extension ViewController {
    @objc private func tapStartButton() {
        indicatorView.startAnimating()
    }
    
    @objc private func tapStopButton() {
        indicatorView.stopAnimating()
    }
}

// MARK: UI Configuration
extension ViewController {
    private func configureSubview() {
        [startButton, stopButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [indicatorView, buttonStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            buttonStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            buttonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
