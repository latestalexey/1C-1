﻿Перем ПустойДокумент;
Перем ПутьККартинкам;

Функция КопироватьИзображениеВКаталогИзображений(ПолноеИмяФайла)
	
	Если НРег(Лев(ПолноеИмяФайла, 4)) = "http" Тогда
		Возврат ПолноеИмяФайла;
	КонецЕсли;
	
	ПолноеИмяФайла = Каталог + ПолноеИмяФайла;
	// определяем расширение и имя файла
	пТочка = Неопределено;
	пПалка = Неопределено;
	Расширение = Неопределено;
	Заголовок = Неопределено;
	Длина = СтрДлина(ПолноеИмяФайла);
	Для Сим = 1 По Длина Цикл
		
		Если Сред(ПолноеИмяФайла, Длина - Сим + 1, 1) = "."
			И пТочка = Неопределено Тогда
			пТочка = Длина - Сим + 1;
		КонецЕсли;
		
		Если Сред(ПолноеИмяФайла, Длина - Сим + 1, 1) = "\"
			И пПалка = Неопределено Тогда
			пПалка = Длина - Сим + 1;
		КонецЕсли;
		
		Если пТочка <> Неопределено
			И пПалка <> Неопределено Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если (пТочка = Неопределено
		ИЛИ пПалка = Неопределено)
		И (Не ЗначениеЗаполнено(Заголовок)
		ИЛИ Не ЗначениеЗаполнено(Расширение)) Тогда
		Сообщить("Не корректный путь к файлу");
	КонецЕсли;
	
	Если пТочка > пПалка Тогда
		Если пТочка <> Длина Тогда
			Расширение = Сред(ПолноеИмяФайла, пТочка + 1, Длина - пТочка);
		КонецЕсли;
		Заголовок = Сред(ПолноеИмяФайла, пПалка + 1, Длина - пПалка - (Длина - пТочка + 1));
	Иначе
		Сообщить("Файл не имеет расширения");
		Возврат Неопределено;
	КонецЕсли;
	
	// получаем новое имя для картинки
	НовоеИмя = СтрЗаменить(Строка(ТекущаяДата()), ":", ".") + "_" + Заголовок + "." + Расширение;
	
	// копируем картинку с новым именем
	Попытка
		КопироватьФайл(ПолноеИмяФайла, ПутьККартинкам + "\" + НовоеИмя);
	Исключение
		Сообщить("Не удаётся скопировать изображение в каталог изображений: " + ПутьККартинкам + "\images.");
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ПутьККартинкам + "\" + НовоеИмя;
	
КонецФункции // КопироватьИзображениеВКаталогИзображений

Процедура ВставитьВХТМЛ(ПолноеИмяФайла)
	
	// вставляем в HTML в самый конец шаблона
	НовыйЭлемент = ЭлементыФормы.ХТМЛ.Документ.createElement("<img src='" + "file:///" + СтрЗаменить(СтрЗаменить(ПолноеИмяФайла + "' />", " ", "%20"), "\", "/"));
	ЭлементыФормы.ХТМЛ.Документ.body.appendChild(НовыйЭлемент);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВставитьКартинку(Кнопка)
	
	// открываем картинку
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "Картинки (JPG, PNG)|*.jpg;*.png";
	Если Не Диалог.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	НовоеИмя = КопироватьИзображениеВКаталогИзображений(Диалог.Каталог, Прав(Диалог.ПолноеИмяФайла, СтрДлина(Диалог.ПолноеИмяФайла) - СтрДлина(Диалог.Каталог)));
	Если НовоеИмя = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВставитьВХТМЛ(НовоеИмя);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВставитьВнешнийШаблон(Кнопка)
	
	ОтветНаВопрос = Вопрос(НСтр("ru = 'Текущее содержимое шаблона будет очищено. Продолжить?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	// открываем картинку
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "HTML страницы (HTML, HTM)|*.html;*.htm";
	Если Не Диалог.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	хФайл = Новый ЧтениеТекста(Диалог.ПолноеИмяФайла, КодировкаТекста.UTF8);
	хтмлФайл = хФайл.Прочитать();
	хтмл = "";
	Ин = Найти(хтмлФайл, "src=");
	Пока Ин > 0 Цикл
		хтмл = хтмл + Лев(хтмлФайл, Ин + 4);
		Кавычка = Сред(хтмлФайл, Ин + 4, 1);
		хтмлФайл = Прав(хтмлФайл, СтрДлина(хтмлФайл) - Ин - 4);
		Ин2 = Найти(хтмлФайл, Кавычка);
		Если Ин2 = 0 Тогда
			Сообщить("Непарные кавычки в src");
			Прервать;
		КонецЕсли;
		Путь = СтрЗаменить(Лев(хтмлФайл, Ин2 - 1), "/", "\");
		
		НовыйПуть = КопироватьИзображениеВКаталогИзображений(Диалог.Каталог, Путь);
		Если НовыйПуть = Неопределено Тогда
			Сообщить("Не удалось скопировать изображение в каталог изображений");
			Прервать;
		КонецЕсли;
		хтмл = хтмл + ?(НРег(Лев(НовыйПуть, 4)) = "http", "", "file:///") + СтрЗаменить(СтрЗаменить(НовыйПуть, " ", "%20"), "\", "/") + Кавычка;
		
		хтмлФайл = Прав(хтмлФайл, СтрДлина(хтмлФайл) - Ин2);
		Ин = Найти(хтмлФайл, "src=");
	КонецЦикла;
	хтмл = хтмл + хтмлФайл;
	
	ЭлементыФормы.СодержаниеHTML.УстановитьТекст(хтмл);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ХТМЛ.УстановитьТекст(ПустойДокумент);
	//Сообщить(ПутьККартинкам);
	КаталогНаДиске = Новый Файл(ПутьККартинкам);
    Если Не КаталогНаДиске.Существует() Тогда
        СоздатьКаталог(ПутьККартинкам);
    КонецЕсли;
	
КонецПроцедуры

Функция КаталогИБ()
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	// в зависимости от того файловый это вариант БД или нет,  по-разному отображается путь в БД 
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");
	Если ПозицияПоиска = 1 тогда
		// Файловая	
		Возврат Сред(СтрокаСоединенияСБД,7,СтрДлина(СтрокаСоединенияСБД)-8)+"\";
	Иначе 
		// Серверная - Используем КаталогВременныхФайлов() 
		Возврат КаталогВременныхФайлов();
	КонецЕсли;
КонецФункции



ПустойДокумент = "<HTML><HEAD><META content='text/html; charset=utf-8' http-equiv=Content-Type><META name=GENERATOR content='MSHTML 11.00.9600.18666'></HEAD><BODY></BODY></HTML>";
ПутьККартинкам = КаталогИБ() + "images";