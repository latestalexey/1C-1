﻿
&НаКлиенте
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначенияМассив) Экспорт
	// Выбираем вид цены
	ФормаВыбора = ПолучитьФорму("Справочник.ВидыЦен.ФормаВыбора");
	ВидЦены = ФормаВыбора.ОткрытьМодально();
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат;
	КонецЕсли;
	
	// Заполняем таблицу цены выбранного вида
	Для Каждого ТекущаяСтрока из ВладелецФормы.Объект.Товары Цикл
		Если ТекущаяСтрока.ВидЦены = ВидЦены Тогда
			ТекущаяСтрока.Цена = НайтиЦену(ВладелецФормы.Объект.ДокументОснование, ТекущаяСтрока.Номенклатура);
		КонецЕсли;
	КонецЦикла;
	
	// Записываем документ и обновляем форму
	ВладелецФормы.Записать();
	ВладелецФормы.Прочитать();
КонецПроцедуры

&НаСервере
Функция НайтиЦену(Док, Номенклатура)
	Для Каждого Товар Из Док.Товары Цикл
		Если Товар.Номенклатура = Номенклатура Тогда
			Возврат Товар.Цена;
		КонецЕсли;
	КонецЦикла;
	// если ничего не нашли
	Возврат 0;
КонецФункции
