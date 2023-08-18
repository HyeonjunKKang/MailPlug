//
//  TargetType.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Alamofire
import Foundation

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var header: HTTPHeaders { get }
    var path: String { get }
    var parameters: RequestParams? { get }
}

extension TargetType {
    
    var header: HTTPHeaders {
        return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODgxMDM5NDAsImV4cCI6MCwidXNlcm5hbWUiOiJtYWlsdGVzdEBtcC1kZXYubXlwbHVnLmtyIiwiYXBpX2tleSI6IiMhQG1wLWRldiFAIyIsInNjb3BlIjpbImVhcyJdLCJqdGkiOiI5MmQwIn0.Vzj93Ak3OQxze_Zic-CRbnwik7ZWQnkK6c83No_M780"]
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.asURL()
        var urlRequest = try URLRequest(url: url, method: method)
//        let url = try baseURL.asURL()
//
//        // appendingPathComponent 사용 시 path 내 ?를 %3f로 인식하여 임시 처리
//        var urlRequest = try URLRequest(url: url.absoluteString + path, method: method)
        urlRequest.headers = header
        
        switch parameters {
        case let .query(request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
        case let .body(request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
            
        case .none:
            return urlRequest
        }
        
        return urlRequest
    }
}

enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        
        return dictionaryData
    }
}
