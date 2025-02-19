Ерёменко Николай Олегович\
<b>Когорта:</b> 22\
<b>Группа:</b> 1\
<b>Эпик:</b> Каталог\
<b>[Ссылка на доску](https://github.com/users/id-kuznetsov/projects/2/views/3)</b>

# Декомпозиция эпика Каталог

## Модуль 1:

#### Collections Screen
- CollectionsDataProvider(mock data) (est: 2 часа; fact: x часов)
- CollectionsViewModel (est: 3 часа; fact: x часов)
- CollectionsViewController (est: 5 часа; fact: x часов)
- CollectionTableViewCell (est: 4 часа; fact: x часов)

#### Collection Screen
- CollectionDataProvider(mock data) (est: 2 часа; fact: x часов)
- CollectionViewModel (est: 3 часа; fact: x часов)
- NFTCollectionView (est: 3 часа; fact: x часов)
- CollectionViewController(with NFTCollectionView) (est: 5 часа; fact: x часов)
- NFTCollectionViewCell (est: 4 часа; fact: x часов)

## Модуль 2:
#### NFTCard Screen
##### Логика
- NFTCardDataProvider(mock data) (est: 2 часа; fact: x часов)
- NFTCardViewModel (est: 2 часа; fact: x часов)
##### Верстка
- NFTImagesCollectionView (est: 3 часа; fact: x часов)
- NFTImageCollectionViewCell (est: 3 часа; fact: x часов)
- CurrencyTableViewCell (est: 2 часа; fact: x часов)
- NFTCardViewController(with NFTImagesCollectionView, NFTCollectionView) (est: 4 часа; fact: x часов)
#### Работа с сетью
##### Collections Screen
- GET NFTCollections (est: 3 часа; fact: x часов)
##### Collection Screen
- GET NFTCollection (est: 3 часа; fact: x часов)
- GET NFTs for collection (est: 3 часа; fact: x часов)
- PUT favorite NFT (est: 3 часа; fact: x часов)м
- PUT cart (est: 3 часа; fact: x часов)

## Module 3:
#### Sort catalog, network, errors and states
- Network errors (est: 4 часа; fact: x часов)
- Load state (est: 6 часа; fact: x часов)
##### Logic
- Сортировка коллекций по названию (est: 3 часа; fact: x часов)
- Сортировка коллекций по количеству NFT (est: 3 часа; fact: x часов)
###### NFTCard Network
- GET NFT request (est: 4 часа; fact: x часов)
- GET currencies request (est: 4 часа; fact: x часов)
- GET array of NFT request (est: 4 часа; fact: x часов)
- Favorite NFT (est: 4 часа; fact: x часов)
- Cart (est: 4 часа; fact: x часов)
