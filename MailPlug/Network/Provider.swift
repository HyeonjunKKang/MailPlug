//
//  Provider.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import Alamofire
import RxSwift

struct EmptyResponse: Decodable {}
struct EmptyParameter: Encodable {}

class Provider {
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    static let `default`: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let session = Session(configuration: configuration)
        
        return Provider(session: session)
    }()
    
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self, completionHandler: { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@@")
                    
                    switch response.result {
                    case let .success(data):
                        emitter.onNext(data)
                    case let .failure(error):
                        emitter.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func request(_ urlConvertible: URLRequestConvertible) -> Observable<Void> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .response { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@")
                    switch response.result {
                    case .success:
                        emitter.onNext(())
                    case let .failure(error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
