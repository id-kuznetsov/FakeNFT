Кузнецов Илья Дмитриевич\
<b>Когорта:</b> 22\
<b>Группа:</b> 1\
<b>Эпик:</b> Корзина\
[Ссылка на доску](https://github.com/users/id-kuznetsov/projects/2/views/4)

# Декомпозиция эпика Корзина

## Модуль 1(est: 8.5 часов; fact: 6.7 часов):

### Верстка экрана Корзина
1. **Таблица для выбранных NFT**  
   - Создание `UITableView` для отображения списка NFT (est: 1 час; fact: 1 час).
2. **Кастомная ячейка таблицы**  
   - Разработка кастомной ячейки с элементами: `ImageView`, название NFT, рейтинг, цена (est: 1 час; fact: 1 час).
3. **Кастомный Navigation Bar**  
   - Добавление кнопки фильтрации (est: 0.5 часа; fact: 0.5 часа).
4. **View с количеством, ценой и кнопкой оплаты**  
   - Создание нижней панели с суммой покупок и кнопкой перехода к оплате (est: 1 час; fact: 0.5 часа).

### Логика
5. **Изучение сетевого слоя**  
   - Ознакомление с архитектурой проекта и возможностями сетевого слоя (est: 1 час; fact: 1 час).
6. **Загрузка данных о выбранных NFT**  
   - Выполнение GET-запроса для получения списка покупок (est: 1 час; fact: 1 час).  
   - Обработка ответа сервера и преобразование данных в модельные объекты (est: 2 часа; fact: 1.5 часf).
   - Отображение и скрытие лоадера во время загрузки данных (est: 0.5 часа; fact: x часов).
7. **Расчет суммы покупки**  
   - Суммирование цен всех NFT в корзине и отображение результата на экране (est: 1 час; fact: 0.2 часа).

---

## Модуль 2(est: 16 часов; fact: 10 часов):

### Верстка экрана Корзина
1. **Показ окна выбора сортировки** 
   - Создание модального экрана с вариантами сортировки (est: 1 час; fact: 1 час).
### Верстка экрана выбора способа оплаты
2. **Заголовок с кнопкой возврата**  
   - Создание кастомного `title` и кнопки "Назад" (est: 1 час; fact: 0.5 часов).
3. **Коллекция доступных способов оплаты**  
   - Создание `UICollectionView` для отображения способов оплаты (est: 3 часа; fact: 2 часа).  
   - Кастомизация ячеек коллекции (est: 1 час; fact: 1 час).
4. **Пользовательское соглашение**  
   - Добавление текстового элемента со ссылкой на пользовательское соглашение (est: 1 час; fact: 1 час).
5. **Веб-вью для показа пользовательского соглашения**  
   - Реализация модального экрана с веб-вью для просмотра соглашения (est: 2 часа; fact: 1 час).
6. **Кнопка оплаты**  
   - Создание кнопки "Оплатить" (est: 1 час; fact: 0.5 часов).
#### Логика
6.  **Логика сортировки**
    - Реализация различных методов сортировки (по цене, рейтингу, по названию) (est: 2 часа; fact: 0.8 часа).
    - Сохранение выбранного метода сортировки (est: 1 час; fact: 0.2 часа).
7.  **Загрузка списка способов оплаты**  
  	 - Выполнение запроса для получения списка доступных способов оплаты (est: 3 часа; fact: 2 часа).

---

## Модуль 3(est: 10 часов; fact: 9 часов):

### Верстка
1. **Экран подтверждения удаления**  
   - Создание модального экрана с картинкой NFT, текстом предупреждения и двумя кнопками: "Удалить" и "Отмена" (est: 2 часа; fact: 1.5 часа).
2. **Экран успешной оплаты**  
   - Пустой экран с лейблом, `ImageView` и кнопкой "Вернуться в каталог" (est: 1 час; fact: 1 час).
3. **Alert об ошибке оплаты**  
   - Создание алерта с сообщением об ошибке и действиями: "Повторить" и "Отменить" (est: 1 час; fact: 1 час).
4. **Лейбл "Корзина пуста"**  
   - Отображение сообщения, если корзина пуста (est: 0.5 часа; fact: 0.5 часа).

### Логика
5. **Обработка успешной оплаты**  
   - Выполнение запроса для проверки статуса оплаты (est: 2 часа; fact: 2 часа).  
   - Отображение экрана успешной оплаты при положительном результате (est: 0.5 часа; fact: 0.5 часа).
6. **Обработка ошибки оплаты**  
   - Показ алерта об ошибке и реализация действий "Повторить" и "Отменить" (est: 1 час; fact: 1 час).
7. **Очистка корзины после успешной оплаты**  
   - Выполнение PUT-запроса для очистки корзины на сервере (est: 2 часа; fact: 1.5 часа).

