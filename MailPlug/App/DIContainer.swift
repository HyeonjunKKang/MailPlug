//
//  DIContainer.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    let container = Container()
    private init() {}
    
    func inject() {
        registerDataSource()
        registerRepository()
        registerUseCase()
        registerViewModel()
    }
    
    private func registerDataSource() {
        container.register(BoardServiceProtocol.self) { _ in BoardService() }
        container.register(PostServiceProtocol.self) { _ in PostService() }
        container.register(LocalSearchServiceProtocol.self) { _ in LocalSearchService() }
        container.register(SearchServiceProtocol.self) { _ in SearchService() }
    }
    
    private func registerRepository() {
        container.register(BoardRepositoryProtocol.self) { resolver in
            var repository = BoardRepository()
            repository.boardDataSource = resolver.resolve(BoardServiceProtocol.self)
            
            return repository
        }
        
        container.register(PostRepositoryProtocol.self) { resolver in
            var repository = PostRepository()
            repository.postService = resolver.resolve(PostServiceProtocol.self)
            repository.remoteSearchService = resolver.resolve(SearchServiceProtocol.self)
            
            return repository
        }
        
        container.register(SearchRepositoryProtocol.self) { resolver in
            var repository = SearchRepository()
            repository.localRecentSearchServicel = resolver.resolve(LocalSearchServiceProtocol.self)
            
            return repository
        }
    }
    
    private func registerUseCase() {
        container.register(BoardUseCaseProtocol.self) { resolver in
            var useCase = BoardUseCase()
            useCase.boardRepository = resolver.resolve(BoardRepositoryProtocol.self)
            
            return useCase
        }
        
        container.register(ThreadUseCaseProtocol.self) { resolver in
            var useCase = ThreadUseCase()
            useCase.postRepository = resolver.resolve(PostRepositoryProtocol.self)
            
            return useCase
        }
        
        container.register(RecentSearchUseCaseProtocol.self) { resolver in
            var useCase = RecentSearchUseCase()
            useCase.searchRepository = resolver.resolve(SearchRepositoryProtocol.self)
            
            return useCase
        }
        
        container.register(SearchResultUseCaseProtocol.self) { resolver in
            var useCase = SearchResultUseCase()
            useCase.postRepository = resolver.resolve(PostRepositoryProtocol.self)
            
            return useCase
        }
        
    }
    
    private func registerViewModel() {
        container.register(ThreadViewModel.self) { resolver in
            var viewModel = ThreadViewModel()
            viewModel.boardUseCase = resolver.resolve(BoardUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(MenuViewModel.self) { resolver in
            var viewModel = MenuViewModel()
            viewModel.boardUseCase = resolver.resolve(BoardUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(SearchViewModel.self) { resolver in
            var viewModel = SearchViewModel()
            viewModel.recentSearchUseCase = resolver.resolve(RecentSearchUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(SearchResultViewModel.self) { resolver in
            var viewModel = SearchResultViewModel()
            viewModel.searchResultUseCase = resolver.resolve(SearchResultUseCaseProtocol.self)
            
            return viewModel
        }
        
    }
}
