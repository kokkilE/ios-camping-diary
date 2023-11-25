# 캠핑 다이어리

> 캠핑 일기를 기록할 수 있는 앱입니다.
> - 네이버 지도로 캠팡장을 검색할 수 있습니다.
> - 작성한 일기는 로컬 데이터베이스에 저장됩니다.
> - 기기에 저장된 사진을 일기에 첨부할 수 있습니다.
> 
> 프로젝트 기간: 2023.11.06 ~ 2023.11.21
> [Github 소스 코드 링크](https://github.com/kokkilE/ios-camping-diary)

</br>

## 개발 인원
| 조향래 |
| :---: |
| <Img src = "https://hackmd.io/_uploads/SJL_ZRGw2.jpg" height=300> |
| [Github Profile](https://github.com/kokkilE) |

</br>

## 목차
1. [개발 환경](#1-개발-환경)

    1.1. [프레임워크](#11-프레임워크)

    1.2. [라이브러리](#12-라이브러리)

    1.3. [아키텍처](#13-아키텍처)

    1.4. [의존성 관리 도구](#14-의존성-관리-도구)

2. [프로젝트 구조](#2-프로젝트-설명)

    2.1. [개요](#21-개요)

    2.2. [도식화된 구조](#22-도식화된-구조)
    
3. [구현 기능](#3-구현-기능)

    3.1. [홈 화면](#31-홈-화면)

    3.2. [검색 화면](#32-검색-화면)
   
    3.3. [일지 화면](#33-일지-화면)

    3.4. [장소 선택 화면](#34-장소-선택-화면)



</br>

## 1. 개발 환경
<img src = "https://img.shields.io/badge/swift-5.9-orange"> <img src = "https://img.shields.io/badge/Xcode-14.0-orange"> <img src = "https://img.shields.io/badge/Minimum%20Deployments-14.0-orange">

### 1.1. 프레임워크
<img src = "https://img.shields.io/badge/UIKit--green"> <img src = "https://img.shields.io/badge/PhotosUI--green">

### 1.2. 라이브러리
<img src = "https://img.shields.io/badge/NMapsMap--green"> <img src = "https://img.shields.io/badge/RxSwift--green"> <img src = "https://img.shields.io/badge/RxGesture--green"> <img src = "https://img.shields.io/badge/Moya--green"> <img src = "https://img.shields.io/badge/Realm--green">

### 1.3. 아키텍처
<img src = "https://img.shields.io/badge/MVVM--green">

### 1.4. 의존성 관리 도구
<img src = "https://img.shields.io/badge/CocoaPods--green">

</br></br>

## 2. 프로젝트 구조
### 2.1. 개요
MVVM 패턴을 적용하였고, RxSwift을 사용하여 구현하였습니다.

| UI | 아키텍처 | 반응형 프레임워크 |
| :---: | :---: | :---: |
| UIKit | MVVM | RxSwift |

다음과 같이 각 뷰는 뷰모델을 통해 DataManager 상호작용을 하는 방향으로 구현하였습니다. 
앱 전역에서 관리되는 데이터는 뷰모델이 직접 관리하지 않고 DataManager를 통해 관리하였으며, 특정 화면에 일시적으로 종속되는 데이터는 뷰모델이 직접 관리하도록 구현하였습니다.

<img src="https://hackmd.io/_uploads/BkupBBazp." width=600>

</br></br>

앱 실행 중 편집된 내 캠핑장과 캠핑 일지 데이터는 LocalDB에 저장됩니다. 
LocalDB는 애플에서 제공하는 프레임워크인 `CoreData`와 외부 라이브러리 중 고민하였으며, 비교적 간단히 사용할 수 있는 외부 라이브러리인 `Realm`을 선택하여 사용하였습니다.
`CoreData`는 기본 타입의 자료형 외에 사용자 정의 타입을 저장하는 경우 추가 작업이 필요하기 때문입니다.

</br>

### 2.2. 도식화된 구조
주요 기능을 하는 타입들만 도식화하였습니다.

</br>

![](https://hackmd.io/_uploads/ByNnwfyHT.png)

</br></br>

## 3. 구현 기능
앱은 4개 화면으로 구성되어 있습니다.
- 홈 화면
    - 검색 화면 
- 일지 화면
    - 장소 선택 화면

### 3.1. 홈 화면
| <img src="https://hackmd.io/_uploads/ByG1VujVT.png" width=300> | <img src="https://hackmd.io/_uploads/rJz1VuoEp.png" width=300> | <img src="https://hackmd.io/_uploads/Bkz1VdoEp.png" width=300> | <img src="https://hackmd.io/_uploads/rJf14OoV6.png" width=300> |
| :---: | :---: | :---: | :---: |
- 앱 실행 시 사용자의 위치 정보 접근 권한을 요청합니다.
- 홈 화면은 검색이 가능한 지도 뷰와 `UICollectionView`로 구성됩니다.
- 캠핑 일지는 가로 스크롤로 구현됩니다. 
    - 캠핑 일지의 첫 번째 셀을 터치하면 데이터가 비어있는 캠핑 일지 화면이 표시됩니다.
    - 작성된 캠핑 일지 셀을 터치하면 선택된 데이터가 표시되는 캠핑 일지 화면이 표시됩니다.
    - 셀을 길게 터치하면 캠핑 일지를 삭제할 수 있는 Alert이 표시됩니다.
- 검색 창에 검색어를 입력하면 검색 버튼이 활성화됩니다. 검색 버튼을 터치하면 검색 화면이 표시됩니다.

</br>

### 3.2. 검색 화면
| <img src="https://hackmd.io/_uploads/rJf14OoV6.png" width=300> | <img src="https://hackmd.io/_uploads/HJfk4_oE6.png" width=300> |
| :---: | :---: |
- 홈 화면에서 검색 창에 검색 버튼을 터치하면 검색 화면이 표시됩니다.
- 검색 결과는 5개까지 리스트 셀로 표시됩니다.
- 셀의 별 모양 버튼을 클릭하면 해당 장소가 `내 캠핑장`에 저장됩니다.

</br>

### 3.3. 일지 화면
| <img src="https://hackmd.io/_uploads/ryhDUdoVT.jpg" width=300> | <img src="https://hackmd.io/_uploads/SJfJVOiVa.png" width=300> | <img src="https://hackmd.io/_uploads/ryfkVui4p.png" width=300> | <img src="https://hackmd.io/_uploads/B1tCUuiET.jpg" width=300> |
| :---: | :---: | :---: | :---: |
- 일지 화면은 캠핑장, 사이트, 방문일, 사진 목록, 일지로 구성됩니다.
- 캠핑장의 우측에 지도 버튼을 클릭하면 캠핑장을 선택할 수 있는 장소 선택 화면이 표시됩니다.
    - 장소 선택 화면에서는 내 캠핑장과 검색 결과를 선택하여 표시할 수 있습니다.
- 방문일의 텍스트 필드를 터치하면 `UIDatePicker`가 표시되고, 원하는 일자를 선택하면 텍스트 필드에 표시됩니다.
- 사진이 표시되는 컬렉션뷰의 첫 번째 셀을 터치하면 사진을 선택할 수 있는 `PHPickerViewController`가 표시됩니다.

</br>

### 3.4. 장소 선택 화면
| <img src="https://hackmd.io/_uploads/SJfJVOiVa.png" width=300> | <img src="https://hackmd.io/_uploads/rJsUhWJr6.jpg" width=300> |
| :---: | :---: |
- 캠핑장의 우측에 지도 버튼을 클릭하면 캠핑장을 선택할 수 있는 장소 선택 화면이 표시됩니다.
- 내 캠핑장과 검색 결과를 선택하여 표시할 수 있습니다.

</br></br>
