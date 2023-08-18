//
//  ViewModel.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
