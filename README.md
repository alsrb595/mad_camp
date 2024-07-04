A new Flutter project.

## Getting Started

Team: 강지우, 정민규

휴대폰 속 어딘가에 숨어 있는 여행가서 얻은 소중한 인연, 잊지 못할 추억들을 관리하고 추억하게 해줄 수 있는 플러터 기반으로 제작한 앱입니다. 

여행 기록 도우미 ‘Trip-Minder’는 Trip + Reminder를 합친 단어로, 여행에서 만난 사람들 한명 한명의 연락처와 포토를 보여주는 앱입니다.
여행을 좋아하는 분들이 사용한느 앱인만큼 비행기 티켓 예매와 모바일 티켓 저장이 가능합니다. 

## Tab1: People
외국인 친구와 연락처 교환할 때 서로 자주 사용하는 연락 수단이 다를 수 있습니다.
친구가 알려주었던 연락수단과 연락처를 한번에 볼 수 있고, 첫인상이나 특징들을 기록할 수 있습니다.

<img src="https://github.com/alsrb595/mad_camp/assets/127878736/fccf5265-fc68-4289-bf78-6da3bd6b550d" width="300"/>
<img src="https://github.com/alsrb595/mad_camp/assets/127878736/7c7a9988-5a8e-4cf1-8000-dc57520ff856" width="300"/>

Widgets :  `GridView`로 격자 모양으로 각 사람별 정보를 저장,  `AlertDialog` 이용해서 친구 정보 추가,  `SharedPreference` 사용해서 앱을 껐다 켜도 저장되도록 했습니다.

`Provider`를 사용해서 친구 정보 추가 시 자동으로 그 친구의 사진 폴더가 생성되도록 하여 탭 2와 연동했습니다. 

연락 수단 시 저장해 놓은 문자열을 그래로 입력하지 않을 시 로고와 매치가 이루어지지 않기 떄문에 `DropdownButton`을 사용하여 사용자가 입력이 아니라 선택할 수 있도록 했습니다.

상단의 검색창을 이용하면 이름, 아이디, 지역, 특징 뭐로 검색을 하던 검색이 가능하도록 구현했습니다. 

친구의 정보를 꾹 누르면 `AlterDialog`를 이용해 친구 정보를 수정할 수 있는 Dialog가 나오도록 구현횄습니다. 

이외에도 기본적인 산텍 모드로 들어가 선택하여 삭제하는 기능, 이름, 아이디, 지역, 특징 4가지 모두로  검색이 가능하도록 구현을 했습니다.



## Tab2: Folders
People 탭에서 소중한 인연을 추가할 때마다 Photos 탭에 사진 폴더가 생깁니다.
휴대폰 갤러리 속 수많은 사진들 중 정확히 그 사람과 함께했던 순간들을 폴더 별로 정리하여 저장할 수 있습니다.

<img src="https://github.com/alsrb595/mad_camp/assets/127878736/2c95a801-f16c-4f71-b317-79f4b29c3590" width="300"/>
<img src="https://github.com/alsrb595/mad_camp/assets/127878736/964f28b2-7e6c-4c50-8c5a-e19b7244ca33" width="300"/>
<img src="https://github.com/alsrb595/mad_camp/assets/127878736/bbaf3c97-e398-4a62-a713-91072ed10883" width="300"/>

Widgets : `GridView`로 격자 모양의 사람별 폴더 제작, `SharedPreference`에 폴더 속 이미지를 기록하여 폴더 미리보기 화면을 폴더 속 첫 이미지로 반영


## Tab3 : Tickets
여행기록들을 정리하다보면 새로운 여행을 계획하게 되는 유저들을 위한 탭입니다.
대한항공과 아시아나항공을 비롯한 국내 대표 항공사 9곳의 항공권 예매 홈페이지로 이동할 수 있고, 화면 하단에는 곧 예정된 여행에 대한 모바일 항공권 티켓을 저장할 수 있습니다.

<img src="https://github.com/alsrb595/mad_camp/assets/127878736/fdf80daf-5f30-428d-b6f2-30481d2bfcc7" width="300"/>
<img src="https://github.com/alsrb595/mad_camp/assets/127878736/d992bd03-da94-4525-913b-417fc665a9a6" width="300"/>

Widgets : `ListView`로 국내 항공사 9곳에 대한 아이콘 제작

`url_Launcher` 패키지로 아이콘 버튼과 하이퍼링크 연결하여 브라우저로 이동가능하게 함, 각 항공사별 아이콘, url, 국문이름을 리스트로 만들어 `ListView`내  `Column`에서 list의 index으로 한번에 접근하게 함

`DraggableScrollableSheet`을 이용하여 아래에 유지되어있는 티켓 정보를 위로 드래그 시 나올 수 있게 구현

## Demo Videos

1 : People 탭에서 새 연락처 추가 및 Photos 탭과 연동

2 : 연락처 선택 후 삭제 기능

2 : 추가된 연락처 수정

3 : Photos 탭에서 새 폴더 추가/삭제 기능 및 폴더 내 이미지 화면

4 : Ticket 탭에서 항공사 예매 사이트 이동 및 화면 하단 티켓 스크롤 기능

https://github.com/alsrb595/mad_camp/assets/127878736/3bfdff59-6937-41d1-bd06-082dcd069b05

https://github.com/alsrb595/mad_camp/assets/127878736/1ceec3ce-4314-4e9a-b9fd-cc9fc3240d9c

https://github.com/alsrb595/mad_camp/assets/127878736/72608a5c-d720-4b00-956f-4509b24392fa

https://github.com/alsrb595/mad_camp/assets/127878736/45f804ae-cfa8-4215-be61-a5416927e522


## 배운점 및 느낀점

- 정민규

: 개발 경험이 거의 없어 걱정했지만  일주일 동안 개발을 하면서 많이 배운 것 같습니다. GitHub 사용이 처음이라 많이 당황했지만 많이 사용해보며 그래도 이제 깃허브에 대한 이해가 확실히 된 것 같습니다. 플러터도 아직 잘한다고는 말할 수 없지만 그래도 플러터의 코드를 보고 이해할 수 있다 정도는 된 것 같아 뿌듯합니다. 코딩을 하며 클린 코드의 중요성을 느꼈습니다. 하나의 기능을 추가하고 무언가를 바꾸려 할 때마다 엄청 나게 많은 양의 코드를 보며 어디를 얼마나 바꿔야 될 지 찾고 있는 자신을 보며 클린코딩의 중요성을 느꼈습니다. 

- 강지우

: 첫 개발인만큼 매우 많은 시행착오를 거쳐 제작한 앱입니다. 그래도 첫 개발 경험을 몰입캠프에서 할 수 있어 다행입니다. 생각했던 디자인도 최대한 완벽하게 하고 싶었고, 기능도 더 세밀하게 구현하고 싶었지만 주어진 시간이 길지 않은 이번 캠프에서는 두 마리 토끼를 모두 잡는게 어려운 것 같습니다. 선택과 집중을 배울 수 있는 시간이었습니다.




