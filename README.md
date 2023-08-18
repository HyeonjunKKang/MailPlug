# MailPlug

##  **아키텍처: MVVM-C + CleanArchitecutre**

<img alt="CleanArchitecutre" src="https://github.com/HyeonjunKKang/MailPlug/assets/121999075/cf97f4da-3548-48c7-8b50-3d5b7e2f2c10">

- 앱의 확장을 고려해 이에 용이한 아키텍처인 클린아키텍처를 선택하였습니다.
- 앱의 계층을 나누어 역할을 명확하게 분리하고 코드 가독성, 재사용성을 늘리도록 했습니다.
- Repository패턴을 이용해 DataSource를 캡슐화 했습니다.
- Repository패턴을 사용해 DataSource객체와 Domain객체를 분리하였습니다.
- DataSource를 Local과 Remote로 분리하였습니다.
- View -> ViewModel -> UseCase -> Repository -> DataSource 로 레이어를 나누어 의존성이 outer에서 inner로 향하도록 구현했습니다.

## RxSwift + MVVM-C

- 의존성 주입 코드를 코디네이터로 분리하였습니다.
- ViewController의 화면 전환 로직을 분리하였습니다.
- 코디네이터를 활용해 화면의 흐름을 파악하기 쉽도록 구현하였습니다.
- 게시판을 선택하는 MenuViewController에서 RxDataSource를 활용하여 섹션의 확장에 용이하게 하도록 하였습니다.
- Rx의 Trait들을 활용하여 Thread-Safe하도록 구현하였습니다.

## CoreData

- 검색 기록을 로컬에 저장하기 위해 코어데이터를 사용하였습니다.
- 검색 기록이 무수히 많아질 수 있고, Model 형식으로 저장하고 추가 기능이 필요할 수 있기 때문에 UserDefault가 아닌 iOS 기본 프레임워크인 CoreData를 사용했습니다.

## DIContainer

- 의존성 주입을 한곳에서 모두 관리하도록 구현하였습니다.

## NetworkLayer

<img alt="NetworkLayer1" src="https://github.com/HyeonjunKKang/MailPlug/assets/121999075/643c5140-07e5-4ef5-90ad-ed4d9a79df3a">
<img alt="NetworkLayer2" src="https://github.com/HyeonjunKKang/MailPlug/assets/121999075/415e066e-314b-4922-af4c-32539b152462">

- NetworkLayer를 분리하였습니다.

## ViewModel

<img alt="ViewModel" src="https://github.com/HyeonjunKKang/MailPlug/assets/121999075/587ac740-7f1e-4245-af6b-9d6556f19a45">

- ViewModel마다 navigation(PublishSubject)를 두어 화면전환에 필요한 로직을 담당하도록 했습니다.
- ViewModel프로토콜을 만들어 사용헀습니다.
- In-Out패턴을 사용해 Input과 Output을 명확하게 확인할 수 있도록 했습니다.
- Bind의 요소들을 분리하여 가독성을 높혔습니다.

## ViewController

<img alt="ViewController" src="https://github.com/HyeonjunKKang/MailPlug/assets/121999075/358e90fe-d9b7-4bf4-abe7-4729e2ee09fb">

- UIViewController를 상속받은 ViewController를 생성하여 이를 상속해 ViewController의 기본 세팅을 했습니다.
- ViewController는 온전히 View만 소지하여 로직에서 완전히 분리하였습니다.

## 구현 기능

### 게시글 리스트 화면
- 요구사항을 모두 구현하였습니다.

### 검색 화면
- 요구사항을 모두 구현하였습니다.
- 검색내역 삭제 기능을 구현하였습니다.

## 사용 라이브러리
- RxSwift
- RxDataSource
- Swinject
- Alamofire
- Then
- SnapKit
