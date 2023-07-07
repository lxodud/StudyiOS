//
//  ViewController.swift
//  iOSPractice
//
//  Created by 이태영 on 2023/05/02.
//

import UIKit

final class ViewController: UIViewController {
    let label = Label()
    let button = Button()
    let textField = TextField()
    
    var component: [AnyComponent] = []
    
    override func viewDidLoad() {
        component.append(AnyComponent(label))
        component.append(AnyComponent(button))
        component.append(AnyComponent(textField))
    }
}

protocol Componentable {
    associatedtype Content
    
    func getContentView() -> Content
}

struct Label: Componentable {
    typealias Content = UILabel
    
    func getContentView() -> UILabel {
        return UILabel()
    }
}

struct Button: Componentable {
    typealias Content = UIButton
    
    func getContentView() -> UIButton {
        return UIButton()
    }
}

struct TextField: Componentable {
    typealias Content = UITextField
    
    func getContentView() -> UITextField {
        return UITextField()
    }
}

protocol AnyComponentBase {
    func getContentView() -> Any
}

struct AnyComponentBox<ConcreteComponent: Componentable>: AnyComponentBase {
    var concrete: ConcreteComponent
    
    init(concrete: ConcreteComponent) {
        self.concrete = concrete
    }
    
    func getContentView() -> Any {
        return concrete.getContentView()
    }
}

struct AnyComponent: Componentable {
    private let box: AnyComponentBase
    
    init<Component: Componentable>(_ component: Component) {
        box = AnyComponentBox(concrete: component)
    }
    
    func getContentView() -> Any {
        return box.getContentView()
    }
}
