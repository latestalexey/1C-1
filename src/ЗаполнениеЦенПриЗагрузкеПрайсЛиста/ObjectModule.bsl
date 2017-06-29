﻿
Функция СведенияОВнешнейОбработке() Экспорт
	Назначение = Новый Массив;
	Назначение.Добавить("Документ.УстановкаЦенНоменклатуры");
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ЗаполнениеОбъекта");
	ПараметрыРегистрации.Вставить("Назначение", Назначение);
	ПараметрыРегистрации.Вставить("Наименование", "Заполнить цены при загрузке прайс-листа");
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("Информация", "Дополнительная обработка табличной части установки цен");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
	
	Команды = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(Команды, "Заполнить цены при загрузке прайс-листа...", "ЗаполнитьЦены", "ВызовКлиентскогоМетода", Ложь);
	
	ПараметрыРегистрации.Вставить("Команды", Команды);
	
	Возврат ПараметрыРегистрации;
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции	

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры	