﻿Перем Макет;
Перем ВсегоПроизведено;
Перем ВсегоПроизведеноБрака;
Перем ВсегоЗатрат;
Перем ВсегоПродано;

Процедура КоманднаяПанель1Сформировать(Кнопка)
	
	Если Не ЗначениеЗаполнено(ДатаНач)
		И Не ЗначениеЗаполнено(ДатаКон)
		И Не ЗначениеЗаполнено(ГруппаБрака)
		И Не ЗначениеЗаполнено(Контрагент)
		И Не ЗначениеЗаполнено(Кредиторы)
		И Не ЗначениеЗаполнено(ТипЦен) Тогда
		Предупреждение("Заполните сначала начальные данные отчёта");
		Возврат;
	КонецЕсли;
	
	Макет = ПолучитьМакет("Сводный");
	
	ЭлементыФормы.Отчет.Очистить();
	
	СформироватьПроизводство();
	СформироватьЗатраты();
	СформироватьМенеджер();
	СформироватьПродано();
	СформироватьСправочно();
	
КонецПроцедуры

Процедура СформироватьПроизводство()
	
	ЭлементыФормы.Отчет.НачатьАвтогруппировкуСтрок();
	СформироватьШапкуОтчета("Производство");
	СформироватьШапкуТаблицы("Производство");
	
	//Запрос = Новый Запрос("ВЫБРАТЬ
	//                      |	ИТС_ПроизводствоОбороты.Номенклатура,
	//                      |	ИТС_ПроизводствоОбороты.Номенклатура.Наименование КАК НоменклатураНаименование,
	//                      |	ВЫБОР
	//                      |		КОГДА ИТС_ПроизводствоОбороты.Номенклатура В ИЕРАРХИИ (&ГруппаБрака)
	//                      |			ТОГДА ИТС_ПроизводствоОбороты.КоличествоОборот
	//                      |		ИНАЧЕ 0
	//                      |	КОНЕЦ КАК Брак,
	//                      |	ИТС_ПроизводствоОбороты.КоличествоОборот КАК Количество,
	//                      |	ИТС_ПроизводствоОбороты.СтоимостьОборот КАК Себестоимость,
	//                      |	ЦеныНоменклатурыСрезПоследних.Цена
	//                      |ИЗ
	//                      |	РегистрНакопления.ИТС_Производство.Обороты(&ДатаНач, &ДатаКон, , ) КАК ИТС_ПроизводствоОбороты
	//                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаКон, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	//                      |		ПО ИТС_ПроизводствоОбороты.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	//                      |			И ИТС_ПроизводствоОбороты.ХарактеристикаНоменклатуры = ЦеныНоменклатурыСрезПоследних.ХарактеристикаНоменклатуры
	//                      |
	//                      |УПОРЯДОЧИТЬ ПО
	//                      |	НоменклатураНаименование");
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИТС_ПроизводствоОбороты.Номенклатура,
	                      |	ИТС_ПроизводствоОбороты.Номенклатура.Наименование КАК НоменклатураНаименование,
	                      |	ВЫБОР
	                      |		КОГДА ИТС_ПроизводствоОбороты.Номенклатура В ИЕРАРХИИ (&ГруппаБрака)
	                      |			ТОГДА ИТС_ПроизводствоОбороты.КоличествоОборот
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК Брак,
	                      |	ИТС_ПроизводствоОбороты.КоличествоОборот КАК Количество,
	                      |	ЦеныНоменклатурыСрезПоследних.Цена,
	                      |	СУММА(ИТС_ПолнаяСебестоимостьОбороты.СтоимостьПриход) КАК Себестоимость
	                      |ИЗ
	                      |	РегистрНакопления.ИТС_Производство.Обороты(&ДатаНач, &ДатаКон, , ) КАК ИТС_ПроизводствоОбороты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ИТС_ПолнаяСебестоимость.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ИТС_ПолнаяСебестоимостьОбороты
	                      |		ПО ИТС_ПроизводствоОбороты.Номенклатура = ИТС_ПолнаяСебестоимостьОбороты.Номенклатура
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаКон, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	                      |		ПО ИТС_ПроизводствоОбороты.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	                      |			И ИТС_ПроизводствоОбороты.ХарактеристикаНоменклатуры = ЦеныНоменклатурыСрезПоследних.ХарактеристикаНоменклатуры
	                      |ГДЕ
	                      |	(ИТС_ПолнаяСебестоимостьОбороты.Регистратор ССЫЛКА Документ.ИТС_ОтчетПроизводстваЗаСмену
	                      |			ИЛИ ИТС_ПолнаяСебестоимостьОбороты.Регистратор ССЫЛКА Документ.ИТС_ПостоянныеЗатраты)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ИТС_ПроизводствоОбороты.Номенклатура,
	                      |	ИТС_ПроизводствоОбороты.Номенклатура.Наименование,
	                      |	ИТС_ПроизводствоОбороты.КоличествоОборот,
	                      |	ЦеныНоменклатурыСрезПоследних.Цена
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НоменклатураНаименование");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	Запрос.УстановитьПараметр("ГруппаБрака", ГруппаБрака);
	
	Область = Макет.ПолучитьОбласть("ПроизводствоСтрока");
		
	ВсегоПроизведено = 0;
	ВсегоПроизведеноБрака = 0;
	НПП = 1;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Область.Параметры.НПП = НПП;
		Область.Параметры.Номенклатура = Строка(Выборка.Номенклатура.Наименование);
		Область.Параметры.Количество = Выборка.Количество;
		Себестоимость = ?(Выборка.Количество = 0, Неопределено, Формат(Выборка.Себестоимость / Выборка.Количество, "ЧЦ=15; ЧДЦ=2"));
		Область.Параметры.Себестоимость = ?(Себестоимость = Неопределено, 0, Себестоимость);
		Область.Параметры.Цена = Выборка.Цена;
		Область.Параметры.Прибыль = ?(ЗначениеЗаполнено(Выборка.Цена), Формат(Выборка.Цена - ?(ЗначениеЗаполнено(Себестоимость), Себестоимость, Выборка.Цена), "ЧЦ=15; ЧДЦ=2"), 0);
		ЭлементыФормы.Отчет.Вывести(Область, 2);
		
		ВсегоПроизведено = ВсегоПроизведено + Выборка.Количество;
		ВсегоПроизведеноБрака = ВсегоПроизведеноБрака + Выборка.Брак;
		НПП = НПП + 1;
	КонецЦикла;
	
	Данные = Новый Массив();
	Данные.Добавить(ВсегоПроизведено);
	СформироватьИтоговуюСтрокуОтчета("Производство", Данные);
	ЭлементыФормы.Отчет.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

Процедура СформироватьЗатраты()
	
	ЭлементыФормы.Отчет.НачатьАвтогруппировкуСтрок();
	СформироватьШапкуОтчета("Затраты");
	СформироватьШапкуТаблицы("Затраты");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИТС_ПолнаяСебестоимостьОбороты.СтатьяЗатрат КАК Затраты,
	                      |	ИТС_ПолнаяСебестоимостьОбороты.СтатьяЗатрат.Наименование КАК СтатьяЗатратНаименование,
	                      |	СУММА(ИТС_ПолнаяСебестоимостьОбороты.СтоимостьПриход) КАК Сумма
	                      |ИЗ
	                      |	РегистрНакопления.ИТС_ПолнаяСебестоимость.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ИТС_ПолнаяСебестоимостьОбороты
	                      |ГДЕ
	                      |	(ИТС_ПолнаяСебестоимостьОбороты.Регистратор ССЫЛКА Документ.ИТС_ОтчетПроизводстваЗаСмену
	                      |			ИЛИ ИТС_ПолнаяСебестоимостьОбороты.Регистратор ССЫЛКА Документ.ИТС_ПостоянныеЗатраты)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ИТС_ПолнаяСебестоимостьОбороты.СтатьяЗатрат,
	                      |	ИТС_ПолнаяСебестоимостьОбороты.СтатьяЗатрат.Наименование
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СтатьяЗатратНаименование");
	
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	
	Область = Макет.ПолучитьОбласть("ЗатратыСтрока");
		
	НПП = 1;
	Данные = Новый Массив();
	Данные.Добавить(0);
	Данные.Добавить(0);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Область.Параметры.НПП = НПП;
		Область.Параметры.Затраты = Выборка.Затраты;
		Область.Параметры.Сумма = Выборка.Сумма;
		Область.Параметры.НаЕд = ?(ВсегоПроизведено = 0, Выборка.Сумма, Формат(Выборка.Сумма / ВсегоПроизведено, "ЧЦ=15; ЧДЦ=2"));
		ЭлементыФормы.Отчет.Вывести(Область, 2);
		
		Данные[0] = Данные[0] + Выборка.Сумма;
		Данные[1] = Данные[1] + ?(ВсегоПроизведено = 0, Выборка.Сумма, Формат(Выборка.Сумма / ВсегоПроизведено, "ЧЦ=15; ЧДЦ=2"));
		
		НПП = НПП + 1;
	КонецЦикла;
	
	ВсегоЗатрат = Данные[0];
	
	СформироватьИтоговуюСтрокуОтчета("Затраты", Данные);
	ЭлементыФормы.Отчет.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

Функция ПолучитьВыручкуПоМенеджерам()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СУММА(ПродажиОбороты.СтоимостьОборот) КАК Стоимость,
	                      |	ПродажиОбороты.ДоговорКонтрагента.ВидВзаиморасчетов КАК ВидРасчетов,
	                      |	ПродажиОбороты.Контрагент.ОсновнойМенеджерПокупателя КАК Менеджер,
	                      |	ПродажиОбороты.Контрагент.ОсновнойМенеджерПокупателя.Наименование КАК КонтрагентОсновнойМенеджерПокупателяНаименование
	                      |ИЗ
	                      |	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, , ) КАК ПродажиОбороты
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ПродажиОбороты.ДоговорКонтрагента.ВидВзаиморасчетов,
	                      |	ПродажиОбороты.СтоимостьОборот,
	                      |	ПродажиОбороты.Контрагент.ОсновнойМенеджерПокупателя
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	КонтрагентОсновнойМенеджерПокупателяНаименование
	                      |ИТОГИ
	                      |	СУММА(Стоимость)
	                      |ПО
	                      |	Менеджер,
	                      |	ВидРасчетов");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Менеджер");
	ТЗ.Колонки.Добавить("ВыручкаНЛ");
	ТЗ.Колонки.Добавить("ВыручкаБН");
	
	Для Каждого Менеджер Из Дерево.Строки Цикл
		Строка = ТЗ.Добавить();
		Строка.Менеджер = Менеджер.Менеджер;
		Строка.ВыручкаНЛ = 0;
		Строка.ВыручкаБН = 0;
		Для Каждого ВидВзаиморасчетов Из Менеджер.Строки Цикл
			Если Не ЗначениеЗаполнено(ВидВзаиморасчетов.ВидРасчетов) Тогда
				Строка.ВыручкаБН = Строка.ВыручкаБН + ВидВзаиморасчетов.Стоимость;
			ИначеЕсли Найти(ВидВзаиморасчетов.ВидРасчетов, "Наличный") = 1 Тогда
				Строка.ВыручкаНЛ = Строка.ВыручкаБН + ВидВзаиморасчетов.Стоимость;
			Иначе
				Строка.ВыручкаБН = Строка.ВыручкаБН + ВидВзаиморасчетов.Стоимость;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТЗ;
	
КонецФункции

Функция ПолучитьДолгиПоМенеджерам()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Контрагент.ОсновнойМенеджерПокупателя КАК Менеджер,
	                      |	СУММА(ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовКонечныйОстаток) КАК Долг,
	                      |	СУММА(ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовРасход) КАК Оплачено
	                      |ИЗ
	                      |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ВзаиморасчетыСКонтрагентамиОстаткиИОбороты
	                      |ГДЕ
	                      |	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента.ВидДоговора = &ВидДоговора
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Контрагент.ОсновнойМенеджерПокупателя");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Возврат ТЗ;
	
КонецФункции

Процедура СформироватьМенеджер()
	
	ЭлементыФормы.Отчет.НачатьАвтогруппировкуСтрок();
	СформироватьШапкуОтчета("Менеджер");
	СформироватьШапкуТаблицы("Менеджер");
		
	НПП = 1;
	Данные = Новый Массив();
	Данные.Добавить(0);
	Данные.Добавить(0);
	Данные.Добавить(0);
	Данные.Добавить(0);
	
	Менеджеры = ПолучитьВыручкуПоМенеджерам();
	Долги = ПолучитьДолгиПоМенеджерам();
	
	Область = Макет.ПолучитьОбласть("МенеджерСтрока");
	
	Для Каждого Менеджер Из Менеджеры Цикл
		
		Область.Параметры.НПП = НПП;
		Область.Параметры.Менеджер = Менеджер.Менеджер;
		Область.Параметры.ВыручкаНЛ = Менеджер.ВыручкаНЛ;
		Область.Параметры.ВыручкаБН = Менеджер.ВыручкаБН;
		Долг = Долги.Найти(Менеджер.Менеджер, "Менеджер");
		Область.Параметры.Долг = ?(Долг = Неопределено, 0, Долг.Долг);
		Область.Параметры.Оплачено = ?(Долг = Неопределено, 0, Долг.Оплачено);
		ЭлементыФормы.Отчет.Вывести(Область, 2);
		
		Данные[0] = Данные[0] + Менеджер.ВыручкаНЛ;
		Данные[1] = Данные[1] + Менеджер.ВыручкаБН;
		Данные[2] = Данные[2] + ?(Долг = Неопределено, 0, Долг.Оплачено);
		Данные[3] = Данные[3] + ?(Долг = Неопределено, 0, Долг.Долг);
		
		НПП = НПП + 1;
	КонецЦикла;
	
	СформироватьИтоговуюСтрокуОтчета("Менеджер", Данные);
	ЭлементыФормы.Отчет.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

Процедура СформироватьПродано()
	
	ЭлементыФормы.Отчет.НачатьАвтогруппировкуСтрок();
	СформироватьШапкуОтчета("Продано");
	СформироватьШапкуТаблицы("Продано");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПродажиОбороты.Номенклатура,
	                      |	ПродажиОбороты.КоличествоОборот КАК Количество,
	                      |	ПродажиОбороты.СтоимостьОборот КАК Сумма,
	                      |	ПродажиОбороты.Номенклатура.Наименование КАК НоменклатураНаименование
	                      |ИЗ
	                      |	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, , ) КАК ПродажиОбороты");
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Запрос.Текст = Запрос.Текст + "
						  |ГДЕ
						  | ПродажиОбороты.Номенклатура В ИЕРАРХИИ(&Номенклатура)";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + "
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НоменклатураНаименование";
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Область = Макет.ПолучитьОбласть("ПроданоСтрока");
		
	Данные = Новый Массив();
	Данные.Добавить(0);
	Данные.Добавить(0);
	НПП = 1;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Область.Параметры.НПП = НПП;
		Область.Параметры.Номенклатура = Выборка.Номенклатура;
		Область.Параметры.Количество = Выборка.Количество;
		Область.Параметры.Сумма = Выборка.Сумма;
		ЭлементыФормы.Отчет.Вывести(Область, 2);
		
		Данные[0] = Данные[0] + Выборка.Количество;
		Данные[1] = Данные[1] + Выборка.Сумма;
		
		НПП = НПП + 1;
	КонецЦикла;
	
	СформироватьИтоговуюСтрокуОтчета("Продано", Данные);
	ЭлементыФормы.Отчет.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

Процедура СформироватьСправочно()
	
	Область = Макет.ПолучитьОбласть("Справочно");
	Область.Параметры.Брак = ?(ВсегоПроизведено = 0, 0, Формат(ВсегоПроизведеноБрака * 100 / ВсегоПроизведено, "ЧЦ=15; ЧДЦ=2"));
	
	// получено от "Мир"
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СУММА(ВзаиморасчетыСКонтрагентамиОбороты.СуммаВзаиморасчетовРасход) КАК Сумма
	                      |ИЗ
	                      |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(&ДатаНач, &ДатаКон, , ) КАК ВзаиморасчетыСКонтрагентамиОбороты
	                      |ГДЕ
	                      |	ВзаиморасчетыСКонтрагентамиОбороты.Контрагент = &Контрагент");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Область.Параметры.Мир = Выборка.Сумма;
	КонецЕсли;
	
	// заёмные средства
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СУММА(ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток) КАК Сумма
	                      |ИЗ
	                      |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&ДатаКон, ) КАК ВзаиморасчетыСКонтрагентамиОстатки
	                      |ГДЕ
	                      |	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент В ИЕРАРХИИ(&Кредиторы)");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Кредиторы", Кредиторы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Область.Параметры.Кредиторы = Выборка.Сумма;
	КонецЕсли;
	
	// общая прибыль
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПродажиОбороты.СтоимостьОборот КАК Сумма
	                      |ИЗ
	                      |	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, , ) КАК ПродажиОбороты");
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВсегоПродано = Выборка.Сумма;
	КонецЕсли;
	Область.Параметры.ОбщаяПрибыль = Формат(ВсегоПродано - ВсегоЗатрат, "ЧЦ=15; ЧДЦ=2");
	
	ЭлементыФормы.Отчет.Вывести(Область);
	
КонецПроцедуры

Процедура СформироватьШапкуОтчета(Отчет)
	
	Область = Макет.ПолучитьОбласть(Отчет + "Шапка");
	ЭлементыФормы.Отчет.Вывести(Область);
	
КонецПроцедуры

Процедура СформироватьШапкуТаблицы(Отчет)
	
	Область = Макет.ПолучитьОбласть(Отчет + "ШапкаТаблицы");
	ЭлементыФормы.Отчет.Вывести(Область, 1);
	
КонецПроцедуры

Процедура СформироватьИтоговуюСтрокуОтчета(Отчет, Данные)
	
	Область = Макет.ПолучитьОбласть(Отчет + "Итог");
	Если Отчет = "Производство" Тогда
		Область.Параметры.Количество = Данные[0];
	ИначеЕсли Отчет = "Затраты" Тогда
		Область.Параметры.Сумма = Данные[0];
		Область.Параметры.НаЕд = Данные[1];
	ИначеЕсли Отчет = "Менеджер" Тогда
		Область.Параметры.ВыручкаНЛ = Данные[0];
		Область.Параметры.ВыручкаБН = Данные[1];
		Область.Параметры.Оплачено = Данные[2];
		Область.Параметры.Долг = Данные[3];
	ИначеЕсли Отчет = "Продано" Тогда
		Область.Параметры.Количество = Данные[0];
		Область.Параметры.Сумма = Данные[1];
	КонецЕсли;
	ЭлементыФормы.Отчет.Вывести(Область, 1);
	
КонецПроцедуры

Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	НП = Новый НастройкаПериода;
	НП.УстановитьПериод(ДатаНач, ДатаКон);

	Если НП.Редактировать() Тогда
		ДатаНач = НП.ПолучитьДатуНачала();
		ДатаКон  = НП.ПолучитьДатуОкончания();
	КонецЕсли;
	
КонецПроцедуры
