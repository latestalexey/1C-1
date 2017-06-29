﻿Процедура СделатьЗаписьВРегистрМашинаЗаказа(ЗаказПокупателя, Машина) Экспорт
	НаборЗаписей = РегистрыСведений.ИТС_МашинаЗаказа.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.ЗаказПокупателя.Установить(ЗаказПокупателя);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Запись = НаборЗаписей.Добавить();
		Запись.ЗаказПокупателя = ЗаказПокупателя;
	Иначе
		Запись = НаборЗаписей[0];
	КонецЕсли;
	
	Запись.Машина = Машина;
	НаборЗаписей.Записать();
	
КонецПроцедуры	

Процедура СделатьЗаписьВРегистрРейсЗаказа(ЗаказПокупателя, Рейс) Экспорт
	НаборЗаписей = РегистрыСведений.ИТС_МашинаЗаказа.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Регистратор.Установить(Рейс);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Запись = НаборЗаписей.Добавить();
		Запись.ЗаказПокупателя = ЗаказПокупателя;
	Иначе
		Запись = НаборЗаписей[0];
	КонецЕсли;
	
	Запись.Рейс = Рейс;
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьПредставлениеРейса(Рейс) Экспорт
	
	Результат = ?(ЗначениеЗаполнено(Рейс), "Рейс №" + Рейс.Номер, "");
	
	Возврат Результат;

КонецФункции	

Функция СделатьЗаписьЗаказаВРейс(ЗаказПокупателя, Рейс) Экспорт
	
	Об = Рейс.ПолучитьОбъект();
	НайдСтр = Об.ДокументыРейса.Найти(ЗаказПокупателя,"Документ");
	
	Если НайдСтр = Неопределено Тогда
		НовСтр = Об.ДокументыРейса.Добавить();
		НовСтр.Документ = ЗаказПокупателя;
		Об.Утвержден = Ложь;
		Об.РаспределенаСуммаПоВсемЗаказам = Ложь;
		Об.ВыпущеныВсеРеализации = Ложь;
		Попытка
			Об.Записать(РежимЗаписиДокумента.Проведение);
			Записано = Истина;
		Исключение;
			Записано = Ложь;
		КонецПопытки;
	КонецЕсли;	
	
	Возврат Записано;
	
КонецФункции

//Процедура СделатьЗаписьЗаказаВРейс(ЗаказПокупателя, Рейс) Экспорт
//	Об = Рейс.ПолучитьОбъект();
//	НайдСтр = Об.ДокументыРейса.Найти(ЗаказПокупателя,"Документ");
//	
//	Если НайдСтр = Неопределено Тогда
//		НовСтр = Об.ДокументыРейса.Добавить();
//		НовСтр.Документ = ЗаказПокупателя;
//		Об.Утвержден = Ложь;
//		Об.РаспределенаСуммаПоВсемЗаказам = Ложь;
//		Об.ВыпущеныВсеРеализации = Ложь;
//		Об.Записать(РежимЗаписиДокумента.Проведение);
//	КонецЕсли;	
//	
//КонецПроцедуры 
	