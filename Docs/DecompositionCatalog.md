Ерёменко Николай Олегович\
<b>Когорта:</b> 22\
<b>Группа:</b> 1\
<b>Эпик:</b> Каталог\
<b>[Ссылка на доску](https://github.com/users/id-kuznetsov/projects/2/views/3)</b>

# Декомпозиция эпика Каталог

## Part 1:

#### Collections Screen
- CollectionsDataProvider(mock data) (est: 2 часа; fact: 2 часа)
- CollectionsViewModel (est: 3 часа; fact: 3 часа)
- CollectionsViewController (est: 5 часа; fact: 5 часов)
- CollectionsTableViewCell (est: 4 часа; fact: 4 часа)

#### Collection Screen
- CollectionDataProvider(mock data) (est: 2 часа; fact: 3 часа)
- CollectionViewModel (est: 3 часа; fact: 3 часа)
- CollectionViewController(with NFTCollectionView) (est: 5 часа; fact: 6 часов)
- NFTCollectionViewCell (est: 4 часа; fact: 4 часа)
- CollectionHeaderView (est: 3 часа; fact: 4 часа)

#### Image Loading
- add ImageLoaderService (est: 2 часа; fact: 3 часа)
- add loading animations (est: 2 часа; fact: 3 часа)

#### WebView
- WebViewModel (est: 3 часа; fact: 2 часа)
- WebViewController (est: 3 часа; fact: 3 часа)

#### AlertPresenter
- refactor AlertPresenter (est: 5 часа; fact: 4 часа)
- refactor ErrorView (est: 2 часа; fact: 3 часа)
- add FilterView (est: 2 часа; fact: 2 часа)
- add NFTRatingView (est: 2 часа; fact: 2 часа)
- add NFTRatingAlertViewController (est: 2 часа; fact: 4 часа)

## Part 2:

#### Работа с сетью
##### Collections Screen
- GET NFTCollections (est: 3 часа; fact: x часа)
##### Collection Screen
- GET NFTCollection (est: 3 часа; fact: x часа)
- GET NFTs for collection (est: 3 часа; fact: x часа)
- PUT favorite NFT (est: 3 часа; fact: x часа)
- PUT cart (est: 3 часа; fact: x часа)

## Part 3:
#### Sort catalog, network, errors and states
- Network errors (est: 4 часа; fact: x часа)
- Load state (est: 6 часа; fact: x часа)
##### Logic
- Сортировка коллекций по названию (est: 3 часа; fact: x часа)
- Сортировка коллекций по количеству NFT (est: 3 часа; fact: x часа)
###### NFTCard Network
- GET NFT request (est: 4 часа; fact: x часа)
- GET currencies request (est: 4 часа; fact: x часа)
- GET array of NFT request (est: 4 часа; fact: x часа)
- Favorite NFT (est: 4 часа; fact: x часа)
- Cart (est: 4 часа; fact: x часа)
