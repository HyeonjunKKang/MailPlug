//
//  BoardService.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Alamofire
import RxSwift

struct BoardService: BoardServiceProtocol{
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func fetch() -> Observable<BoardResponseDTO> {
        return provider.request(BoardTarget.fetch)
    }
}

enum BoardTarget {
    case fetch
}

extension BoardTarget: TargetType {
    var baseURL: String {
        return "https://mp-dev.mail-server.kr/api/v2/boards"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetch: return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .fetch: return nil
        }
    }
}
