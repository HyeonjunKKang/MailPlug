//
//  ViewController.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
