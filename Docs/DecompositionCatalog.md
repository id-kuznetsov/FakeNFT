Ерёменко Николай Олегович\
<b>Когорта:</b> 22\
<b>Группа:</b> 1\
<b>Эпик:</b> Каталог\
<b>[Ссылка на доску](https://github.com/users/id-kuznetsov/projects/2/views/3)</b>

# Декомпозиция эпика Каталог

## Part 1:

#### Collections Screen
- CollectionsService(mock data) (est: 2 часа; fact: 2 часа)
- CollectionsViewModel (est: 3 часа; fact: 3 часа)
- CollectionsViewController (est: 5 часа; fact: 6 часов)
- CollectionsTableViewCell (est: 4 часа; fact: 5 часа)

#### Collection Screen
- NftsService(mock data) (est: 2 часа; fact: 2 часа)
- UsersService(mock data) (est: 2 часа; fact: 2 часа)
- CollectionViewModel (est: 3 часа; fact: 2 часа)
- CollectionViewController (est: 5 часа; fact: 6 часов)
- CollectionHeaderView (est: 4 часа; fact: 5 часа)
- NFTCollectionViewCell (est: 4 часа; fact: 4 часа)

#### Image Loading
- ImageLoaderService (est: 2 часа; fact: 3 часа)
- loading animations (est: 2 часа; fact: 3 часа)

#### WebView
- WebViewViewModel (est: 3 часа; fact: 2 часа)
- WebViewController (est: 3 часа; fact: 3 часа)

#### AlertPresenter
- AlertPresenter (est: 5 часа; fact: 4 часа)
- ErrorView (est: 2 часа; fact: 3 часа)
- FilterView (est: 2 часа; fact: 2 часа)
- NFTRatingView (est: 2 часа; fact: 2 часа)
- NFTRatingAlertViewController (est: 2 часа; fact: 4 часа)

## Part 2:

#### Работа с сетью и кэш
##### Collections Screen
- CollectionsRequest (est: 2 часа; fact: 2 часа)
- FetchCollections (est: 3 часа; fact: 4 часа)
- CollectionsViewController State (est: 2 часа; fact: 3 часа)
- Collections Errors (est: 2 часа; fact: 2 часа)
- Collections paging (est: 2 часа; fact: 4 часа)
- Collections sorting (est: 3 часа; fact: 3 часа)
- Collections sort options storage (est: 2 часа; fact: 2 часа)
- LoadingView (est: 2 часа; fact: 2 часа)
- Delete ProgressHud (est: 1 часа; fact: 1 часа)
- Collections placeholder cell (est: 2 часа; fact: 2 часа)
- CacheService (est: 5 часа; fact: 12 часа)
- NetworkMonitor (est: 1 часа; fact: 3 часа)

## Part 3:
#### Работа с сетью и кэш
##### Collection Screen
- CollectionServiceAssembly (est: 2 часа; fact: 2 часа)
- CollectionNftService (est: 3 часа; fact: 3 часа)
- Refactor CollectionViewModel State (est: 3 часа; fact: 3 часа)
- Refactor CollectionViewController (est: 4 часа; fact: 4 часа)
- CollectionViewController State (est: 3 часа; fact: 3 часа)
- Collections Errors (est: 1 часа; fact: 1 часа)
- Fix: filter duplicate nft ids (est: 3 часа; fact: 3 часа)
- CollectionProfileRequest (est: 3 часа; fact: 3 часа)
- Refactor(WebViewController): handle api author url bug (est: 2 часа; fact: 2 часа)
- NFT Like / Dislike (est: 3 часа; fact: 3 часа)
- Sort NFTs by Cart (est: 3 часа; fact: 3 часа)
- NFT add/delete from Cart (est: 3 часа; fact: 4 часа)
