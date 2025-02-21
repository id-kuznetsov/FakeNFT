Торопов Александр Вадимович\
<b>Когорта:</b> 22\
<b>Группа:</b> 1\
<b>Эпик:</b> Профиль\
<b>[Ссылка на доску](https://github.com/users/id-kuznetsov/projects/2/views/5)</b>

# Декомпозиция эпика Профиль

## Модуль 1:
#### Profile Screen
- Модель Profile (est: 30 мин; fact: x часов)
- Протокол ProfileViewModel (est: 2 часа; fact: x часов)
- ProfileCardView (AvatarImageView + UserNameLabel + DescriptionLabel) (est: 1 часа; fact: x часов)
- ProfilerService (protocol) (est: 2 часа; fact: x часов)
- ProfileServiceImpl (mock data) (est: 1 часа; fact: x часов)
- Верстка ProfileViewController (ProfileCardView + LinkButton + RoutingTableView + EditBarButtonItem) (est: 3 часа; fact: x часов)
- ProfileViewModelImpl (est: 3 часа; fact: x часов)
- Observable<T> (обертка для биндинга данных) (est: 10 мин; fact: x часов)
- Биндинг данных (est: 30 мин; fact: x часов)
- ProfileRequest (est: 30 мин; fact: x часов)
- ProfileServiceImpl (данные с бэка) (est: 1 час; fact: x часов)
- WebViewViewController (переход с ячейки "О разработчике" + переход по линку на сайт пользователя) (est: 2 часа; fact: x часов)

## Модуль 2:
#### ProfileEditing Screen
- ProfileEditingViewModel (protocol) (est: 2 часа; fact: x часов)
- EditTextField (Имя, сайт) (est: 1 час; fact: x часов)
- Верстка ProfileEditingViewController (EditAvatarButton + NameEditTextField + DescriptionEditTextView + SiteEditTextView) (est: 3 часа; fact: x часов)
- Подписать модель Profile под протокол Dto (est: 30 мин; fact: x часов)
- Расширение протокола ProfileService (PUT request) (est: 1 час; fact: x часов)
- ProfileServiceImpl (mock data) (est: 1 часа; fact: x часов)
- ProfileEditingViewModel (est: 2 часа; fact: x часов)
- Биндинг данных (est: 30 мин; fact: x часов)
- Внедрение UIImagePicker или PHPickerViewController для смены AvatarImage (неуверен, для меня неизвестные компоненты) (est: ??? часа; fact: x часов)
- ProfilePutRequest (est: 30 мин; fact: x часов)
- ProfileServiceImpl (отправка PUT запроса на бэк) (est: 1 час; fact: x часов)

## Модуль 3:
#### MyNft Screen
- NftCardView (UIImageView + FavouriteButton) (est: 1 час; fact: x часов)
- Верстка RaitingView (est: 1 час; fact: x часов)
- MyNftCellModel (est: 30 мин; fact: x часов)
- Верстка ячейки MyNftCell (est: 1 час; fact: x часов)
- FavouritesNftService (Добавление в избранное) (est: 2 часа; fact: x часов)
- MyNftViewModel (protocol) (est: 2 час; fact: x часов)
- MyNftViewModelImpl (mock данные, потом прокинуть зависимость NftService) (est: 2 часа; fact: x часов)
- Верстка MyNftViewController (UITableView + SortBarButtonItem) (est: 3 часа; fact: x часов)
- Биндинг данных (est: 30 мин; fact: x часов)
- Внедрение логики сортировки на экране MyNft Screen (Alert + ViewModel Methods) (est: 3 часа; fact: x часов)

#### Favourites Screen
- Верстка ячейки FavouritesNftCell (est: 1 час; fact: x часов)
- FavouritesNftViewModel (est: 2 часа; fact: x часов)
- FavouritesNftViewModelImpl (NftService + FavoutitesService) (est: 2 часа; fact: x часов)
- Верстка FavouriteNftViewController (UICollectionView) (est: 3 часа; fact: x часов)
- Биндинг данных (est: 30 мин; fact: x часов)



