//
//  SearchService.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift
import Alamofire

struct SearchService: SearchServiceProtocol {
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func fetch(boardID: Int, request: SearchRequestDTO) -> Observable<SearchResponseDTO> {
        return provider.request(SearchTarget.fetch(boardID, request))
    }
}

enum SearchTarget {
    case fetch(Int, SearchRequestDTO)
}

extension SearchTarget: TargetType {
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
        case let .fetch(boardID, request):
            return "/\(boardID)/posts?search=\(request.search)&searchTarget=\(request.searchTarget)&offset=\(request.offset)&limit=\(request.limit)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .fetch:
            return nil
        }
    }
}
