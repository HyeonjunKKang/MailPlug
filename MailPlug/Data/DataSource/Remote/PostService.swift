//
//  PostService.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import RxSwift
import Alamofire

struct PostService: PostServiceProtocol {
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func fetch(request: PostRequestDTO) -> Observable<PostResponseDTO> {
        return provider.request(PostTarget.fetch(request))
    }
}

enum PostTarget {
    case fetch(PostRequestDTO)
}

extension PostTarget: TargetType {
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
        case .fetch(let request):
            return "/\(request.boardID)/posts?offset=\(request.offset)&limit=\(request.limit)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .fetch:
            return nil
        }
    }
}
