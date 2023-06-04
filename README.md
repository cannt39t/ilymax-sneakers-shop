# ilymax-sneakers-shop

Интернет-магазин кроссовок, где продавцы и покупатели являются обычными пользователями, может напоминать площадку StockX, Poizon или подобные ей онлайн-площадки. Пользователи могут создать учетную запись и начать продавать кроссовки, которые они больше не используют или которые они купили, но никогда не носили. Они могут добавлять фотографии товара, описывать его состояние и указывать цену. Покупатели могут просматривать объявления и связываться с продавцами, чтобы задавать вопросы или уточнять информацию о товаре. Если они решат купить кроссовки, они могут оплатить их через онлайн-систему платежей на платформе или встретиться с продавцом лично для проведения сделки. Пользователи также могут оставлять отзывы о продавцах и кроссовках, которые они приобрели, чтобы помочь другим пользователям принимать решение о покупке. 

Дизайн - https://www.figma.com/file/xnbCLuWAZPaOotKK6TxYdW/Ilymax?type=design&node-id=0%3A1&t=AuAlvYUMPKJIfjnb-1

## Навигация

В приложении будет отдельный модуль логина и 5 вкладок с основными возможностями: Главная страница, Корзина, Модуль добавление товара, Сообщения(с покупателями и продавцами) и Профиль.

## Главная страница

Compositional layout с несколькими секциями - это эффективный способ организации контента в приложении, который позволяет пользователю быстро и удобно находить нужную информацию.

Первая секция на странице магазина кроссовок будет содержать различные подборки товаров, такие как "Лучшие новинки", "Самые продаваемые", "Лучшие скидки" и т.д. Эти подборки будут упорядочены по дате добавления или по популярности.

Следующая секция на странице будет посвящена популярным кроссовкам, которые чаще всего покупают. Здесь будут представлены самые популярные модели различных брендов, которые пользователи ищут на сайте.
Третья секция будет содержать различные категории обуви, которые предлагает магазин. Например, это может быть раздел "Беговые кроссовки", "Тренировочная обувь", “Тяги бархатные”,  "Повседневная обувь" и т.д. При нажатии на одну из категорий, пользователь будет перенаправлен на страницу, содержащую товары из этой категории.

## Экран поиска

Search-bar на сайте позволяет пользователям искать нужный товар по названию. При вводе слова в строку поиска, магазин показывает соответствующие товары в результатах поиска, что упрощает и ускоряет поиск нужной обуви.

Каждая секция может содержать большое количество товаров, которые можно просмотреть, используя функцию бесконечной прокрутки или пагинацию. Также, на каждой странице может быть представлено несколько вариантов сортировки товаров, например, по цене, бренду или рейтингу.

## Экран товара

Mожно посмотреть фото, название и описание. Можно выбрать размер кроссовок и добавить в корзину. Также можно перейти на страницу с отзывами или на страницу продавца и посмотреть другие товары от этого продавца.


## Экран отзывов

Экран с отзывами от других покупателей, также есть возможность оставить отзыв самому.

## Экран корзины + оплата

После добавления товара в корзину, можно будет перейти и посмотреть все товары в ней, если что-то хотите убрать можно будет удалить кнопкой. Также кнопка оплаты, которая перекидывает в браузер для оплаты на сервис ЮКасса.

## Чат

Экран чата с продавцами и  покупателями. Если у пользователя есть непрочитанные сообщения, то иконка на тачбаре будет с красным кружком. 

## Логин

Вход. Нужно ввести имя, почту и пароль. Можно зарегистрироваться и войти.

## Добавление объявления

На первом экране требуется заполнить данные( название, описание, бренд, пол, цвет, категория, состояние), есть кнопка возврата и продолжения. На втором экране нужно добавить размеры и кол-во товара (добавление нового размера через нажатие на кнопку “+”),  есть кнопка возврата и продолжения. На третьем экране требуется загрузить изображение с камеры/галереи,  есть кнопка возврата и опубликовать.

## Профиль продавца

На профиль продавца мы можем попасть с экрана товара. На данном экране представлено: фото продавца, его имя и почта, а также список товаров, которые доступны у данного продавца.


## Профиль

На экране профиля  представлено: ваше имя и почта, изображение профиля. Есть 4 кнопки: “Мои заказы”, “Мои объявления”, “Адреса доставки”, “Настройки”.

## Мои заказы

На экране “Мои заказы”  представлен список всех заказов, их номер, дата, кол-во товаров в заказе, стоимость, статус и кнопка “Детали”. При нажатии на кнопку открывается экран с подробным описанием заказа.

## Мои объявления

На экране “Мои объявления” представлен список ваших объявлений. При нажатии на объявление его можно удалить или отредактировать(планируется переиспользовать экраны добавления объявления).


## Адреса доставки

На экране адресов представлен ваш список добавленных ранее адресов. Любой адрес можно назначить “главным”(именно на него отправится ваш заказ), а также нажав на “+” можно добавить новый. На экране добавления мы спросим: ваше ФИО, страну, индекс, город, улицу, дом и квартиру.

## Настройки

В настройках можно : изменить имя, почту, пароль, включить/выключить уведомления о скидках/сообщениях/изменениях статусов доставки, просмотреть FAQ, связаться с нами, а также прочитать про наши правила.
