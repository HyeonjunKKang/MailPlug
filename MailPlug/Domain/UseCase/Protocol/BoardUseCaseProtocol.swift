//
//  BoardUseCaseProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import RxSwift

protocol BoardUseCaseProtocol {
    func fetch() -> Observable<[Board]>
}
