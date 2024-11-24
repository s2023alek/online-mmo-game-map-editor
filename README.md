
разрешение на публикацию данного кода было получено либо код не находился под NDA либо уже более не находится под NDA тоесть я могу его показать не нарушая соглашений о коммерческой тайне.

# редактор карт для онлайн ММО с диметрическим(изочетрическим) движком "BGTileMerger"

![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/e87be97051c87f573f5338f7eb9b3b0d438ece47/README/t.JPG)

# Содержание:
1. обзор проекта
2. описание кода/архитектуры, навигация по коду


## 1 обзор проекта

Назначение:  
- Облегчает работу дизайнерам уровней, позволяя без графического редактора рисовать декоративные фоны для виртуальных миров
- Изображение строится из тайлов. Каждый тайл состоит из произвольного числа слоев. Каждый слой состоит из изображения и маски прозрачности.

Возможности:  
- Поддержка произвольного размера карты и тайла
- Произвольные горячие клавиши для образцов тайлов
- Поддержка произвольного количества образцов тайлов и наборов изображений и масок для каждого образца
- Сохранение конфигурации и данных карты в файл
- Сохранение итогового изображения фона карты в формате png

## Видеообзор проекта

видеоинструкция по использованию редактора 
https://rutube.ru/video/de0451ffc04a63d0866f2f3fe53159e6/



## 2 описание кода/архитектуры, навигация по коду

проверенная временем архитектура, такаяже как и в проекте "Tutorion"


### инструкция в скриншотах:

### ранняя версия интерфейса редактора, с описанием элементов интерфейса:  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/e87be97051c87f573f5338f7eb9b3b0d438ece47/README/appdesc.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/e87be97051c87f573f5338f7eb9b3b0d438ece47/README/uidesc.PNG)


### последняя версия интерфейса редактора:  


ждать завершения загрузки редактора карт  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/0.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/1.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/2.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/3.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/4.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/5.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/6.PNG)

ждать завершения загрузки редактора фона карты  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/7.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/8.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/9.PNG)

![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/10.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/11.PNG)

нажать на кнопку чтобы назначить горячую клавишу для образца  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/12.PNG)

нажать клавишу R  на клавиатуре  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/13.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/14.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/15.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/16.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/17.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/18.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/19.PNG)

нажать по фону карты (зеленая трава) затем удерживая клавишу R поводить курсором по клеткам.
Фон карты можно перетащить курсором чтобы редактировать клетки находящиеся вне области просмотра.  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/20.PNG)

по желанию добавить еще один образец с произвольным количеством слоев состоящих из маски и картинки.  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/21.PNG)

по желанию аналогично назначить клавишу (другую) и также поводить курсором(перед этим нажав на фон карты чтобы она получила фокус)
Затем последовательно сохранить на сервер изображение карты, данные( нужны чтобы заново не набирать все образцы и саму карту), затем нажать на кнопку выход(3)  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/22.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/23.PNG)

перетащить зеленый ромб так чтобы он по клеткам вписывался в фон. Зеленый ромб – это область куда можно ставить здания и декорации. Состоит из таких же сегментов по размеру что и фон.  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/24.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/25.PNG)

установить координаты иконки для локации на карте мира (навести на желаемое место затем нажать левую кнопку мыши)
Сохранить карту.  
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/26.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/27.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/28.PNG)
![1](https://github.com/s2023alek/online-mmo-game-map-editor/blob/193b6671fdd3d35eea445b8965b2053f60985019/README/29.PNG)

