﻿
#Область СлужебнаяВнешниеФайлы

Функция СведенияОВнешнейОбработке() Экспорт

  ПараметрыРегистрации = Новый Структура;
  ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
  ПараметрыРегистрации.Вставить("Наименование","ЗаполнитьИзExcel");
  ПараметрыРегистрации.Вставить("Версия","1.0");
  ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
  ПараметрыРегистрации.Вставить("Информация", "");
  ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
  ТаблицаКоманд = ПолучитьТаблицуКоманд();
  ДобавитьКоманду(ТаблицаКоманд,
  		"Заполнить из Excel",
  		"1",
  		"ОткрытиеФормы",
  		Истина,
  		"");
  ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
  Возврат ПараметрыРегистрации;
  
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));//как будет выглядеть описание печ.формы для пользователя
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")); //имя макета печ.формы
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка")); //ВызовСерверногоМетода
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

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПолучитьДанныеExcel(ПорцияДанных, ТаблицаНомеровКолонок, ПараметрыПолученияДанных) Экспорт

	ПорцияДанныхОбработано   = Новый Массив;
	
	МаксНом = 0;
	Для Каждого ТекСтрока Из ТаблицаНомеровКолонок Цикл
		Если ТекСтрока.НомерКолонки > МаксНом Тогда
			МаксНом = ТекСтрока.НомерКолонки
		КонецЕсли;
	КонецЦикла;
	
	ЗначенияДанных = ПараметрыПолученияДанных.ЗначенияДанных;
	
	Для Каждого ДанныеСтрокиНач Из ПорцияДанных Цикл
		
		МассивЯчеек = Новый Массив;
		Для й = 1 По МаксНом Цикл
			МассивЯчеек.Добавить(ДанныеСтрокиНач["Колонка" + Формат(й, "ЧЦ=3; ЧВН=")]);
		КонецЦикла;
		
		Если ЭтоПустаяСтрока(МассивЯчеек) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Новый Структура;
		Для Каждого СтрКолонка Из ТаблицаНомеровКолонок Цикл
			ДанныеСтроки.Вставить(СтрКолонка.Имя);
		КонецЦикла;
		ДанныеСтроки.Вставить("__ИмяЛиста__", ДанныеСтрокиНач.__ИмяЛиста__);
		
		ТекОтказ = Ложь;
		
		// 1. считывание стандартнх колонок с "номером колонки excel" на форме
		Для Каждого СтрКолонка Из ТаблицаНомеровКолонок Цикл
			
			ТекРеквизит  = СтрКолонка.Имя;
			ТекЗаголовок = СтрКолонка.Представление;
			ТекТип       = СтрКолонка.ТипЗначения;
			
			Если ПустаяСтрока(ТекРеквизит) Тогда Продолжить; КонецЕсли;
			
			ТекНомерКолонки = СтрКолонка.НомерКолонки;
			
			ТекКолонкаЗначение = "";
			Если ТекНомерКолонки <> 0 Тогда
				ТекКолонкаЗначение = МассивЯчеек[ТекНомерКолонки - 1];
				ТекКолонкаЗначение = СокрЛП(ТекКолонкаЗначение);
			КонецЕсли;
			
			ТекКолонкаЗначениеЗапись = ПолучитьДанныеExcel_ЗначениеЯчейки(ТекКолонкаЗначение, ТекТип);
			
			Если Не ЗначениеЗаполнено(ТекКолонкаЗначениеЗапись) Тогда
				ТекКолонкаЗначениеЗапись = ТекКолонкаЗначение;
			КонецЕсли;
			
			//{{ ПРОЧИЕ ПРЕОБРАЗОВАНИЯ
			Попытка
				Выполнить(ПараметрыПолученияДанных.Алгоритм_ПоискДанныхСтроки);
			Исключение
				ВызватьИсключение "Ошибка алгоритма ""Поиск данных строки"": " + ОписаниеОшибки();
			КонецПопытки;
			//}}
			
			Если ТекКолонкаЗначениеЗапись <> Неопределено Тогда
				ДанныеСтроки[ТекРеквизит] = ТекКолонкаЗначениеЗапись;
			Иначе
				ДанныеСтроки[ТекРеквизит] = ТекКолонкаЗначение;
			КонецЕсли;
			
		КонецЦикла;
		// -----------------------------------------------------------------------------
		
		Если Не ТекОтказ Тогда
			ПорцияДанныхОбработано.Добавить(ДанныеСтроки)
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПорцияДанныхОбработано
	
КонецФункции

Функция ПослеЧтенияДанных(ТаблицаДанныхExcel, ТаблицаНомеровКолонок, ПараметрыЧтенияДанных) Экспорт

	ТаблицаВнешниеФайлы = ПолучитьИзВременногоХранилища(ПараметрыЧтенияДанных.ТаблицаВнешниеФайлы_Адрес);
	
	Попытка
		Выполнить(ПараметрыЧтенияДанных.Алгоритм_ПослеЧтенияДанных);
	Исключение
		ВызватьИсключение "Ошибка алгоритма ""После чтения данных"": " + ОписаниеОшибки();
	КонецПопытки;
	
	Возврат ТаблицаДанныхExcel
	
КонецФункции

Процедура ЗагрузитьДанныеExcel(ПараметрыЗагрузкиДанных) Экспорт
	
	ТаблицаДанныхExcel  = ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиДанных.ТаблицаДанныхExcel_Адрес);
	ТаблицаВнешниеФайлы = ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиДанных.ТаблицаВнешниеФайлы_Адрес);
	
	СтандартнаяОбработка = Истина;
	ОбъектОбработка = Неопределено;
	
	Если ПараметрыЗагрузкиДанных.ВТранзакции Тогда
		НачатьТранзакцию()
	КонецЕсли;
	
	Если ПараметрыЗагрузкиДанных.ЭтоНачальнаяИтерация Тогда
		Попытка
			Выполнить(ПараметрыЗагрузкиДанных.Алгоритм_ПередЗагрузкойДанных);
		Исключение
			ВызватьИсключение "Ошибка алгоритма ""Перед загрузкой данных"": " + ОписаниеОшибки();
		КонецПопытки;
		
	ИначеЕсли ПараметрыЗагрузкиДанных.Свойство("ОбъектОбработкаИмя") Тогда
		
		ОбъектОбработка = ВнешниеОбработки.Создать(ПараметрыЗагрузкиДанных.ОбъектОбработкаИмя);
		
	КонецЕсли;
	
	Если ОбъектОбработка <> Неопределено Тогда
		ПараметрыЗагрузкиДанных.Вставить("ОбъектОбработкаИмя", ОбъектОбработка.Метаданные().Имя)
	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		
		Если ПараметрыЗагрузкиДанных.ВТранзакции Тогда
			Если ПараметрыЗагрузкиДанных.ТестоваяЗагрузка Тогда
				ОтменитьТранзакцию();
			Иначе
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанных.СтандартнаяОбработка = Ложь;
		ПараметрыЗагрузкиДанных.НомерНачало  = ТаблицаДанныхExcel.Количество() + 1;
		ПараметрыЗагрузкиДанных.ЭтоНачальнаяИтерация  = Ложь;
		
		Возврат;
	КонецЕсли;
	
	НомПП = ?(  ПараметрыЗагрузкиДанных.ЭтоНачальнаяИтерация, 1, ПараметрыЗагрузкиДанных.НомерНачало);
	Если ПараметрыЗагрузкиДанных.Шаг = 0 Тогда
		НомППКонец = ТаблицаДанныхExcel.Количество()
	Иначе
		НомППКонец = Мин(НомПП + ПараметрыЗагрузкиДанных.Шаг - 1, ТаблицаДанныхExcel.Количество());
	КонецЕсли;
	
	Пока Истина Цикл
		
		Если НомПП > НомППКонец Тогда
			Прервать;
		КонецЕсли;
		
		ДанныеСтроки = ТаблицаДанныхExcel[НомПП - 1];
		
		Попытка
			Выполнить(ПараметрыЗагрузкиДанных.Алгоритм_ЗагрузкаДанныхСтроки);
		Исключение
			ВызватьИсключение "Ошибка алгоритма ""Загрузкой данных строки"": " + ОписаниеОшибки();
		КонецПопытки;
		
		Если ПараметрыЗагрузкиДанных.Отказ Тогда
			Прервать;
		КонецЕсли;;
		
		НомПП = НомПП + 1;
		
	КонецЦикла;
	
	Если ПараметрыЗагрузкиДанных.ВТранзакции Тогда
		Если ПараметрыЗагрузкиДанных.ТестоваяЗагрузка Тогда
			ОтменитьТранзакцию();
		Иначе
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗагрузкиДанных.НомерНачало  = НомППКонец + 1;
	ПараметрыЗагрузкиДанных.ЭтоНачальнаяИтерация  = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СериализоватьОбъект(Значение) Экспорт
	
    ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
    СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение);
    СтрокаXML = ЗаписьXML.Закрыть();
 	
	Возврат СтрокаXML
КонецФункции

Функция ДеСериализоватьОбъект(СтрокаXML) Экспорт
	
	//Создаем объект чтения из XML
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	//Читаем таблицу значений из XML    
	ОбъектТЗ = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
 	
	Возврат ОбъектТЗ
КонецФункции

Функция ОписаниеТиповПоПредставлению(ПредставлениеТипов) Экспорт
	
	МассивТипов = Новый Массив;
	
	СтрокаДлина    = 0;
	ЧислоТочность  = 0;
	ЧислоДлина     = 0;
	ДатаСоставДаты = ЧастиДаты.Дата;
	
	Для Каждого ТекТип Из СтрРазделить(ПредставлениеТипов, ";") Цикл
		
		ТекТипСтр = СокрЛП(ТекТип);
		
		Попытка
		
			Если СтрНачинаетсяС(ВРег(ТекТипСтр), "СТРОКА") Тогда
				
				МассивТипов.Добавить(Тип("Строка"));
				Если Найти(ТекТипСтр,"(") Тогда
					СтрокаДлина = ЧислоИзСтроки(Сред(ТекТипСтр,8,СтрДлина(ТекТипСтр)-8))
				КонецЕсли;
				
			ИначеЕсли СтрНачинаетсяС(ВРег(ТекТипСтр), "ЧИСЛО") Тогда
				
				МассивТипов.Добавить(Тип("Число"));
				ДлинаТочность = СтрЗаменить(Сред(ТекТипСтр,7,СтрДлина(ТекТипСтр)-7)," ","");
				Если Найти(ДлинаТочность, ",") = 0 Тогда
					ЧислоДлина = ЧислоИзСтроки(ДлинаТочность);
				Иначе
					Поз = Найти(ДлинаТочность, ",");
					ЧислоДлина 		= ЧислоИзСтроки(Лев(ДлинаТочность, Поз-1));
					ЧислоТочность 	= ЧислоИзСтроки(Сред(ДлинаТочность, Поз+1));
				КонецЕсли;
				
			ИначеЕсли СтрНачинаетсяС(ВРег(ТекТипСтр), "ДАТА") Тогда
				
				МассивТипов.Добавить(Тип("Дата"));
				ДатаСоставДатыСтр = ИмяПоПредставлению(Сред(ТекТипСтр,6,СтрДлина(ТекТипСтр)-6));
				Если Не ПустаяСтрока(ДатаСоставДатыСтр) Тогда
					ДатаСоставДаты = ЧастиДаты[ДатаСоставДатыСтр];
				КонецЕсли;
				
			Иначе
				МассивТипов.Добавить(Тип(ТекТипСтр));
				
			КонецЕсли;
			
		Исключение
		КонецПопытки;

	КонецЦикла;
	
	КС = Новый КвалификаторыСтроки(СтрокаДлина);
	КЧ = Новый КвалификаторыЧисла(ЧислоДлина, ЧислоТочность);
	КД = Новый КвалификаторыДаты(ДатаСоставДаты);
	
	Возврат Новый ОписаниеТипов(МассивТипов,,,КЧ,КС,КД)
	
КонецФункции

Функция ОписаниеТиповПредставление(ОписаниеТипов, ВыводитьКвалификаторы = Истина) Экспорт
	
	Результат = Новый СписокЗначений;
	
	СтрокаДлина    = ОписаниеТипов.КвалификаторыСтроки.Длина;
	ЧислоТочность  = ОписаниеТипов.КвалификаторыЧисла.РазрядностьДробнойЧасти;
	ЧислоДлина     = ОписаниеТипов.КвалификаторыЧисла.Разрядность;
	ДатаСоставДаты = СокрЛП(ОписаниеТипов.КвалификаторыДаты.ЧастиДаты);
	
	Для Каждого ТекТип Из ОписаниеТипов.Типы() Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТекТип);
		Если ОбъектМетаданных = Неопределено Тогда
			
			ТекТипСтр = СокрЛП(ТекТип);
			
			Если ВыводитьКвалификаторы Тогда
				Если ТекТипСтр = "Строка" Тогда
					ТекТипСтр = ТекТипСтр + ?(СтрокаДлина = 0,"(неогр)", "("+СтрокаДлина+")");
				ИначеЕсли ТекТипСтр = "Число" Тогда
					ТекТипСтр = ТекТипСтр + "("+ЧислоДлина+", "+ЧислоТочность+")";
				ИначеЕсли ТекТипСтр = "Дата" Тогда
					ТекТипСтр = ТекТипСтр + "("+ДатаСоставДаты+")";
				КонецЕсли;
			КонецЕсли;
			
			Результат.Добавить(ТекТипСтр);
			
		Иначе
			Результат.Добавить(СтрЗаменить(ОбъектМетаданных.ПолноеИмя(),".","Ссылка."));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат
КонецФункции

Процедура ОбновитьПредставленияОписанияТипов(ТаблицаНомеровКолонок, ВыводитьКвалификаторы = Истина) Экспорт
	
	Для Каждого СтрокаДанных Из ТаблицаНомеровКолонок Цикл
		СтрокаДанных.ТипЗначенияПредставление = СтрСоединить(
			ОписаниеТиповПредставление(СтрокаДанных.ТипЗначения, ВыводитьКвалификаторы).ВыгрузитьЗначения(),","
			);
	КонецЦикла;
			
КонецПроцедуры

Функция ТипПредставление(ТипЗначение) Экспорт
	
	Результат = Новый Массив;

	Если ТипЗнч(ТипЗначение) = Тип("ОписаниеТипов") Тогда
		
		Для Каждого ТекТип Из ТипЗначение.Типы() Цикл
			ОбъектМетаданных = Метаданные.НайтиПоТипу(ТекТип);
			Если ОбъектМетаданных = Неопределено Тогда
				Результат.Добавить(СокрЛП(ТекТип));
			Иначе
				Результат.Добавить(СтрЗаменить(ОбъектМетаданных.ПолноеИмя(),".","Ссылка."));
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗначение);
		Если ОбъектМетаданных = Неопределено Тогда
			Результат.Добавить(СокрЛП(ТипЗначение));
		Иначе
			Результат.Добавить(СтрЗаменить(ОбъектМетаданных.ПолноеИмя(),".","Ссылка."));
		КонецЕсли;
		
	КонецЕсли;

	Возврат Результат
КонецФункции

Процедура ЗагрузитьКолонкиПоТаблицеНомеровКолонок(ОбъектДанных, ТаблицаНомеровКолонок) Экспорт
	
	ОбъектДанных.Колонки.Очистить();
	
	//КЧ = Новый КвалификаторыЧисла(10,    0); текОписаниеТипов = Новый описаниеТипов("Число", , , КЧ);
	//ОбъектДанных.Колонки.Добавить("Ном", текОписаниеТипов, "№", 10);
	
	КС = Новый КвалификаторыСтроки(99); текОписаниеТипов = Новый описаниеТипов("Строка", , , , КС);
	ОбъектДанных.Колонки.Добавить("__ИмяЛиста__", текОписаниеТипов, "Имя листа", 10);
	
	// довляем колонки в таблицу данных по макету
	Для Каждого СтрКолонка Из ТаблицаНомеровКолонок Цикл
			
		ТекРеквизит  = СтрКолонка.Имя;
		ТекЗаголовок = СтрКолонка.Представление;
		ТекТип       = СтрКолонка.ТипЗначения;
		Если ПустаяСтрока(ТекРеквизит) Тогда Продолжить; КонецЕсли;
		
		Попытка
			ОбъектДанных.Колонки.Добавить(ТекРеквизит, ТекТип, ТекЗаголовок)
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьЭлементыФормыПоТаблицеНомеровКолонок(Форма, ИмяТаблицыФормы, ТаблицаНомеровКолонок) Экспорт
	
	ФиксКолонки = Новый Массив;
	ФиксКолонки.Добавить("Объект.ТаблицаДанныхExcelОбъект.НомерСтроки");
	ФиксКолонки.Добавить("Объект.ТаблицаДанныхExcelОбъект.КоличествоСтрок");
	ФиксКолонки.Добавить("Объект.ТаблицаДанныхExcelОбъект.Пометка");
									   
	// Очищаем все элементы-колонки "ИмяТаблицыФормы"
	Масс = Форма.Элементы[ИмяТаблицыФормы].ПодчиненныеЭлементы;
	Колво = Масс.Количество();
	Для Ном = 1 По Колво Цикл
		ТекЭл = Масс[Колво - Ном];
		Если ФиксКолонки.Найти(ТекЭл.ПутьКДанным) = Неопределено Тогда
			Форма.Элементы.Удалить(ТекЭл);
		КонецЕсли;
	КонецЦикла;
	
	КЧ = Новый КвалификаторыЧисла(10, 0); текОписаниеТипов = Новый описаниеТипов("Число", , , КЧ);
	
	// довляем колонки в таблицу данных по макету
	Для Каждого СтрКолонка Из ТаблицаНомеровКолонок Цикл
			
		ТекРеквизит  = СтрКолонка.Имя;
		ТекЗаголовок = СтрКолонка.Представление;
		ТекТип       = СтрКолонка.ТипЗначения;
		Если ПустаяСтрока(ТекРеквизит) Тогда Продолжить; КонецЕсли;
		
		Попытка
			Поле             = Форма.Элементы.Добавить(ИмяТаблицыФормы + ТекРеквизит, Тип("ПолеФормы"), Форма.Элементы[ИмяТаблицыФормы]);
			Поле.Вид         = ?(   ТекТип.СодержитТип(Тип("Булево")),      ВидПоляФормы.ПолеФлажка, ВидПоляФормы.ПолеВвода);
			Поле.Заголовок   = НСтр("ru = '" + ТекЗаголовок + "'");
			Поле.ПутьКДанным = "Объект."+ИмяТаблицыФормы + "." + ТекРеквизит;
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Получает картинку типа
//
// Параметры:
//  Тип  - Тип - Тип
//  ОписаниеТипов - ОписаниеТипов - Описание типов
//
// Возвращаемое значение:
//   Картинка - Картинка типа
//
Функция КартинкаТипа(Тип, ОписаниеТипов = Неопределено) Экспорт
	
	Если Тип = Тип("Неопределено") Тогда
		Картинка = Новый Картинка;
	ИначеЕсли Тип = Тип("Тип") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAA" + Символы.ВК + Символы.ПС + "AARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3" + Символы.ВК + Символы.ПС + "YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABoSURBVDhPY/j//z8DJZgizSCLB6EB" + Символы.ВК + Символы.ПС + "mpqa/52dHLFikBx6eGF4wczMFKTZG6QwNjbyPwiD2CAxkBxBA2Ca0Q2AGULQAGQF" + Символы.ВК + Символы.ПС + "yC7AFdV4Y2EkGwCKiYryov+geAdhEBs5dpADdBAmZVKzNgDOWtNtpSsLpgAAAABJ" + Символы.ВК + Символы.ПС + "RU5ErkJggg=="));
	ИначеЕсли Тип = Тип("Число") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAB+SURBVDhPY2AYBVhDwKFr538QdmnbAsbO7Vv/" + Символы.ВК + Символы.ПС + "EwoqkIIGmCKQJmQNaHyQHIp6mFq4JpgGm779YDEsBoCEMVyFYgDIC86tm8GuQncR" + Символы.ВК + Символы.ПС + "1Eb8BsA0gQzBYgBhLyDbTpYLQM4EGQKLDaRAhTkdvxfIiQW4HlC8w9IAsemAUDoZ" + Символы.ВК + Символы.ПС + "xPIAH+BkJrGgRacAAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("Строка") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAB1SURBVDhPY2AYLOA/0CEg3ECpg0CGgIFD1044" + Символы.ВК + Символы.ПС + "m5ChIFthLoBrcmnbQrQByAqpawDIGyBs37kTb9ggewHkXbArkL1ASnjAwwvZAFLC" + Символы.ВК + Символы.ПС + "A6sBSC5Adi3+KAf5G2QzWhhgDXBC0YwsT3TU4jKUqgaQZRjxgUhswAAA9DFDYfgs" + Символы.ВК + Символы.ПС + "T48AAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("Булево") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAFPSURBVDhPY2CgBvCfqN8QvsjwPwiHLTD47zhZ" + Символы.ВК + Символы.ПС + "/L/zFKn/QbP1/7tPUv7vPUn9v32X1P+AiQb/QWox7ARpJBZ4Nxv8p8gA4zwxTJc4" + Символы.ВК + Символы.ПС + "TZXA64CA7bL//bfJgtUYZoqBaRSXOEwSBwsG7ZX7H7xPDsUwkGan6RL/rVpFweL6" + Символы.ВК + Символы.ПС + "KRDasxrJKzADQIrcl8r+B2kCAeu9ImDN+rlC/09ePgIxIBliAMgl8LBwmAhxAUgR" + Символы.ВК + Символы.ПС + "yBC3JTJgQ9A1g9ToJSFcAjcgdK4B3NkgQ0A2YtMMUuRarA93CdyAoBkIA2AuUfcT" + Символы.ВК + Символы.ПС + "gTsbOVCcciAGgFwCNyAQmECIBQ7pemClIJfADfDtJN4A+0SIASCXwA0AJU/PKgNg" + Символы.ВК + Символы.ПС + "yEr8d8nT+68TLfJfL1b8v32G9n/jGPn/FrGq/3WCgXyg5tqpRWADQC7BSJGkugTD" + Символы.ВК + Символы.ПС + "AM9KiEtcS/UJusQ+URczU5GTswEMEielMbjVjwAAAABJRU5ErkJggg=="));
	ИначеЕсли Тип = Тип("Дата") Тогда
		
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAGPSURBVDhPrZPLSwJRFMb7k3rRH1GuWrRrHbQO" + Символы.ВК + Символы.ПС + "bNIcpUarTdSqx6akkoxCQkMqyBatIoJIIyeK6F2Olho6z69zb1hN2gNq4Mc55zvn" + Символы.ВК + Символы.ПС + "fPfCcOvq/uPTk2Ne3MbAOFmXcL0zCuQPeV1LY/O2c3c3p0Eix9fRAHnNAyt/8qUW" + Символы.ВК + Символы.ПС + "X/DBbrAxAXmp69fE50W7wfxqDHJqH/LRD9BMNnMLaWSg2sAsXsEsXMFisQLVFf2t" + Символы.ВК + Символы.ПС + "rxZqGxjZNIxcGk/9XVAcLZznmRGY2WOU4rO8NqlvlZTvDbgRLTH4EsWK6fcGd3sw" + Символы.ВК + Символы.ПС + "PqBTrjiawSLTK7lVvKl9A/0yAY3QL7fxJHRCaWtCccpN9avGau0iATN/XsMgEoF2" + Символы.ВК + Символы.ПС + "GiOi7/EsSkuN0M6YHuO5SrmZkyENeT/9hZVlqMdhqGk7mdYG0pegUe81D8NQjiAF" + Символы.ВК + Символы.ПС + "PHaDueVFqKkgyqlZPPa003A9Jz/ejXIy+KaxnvFwgEG/y24wFQrx6+sXWzDu93+k" + Символы.ВК + Символы.ПС + "TxTsBpOhkFcY8MI/LBJu+AMuQqhC8jvRKzohiIL9Mf3lRb8A8+FJK+/UducAAAAA" + Символы.ВК + Символы.ПС + "SUVORK5CYII="));
		Если ОписаниеТипов <> Неопределено Тогда
			Если ОписаниеТипов.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.Время Тогда
				Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABh0RVh0U29mdHdhcmUAcGFpbnQubmV0" + Символы.ВК + Символы.ПС + "IDQuMC42/Ixj3wAAAcNJREFUOE+NU9suQ0EUPf/iDyTiI0g8eheJROIbCK8IEW2K" + Символы.ВК + Символы.ПС + "JkhoXB4qxKWkfdC4tklzSvUitIi6t6Vu1Vq6hjk9cwgeTiYzZ9Zlr71Ha2/VNPPX" + Символы.ВК + Символы.ПС + "2T/YPDM/h16HE119g2LlnufWu9wr4PnVJTinZqEfxHGXu8dToYCrTAZBfR9Drmnw" + Символы.ВК + Символы.ПС + "v5XEICgrYCekowTgrfSO12IRVU19yD+/IPf4hLv7PHwb23SikAgC9/IiguF9BUx1" + Символы.ВК + Символы.ПС + "EkjwdSaH9E0G3o1d8L50orE2p2vmG5jKJKCyBJ9d3iJ1fgXb2KSRicaA9GjcsE1l" + Символы.ВК + Символы.ПС + "aZsEB6m0UJbgo9MLrPl3RLAixG77MLIPeVGzGUxlElS32RFKnAplghOpc4QiCfQ4" + Символы.ВК + Символы.ПС + "Rj4JOnoHBDhXX6sE5gnG0DAcxsJmRAFftzRiL54ULTYc3GSzKjgQE8p0YFaOHp0h" + Символы.ВК + Символы.ПС + "cniCQDhaccBa2GeZtucLTGUSSNsSvJdIYtHrr2TALnBIWHMkmRbKVttmsB47xsDo" + Символы.ВК + Символы.ПС + "RKULrIMT5i0PCdO2BmYFu1d8ykQqk7i6vqXUnK2rETXTNpXdHh86v8IzBsk823Ri" + Символы.ВК + Символы.ПС + "G3eJPrNVTJuBsWba/vUtSCL5Gtlntorrv1/jT8/1r7MPBZCljqnY77MAAAAASUVO" + Символы.ВК + Символы.ПС + "RK5CYII="));
			ИначеЕсли ОписаниеТипов.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.ДатаВремя Тогда
				Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOvwAADr8BOAVTJAAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAIuSURBVDhPrZPbTxNREMb5Y3xXo/HZZ9TE8GB8" + Символы.ВК + Символы.ПС + "8UFNaGJMrHcboNuKULsGGxUTKTWxSm2slhDTJVVMhBB80BgKQu1l2ULbZQu90QK9" + Символы.ВК + Символы.ПС + "bbef52yhTSOoD57kl8nMOfPNZCanre1/HHnxkQEJDhT+Yx9WZyxAfkH194rR9y11" + Символы.ВК + Символы.ПС + "v30aBgmqGM8cRnhcj1qe3zfmfW1Eq8DEM4Tfav4Zr4NpFXC85xD2zyL88y+QN5lU" + Символы.ВК + Символы.ПС + "An1s7+8CypYIZVNEjdpdiL8bb9yXN/cWqGZCqGZDyPVokD55TGX7BQslE0TRa1d9" + Символы.ВК + Символы.ПС + "hdzXiuk/C6hCJIlCkwJ8BBarHc+dbthcHgy9csEw8BRahu1uDJLOoLr2vQWZ+FTA" + Символы.ВК + Символы.ПС + "PGhDKp1FYVlAIJrARjik2tMXtU0RKiDHJ1EhyPEp5HTnkD5xBD3sEyTTGZRW4yhK" + Символы.ВК + Символы.ПС + "Ig5csCAhRCEEI+BjCXR2mevDdIyNoSJwBE/TRjywjrhAj1zYRrGi4LhxFOO+KOYi" + Символы.ВК + Символы.ПС + "KaxkS7hlerwjMOpGOehCOdQKNzGFZZZBsSQjKOVxtKMT3gUJ00tZTOru4Bqz08GI" + Символы.ВК + Символы.ПС + "+w3K/pco+e3YuNGBVPshlWHHOxRkBQev2BpMCzl4fCJ+SFu4rGfrHVidTrV9OfYZ" + Символы.ВК + Символы.ПС + "1fXZBvoHg1gS1xEJCpib59XK3JcAPsz4sSIlcUqjqwsMOZ0GXa8B/WaG0I1+UxdB" + Символы.ВК + Символы.ПС + "p1qyLohrSfC+RdL2bfi+ziNGktvPX8XZm/ebq9zvV9N9X2IGcP2eBVq9Cdq7D2li" + Символы.ВК + Символы.ПС + "I/kXf1WIeuufWvwAAAAASUVORK5CYII="));
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Тип = Тип("УникальныйИдентификатор") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAABFSURBVDhPY2AYPiA7O/s/CMN8BOMj0Q14fYvL" + Символы.ВК + Символы.ПС + "ADQDcRtCyACQQVA12A0hwQC4N1G8NKQMIC8M8AYgUgiTnw6GT5Yg2ScAOrt7BzPC" + Символы.ВК + Символы.ПС + "tocAAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("ХранилищеЗначения") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAH5SURBVDhPrZPfT1JhGMf507qQOaVaxpRumZCQ" + Символы.ВК + Символы.ПС + "5fLGiyhlaxEGGmvFKjEhRTaXsxyWDLDjRpScZjWYVMOSOQMn1Fi1fuqn8542Fp20" + Символы.ВК + Символы.ПС + "G8/2XJy9z/t93u/387463X5+r5LnnCtxLxH3UZYiNrX+/Bfre857nexnpyaxGLGy" + Символы.ВК + Символы.ПС + "szHI90IfP8p3WLjVzsflU2TCnewpICa+L4RITR2nmhuglD5JadlDMtBOMW5hfvjg" + Символы.ВК + Символы.ПС + "/wVyD1xMnDcg3TCRvGZEnnYQPKsnpmzeVUB4E9MzSv0s3UYKdfA130NN7uZTYZSY" + Символы.ВК + Символы.ПС + "30hZsjHnNfDPHIR3Nq+SuNJGJetBCnawsWjlzXwnxUcuVeDlXTPjA81MDZm0NlTv" + Символы.ВК + Символы.ПС + "eaXRd5gva2MkAkaqj+28SypZZEeI+o7wNmohcEavliZIIfBkskv1Kc8OEuzXM+Nu" + Символы.ВК + Символы.ПС + "UZsTkxfw9R7A39fEyG4Cwvt20UEudZlxbxu5xAlycRvZmJUX9y08f6iIXjyEPGNW" + Символы.ВК + Символы.ПС + "c9CcIB0yU33azYe8l9TEMSoZO5UlO5tpG6VUF+Vnl+oo77lbtQLSdRPbhd4GAp+z" + Символы.ВК + Символы.ПС + "Perl+ZvEtKtFKyDS31Imbq3crBNYX7CyplweQWJd9jeQ0FgQ6YuJ30pzdQKVlF1l" + Символы.ВК + Символы.ПС + "L0jUVmcbSGgFhgxOQWA1HWbM0UTU04o4atjZzKhDjxwPMXz6N4mY0rufD1j3C7vu" + Символы.ВК + Символы.ПС + "vw0TxEc9AAAAAElFTkSuQmCC"));
	ИначеЕсли Тип = Тип("ТаблицаЗначений") Тогда
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAA" + Символы.ВК + Символы.ПС + "AARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3" + Символы.ВК + Символы.ПС + "YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABSSURBVDhPY2CgBtBO6vyvktRPEtZM" + Символы.ВК + Символы.ПС + "6v4Pt9snIe8/Omjsn4kihM4H6UExAKSAFIxhAMUuABkwZdkmMAYBkr0w6gIqpIOB" + Символы.ВК + Символы.ПС + "jwVQyiIVUyMfUm4GAKJwQ6VUxt4aAAAAAElFTkSuQmCC"));
	Иначе
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
		Если ОбъектМетаданных <> Неопределено Тогда
			ИмяОбъектаКоллекцииМетаданных = ОбъектМетаданных.ПолноеИмя();
			Поз = Найти(ИмяОбъектаКоллекцииМетаданных,".");
			Картинка = БиблиотекаКартинок[Лев(ИмяОбъектаКоллекцииМетаданных, Поз-1)];
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Картинка;
	
КонецФункции

// Получает имя коллекции метаданных по имени объекта коллекции метаданных
//
// Параметры:
//  ИмяОбъектаКоллекцииМетаданных  - Строка - Имя объекта коллекции
//  Язык  - Строка - Язык
//
// Возвращаемое значение:
//   Строка - имя коллекции метаданных
//
Функция ИмяКоллекцииМетаданных(ИмяОбъектаКоллекцииМетаданных, Язык) Экспорт
	
	Если ИмяОбъектаКоллекцииМетаданных = "Справочник"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Catalog" Тогда
		
		Возврат НСтр("ru = 'Справочники'; en = 'Catalogs'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "Документ"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Document" Тогда
		
		Возврат НСтр("ru = 'Документы'; en = 'Documents'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "Перечисление"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Enum" Тогда
		
		Возврат НСтр("ru = 'Перечисления'; en = 'Enums'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "Константа"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Constant"Тогда
		
		Возврат НСтр("ru = 'Константы'; en = 'Constants'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "ЖурналДокументов"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "DocumentJournal" Тогда
		
		Возврат НСтр("ru = 'ЖурналыДокументов'; en = 'DocumentJournals'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "КритерийОтбора"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "FilterCriterion" Тогда
		
		Возврат НСтр("ru = 'КритерииОтбора'; en = 'FilterCriteria'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "ПланОбмена"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "ExchangePlan" Тогда
		
		Возврат НСтр("ru = 'ПланыОбмена'; en = 'ExchangePlans'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "Последовательность"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Sequence" Тогда
		
		Возврат НСтр("ru = 'Последовательности'; en = 'Sequences'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "ПланВидовХарактеристик"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "ChartOfCharacteristicTypes" Тогда
		
		Возврат НСтр("ru = 'ПланыВидовХарактеристик'; en = 'ChartsOfCharacteristicTypes'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "ПланВидовРасчета"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "ChartOfCalculationTypes" Тогда
		
		Возврат НСтр("ru = 'ПланыВидовРасчета'; en = 'ChartsOfCalculationTypes'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "ПланСчетов"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "ChartOfAccounts" Тогда
		
		Возврат НСтр("ru = 'ПланыСчетов'; en = 'ChartsOfAccounts'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "РегистрСведений"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "InformationRegister" Тогда
		
		Возврат НСтр("ru = 'РегистрыСведений'; en = 'InformationRegisters'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "РегистрНакопления"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "AccumulationRegister" Тогда
		
		Возврат НСтр("ru = 'РегистрыНакопления'; en = 'AccumulationRegisters'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "РегистрБухгалтерии"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "AccountingRegister" Тогда
		
		Возврат НСтр("ru = 'РегистрыБухгалтерии'; en = 'AccountingRegisters'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "РегистрРасчета"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "CalculationRegister" Тогда
		
		Возврат НСтр("ru = 'РегистрыРасчета'; en = 'CalculationRegisters'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "БизнесПроцесс"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "BusinessProcess" Тогда
		
		Возврат НСтр("ru = 'БизнесПроцессы'; en = 'BusinessProcesses'", Язык);
		
	ИначеЕсли ИмяОбъектаКоллекцииМетаданных = "Задача"
		ИЛИ ИмяОбъектаКоллекцииМетаданных = "Task" Тогда
		
		Возврат НСтр("ru = 'Задачи'; en = 'Tasks'", Язык);
		
	КонецЕсли;
	
КонецФункции

// Помещает в переданный массив имена реквизитов формы.
// Параметры:
//		Форма - ФормаКлиентскогоПриложения.
//		МассивИменРеквизитовФормы - Массив - заполняемый массив имен реквизитов формы.
//      ПутьКДанным - Строка - путь к родительскому реквизиту. 
//		                       Если параметр опущен или указана пустая строка, 
//		                       возвращаются реквизиты верхнего уровня.
//
Процедура ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы,  ПутьКДанным = "") Экспорт
	
	Если ЗначениеЗаполнено(ПутьКДанным) Тогда
		МассивРеквизитовФормы = Форма.ПолучитьРеквизиты(ПутьКДанным);
	Иначе
		МассивРеквизитовФормы = Форма.ПолучитьРеквизиты();
	КонецЕсли;
	
	Для Каждого Реквизит Из МассивРеквизитовФормы Цикл
		МассивИменРеквизитовФормы.Добавить(?(ЗначениеЗаполнено(ПутьКДанным), ПутьКДанным + ".", "") + Реквизит.Имя);
	КонецЦикла;
	
КонецПроцедуры

// Помещает в переданный массив имена реквизитов формы,
// "отложенные" для добавления в пакете и хранящиеся в реквизите "РеквизитыКДобавлению".
// Параметры:
//		Форма - ФормаКлиентскогоПриложения.
//		МассивИменРеквизитовФормы - Массив - заполняемый массив имен реквизитов формы.
//      ПутьКДанным - Строка - путь к родительскому реквизиту. 
//		                       Если параметр опущен или указана пустая строка, 
//		                       возвращаются реквизиты верхнего уровня.
//
Процедура ДополнитьМассивИменРеквизитовФормыИзРеквизитовКДобавлению(Форма, МассивИменРеквизитовФормы, ПутьКДанным = "") Экспорт

	Если МассивИменРеквизитовФормы.Найти("РеквизитыКДобавлению") <> Неопределено Тогда
		Для Каждого ДобавляемыйРеквизит Из Форма.РеквизитыКДобавлению.ВыгрузитьЗначения() Цикл
			Если ДобавляемыйРеквизит.Путь = ПутьКДанным Тогда
				МассивИменРеквизитовФормы.Добавить(?(ЗначениеЗаполнено(ПутьКДанным), ПутьКДанным + ".", "") + ДобавляемыйРеквизит.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Изменяет реквизиты формы
// Параметры:
// 		Форма, 
//		ДобавляемыеРеквизиты - массив добавляемых реквизитов.
//		СуществующиеРеквизиты - массив текущих реквизитов формы. Можно получить при помощи
//		                        ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы.
//		УдаляемыеРеквизиты - не обязательный. Массив удаляемых реквизитов.
//		ОтложенноеИзменение - по умолчанию Ложь. В случае если параметр равен Истина - добавления/удаления реквизитов не происходит, а происходит запись
//								данных реквизитов в реквизит формы с типом "СписокЗначений".
//
// В том случае, если реквизит уже существует, он не создается.
//
Процедура ИзменитьРеквизитыФормы(Форма, ДобавляемыеРеквизиты, СуществующиеРеквизиты, УдаляемыеРеквизиты = Неопределено, ОтложенноеИзменение = Ложь) Экспорт
	
	Если УдаляемыеРеквизиты = Неопределено Тогда
		УдаляемыеРеквизиты = Новый Массив;
	КонецЕсли;
	
	// Удаляем уже существующие реквизиты из ДобавляемыеРеквизиты.
	УжеСуществующиеРеквизиты = Новый Массив;
	ИменаУдаляемыхРеквизитов = Новый Массив;
	
	Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл
		ПолноеИмяРеквизита = ?(ЗначениеЗаполнено(Реквизит.Путь), Реквизит.Путь + ".", "") + Реквизит.Имя;
		Если СуществующиеРеквизиты.Найти(ПолноеИмяРеквизита) <> Неопределено Тогда
			УжеСуществующиеРеквизиты.Добавить(Реквизит);
			ИменаУдаляемыхРеквизитов.Добавить(ПолноеИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИменаУдаляемыхРеквизитов, УдаляемыеРеквизиты);
	
	// Из дополняемых реквизитов также удаляем те, которые содержатся внутри удаляемых реквизитов и дублей-реквизитов.
	Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл
		Если УжеСуществующиеРеквизиты.Найти(Реквизит) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Реквизит.Путь) Тогда
		    Продолжить;
		КонецЕсли;
		Если ИменаУдаляемыхРеквизитов.Найти(Реквизит.Путь) <> Неопределено Тогда
			УжеСуществующиеРеквизиты.Добавить(Реквизит);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Реквизит Из УжеСуществующиеРеквизиты Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ДобавляемыеРеквизиты, Реквизит);
	КонецЦикла;
	
	Если ДобавляемыеРеквизиты.Количество() = 0 И УдаляемыеРеквизиты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтложенноеИзменение Тогда
		Для Каждого Реквизит Из УдаляемыеРеквизиты Цикл
			Форма.РеквизитыКУдалению.Добавить(Реквизит);
		КонецЦикла;
		Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл
			Форма.РеквизитыКДобавлению.Добавить(Реквизит);
		КонецЦикла;
	Иначе
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты, УдаляемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункции_ПолучитьДанныеExcel

Функция ПолучитьДанныеExcel_ЗначениеЯчейки(КолонкаЗначение, ОписаниеТипаКолонки)
	
	КолонкаЗначениеЗапись = Неопределено;
	
	Для Каждого ПодчиненныйТип Из ОписаниеТипаКолонки.Типы() Цикл
		
		МассивТипа   = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПодчиненныйТип);
		ТипОписание  = Новый ОписаниеТипов(МассивТипа);
		ТипЗначение  = ТипОписание.ПривестиЗначение();
		
		Если ТипОписание.СодержитТип(Тип("Число")) Тогда
			КолонкаЗначениеЗапись = ЧислоИзСтроки(КолонкаЗначение);
			
		ИначеЕсли ТипОписание.СодержитТип(Тип("Дата")) Тогда
			КолонкаЗначениеЗапись = ДатаИзСтроки(КолонкаЗначение);
			
		ИначеЕсли ТипОписание.СодержитТип(Тип("Булево")) Тогда
			КолонкаЗначениеЗапись = (ВРЕГ(КолонкаЗначение) = "Y" Или ВРЕГ(КолонкаЗначение) = "ДА");
			
		ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ТипЗначение)) Тогда
			КолонкаЗначениеЗапись = ПолучитьДанныеExcel_ЗначениеЯчейкиДляСсылки(КолонкаЗначение, ТипЗначение);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КолонкаЗначениеЗапись) Тогда
			Прервать;
		КонецЕсли;
	
	КонецЦикла; // 1.1. Обход типов...
	
	Возврат КолонкаЗначениеЗапись
	
КонецФункции

Функция ПолучитьДанныеExcel_ЗначениеЯчейкиДляСсылки(КолонкаЗначение, ТипЗначение)
	
	КолонкаЗначениеЗапись = Неопределено;
			
	Если ОбщегоНазначения.ЭтоПеречисление(ТипЗначение.Метаданные()) Тогда
		
		Для Каждого ТекМД Из ТипЗначение.Метаданные().ЗначенияПеречисления Цикл
			Если ТекМД.Синоним = КолонкаЗначение Тогда
				КолонкаЗначениеЗапись = Перечисления[ТипЗначение.Метаданные().Имя][ТекМД.Имя];
				Прервать;
			ИначеЕсли ТекМД.Имя = КолонкаЗначение Тогда
				КолонкаЗначениеЗапись = Перечисления[ТипЗначение.Метаданные().Имя][ТекМД.Имя];
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ТипЗначение.Метаданные()) Тогда
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ТипЗначение);
		КолонкаЗначениеЗапись = Менеджер.НайтиПоНомеру(КолонкаЗначение);
		
		Если КолонкаЗначениеЗапись.Пустая() Тогда
			
			Если СтрНачинаетсяС(КолонкаЗначение, ТипЗначение.Метаданные().Синоним + " ") Тогда
				
				НомерДата = Сред(КолонкаЗначение, СтрДлина(ТипЗначение.Метаданные().Синоним + " ") + 1);
				ПозРазделитель = Найти(НомерДата, " от ");
				Если ПозРазделитель > 0 Тогда
					
					НомерДок = Лев(НомерДата, ПозРазделитель - 1);
					ДатаДок  = ДатаИзСтроки(Сред(НомерДата, ПозРазделитель + СтрДлина(" от ")));
					КолонкаЗначениеЗапись = Менеджер.НайтиПоНомеру(НомерДок, ДатаДок);
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ТипЗначение.Метаданные()) ИЛИ
			ОбщегоНазначения.ЭтоПланВидовРасчета(ТипЗначение.Метаданные()) Тогда
			
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ТипЗначение);
		КолонкаЗначениеЗапись = Менеджер.НайтиПоКоду(КолонкаЗначение);
	Иначе
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ТипЗначение);
		Если СокрЛП(ТипЗначение.Метаданные().ОсновноеПредставление) = "ВВидеКода" Тогда
			КолонкаЗначениеЗапись = Менеджер.НайтиПоКоду(КолонкаЗначение);
		Иначе
			КолонкаЗначениеЗапись = Менеджер.НайтиПоНаименованию(КолонкаЗначение, Истина);
		КонецЕсли;
		
	КонецЕсли;
			
	Возврат КолонкаЗначениеЗапись
	
КонецФункции

#КонецОбласти

Функция ДатаИзСтроки(ДатаСтрокой)
	
	Попытка
		Возврат Дата(Сред(ДатаСтрокой, 7, 4) + Сред(ДатаСтрокой, 4, 2) + Лев(ДатаСтрокой, 2));
	Исключение
		Возврат Дата("00010101");
	КонецПопытки;
	
КонецФункции // ДатаИзСтроки()

Функция ЧислоИзСтроки(ЧислоСтрокой)
	
	Попытка
		стрЧисло = СтрЗаменить(         ЧислоСтрокой, ",", "");
		стрЧисло = СтрЗаменить(         ЧислоСтрокой, ".", ",");
		стрЧисло = УдалитьПробелыСтроки(стрЧисло);
		Если ПустаяСтрока(стрЧисло) Тогда
			Возврат 0
		КонецЕсли;
		Возврат Число(стрЧисло);
	Исключение
		Возврат 0;
	КонецПопытки;
	
КонецФункции // ДатаИзСтроки()

Функция УдалитьПробелыСтроки(Строка)
	
	СтрокаВозврат = "";
	Для й = 1 По СтрДлина(Строка) Цикл
		текСимв = Сред(Строка, й, 1);
		Если КодСимвола(текСимв) = 160 Или КодСимвола(текСимв) = 32 Тогда Продолжить;КонецЕсли;
		//--
		СтрокаВозврат = СтрокаВозврат + текСимв
	КонецЦикла;
	
	Возврат СтрокаВозврат
КонецФункции // УдалитьПробелыСтроки()

Функция ЭтоПустаяСтрока(МассивЯчеек)
	
	Для Каждого ТекЯчейка Из МассивЯчеек Цикл
		Если Не ПустаяСтрока(ТекЯчейка) Тогда
			Возврат Ложь
		КонецЕсли;
	КонецЦикла;

	Возврат Истина
КонецФункции

// Преобразует "мама мыла раму" в "МамаМылаРаму".
Функция ИмяПоПредставлению(Представление)
	
	Строка_Текущая = Представление;
	
	Пока Найти(Строка_Текущая, "  ") > 0 Цикл
		Строка_Текущая = СтрЗаменить(Строка_Текущая, "  ", " ");
	КонецЦикла;
	
	Строка_Текущая = СтрЗаменить(Строка_Текущая, ".", "_");
	Строка_Текущая = СтрЗаменить(Строка_Текущая, "-", "_");
	Строка_Текущая = СтрЗаменить(Строка_Текущая, Символ(160), "");
	
	// обрезаем спецсимволы в строке
	Строка_Текущая1 = Строка_Текущая;
	
	Строка_Текущая = "";
	Для й = 1 По СтрДлина(Строка_Текущая1) Цикл
		текСимвол = Сред(Строка_Текущая1, й, 1);
		Если ЭтоБуква(текСимвол) Или ЭтоЦифра(текСимвол) Или
			текСимвол = " " Или текСимвол = "_" Тогда
			Строка_Текущая = Строка_Текущая + текСимвол;
		КонецЕсли;
	КонецЦикла;
	Строка_Текущая1 = Строка_Текущая;
	
	// "пробел+букву" заменяем на букву в верхнем регистре
	Строка_Результат = "";
	Пока Найти(Строка_Текущая1, " ") > 0 Цикл
		
		поз = Найти(Строка_Текущая1, " ");
		Строка_Результат = Строка_Результат + ВРег(Лев(Строка_Текущая1, 1)) + Сред(Строка_Текущая1, 2, поз - 2);
		
		Строка_Текущая1 = Сред(Строка_Текущая1, поз + 1);
	КонецЦикла;
	Строка_Результат = Строка_Результат + ВРег(Лев(Строка_Текущая1, 1)) + Сред(Строка_Текущая1, 2);
	
	//Идентификатор не должен начинаться с цифры
	Если ЭтоЦифра(Лев(Строка_Результат,1)) Тогда
		Строка_Результат = "_" + Строка_Результат
	КонецЕсли;
	
	Возврат  Строка_Результат
КонецФункции

Функция ЭтоЦифра(Символ)
	
	Возврат (Найти("0123456789", Символ) > 0);
	
КонецФункции

Функция ЭтоБуква(Символ)
	
	Код = КодСимвола(Символ);
	
	Если (Код<=47) ИЛИ (Код>=58 И Код<=64) ИЛИ (Код>=91 И Код<=96)  ИЛИ (Код>=123 И Код<=126) Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

