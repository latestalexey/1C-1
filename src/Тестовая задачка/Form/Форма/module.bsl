﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ОбщееВремя = Исполнители.Итог("Часы");
	Для Каждого Строка Из Исполнители Цикл
		Строка.Сумма = ?(ОбщееВремя = 0, 0, ОбщаяСумма * Строка.Часы / ОбщееВремя);
	КонецЦикла;
	Строка.Сумма = 0;
	Строка.Сумма = ОбщаяСумма - Исполнители.Итог("Сумма");
КонецПроцедуры
