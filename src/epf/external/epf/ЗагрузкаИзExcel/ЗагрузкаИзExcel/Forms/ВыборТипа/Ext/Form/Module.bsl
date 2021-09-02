﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Значение") Тогда
		
        СтрокаДлина    = Параметры.Значение.КвалификаторыСтроки.Длина;
        ЧислоТочность  = Параметры.Значение.КвалификаторыЧисла.РазрядностьДробнойЧасти;
        ЧислоДлина     = Параметры.Значение.КвалификаторыЧисла.Разрядность;
        ДатаСоставДаты = СокрЛП(Параметры.Значение.КвалификаторыДаты.ЧастиДаты);
		
		Результат.ЗагрузитьЗначения(ОбъектОбработки().ОписаниеТиповПредставление(Параметры.Значение, Ложь).ВыгрузитьЗначения());
		
		Если Параметры.Значение.Типы().Количество() > 1 Тогда
			СоставнойТип = Истина
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.КодЯзыкаПрограммирования = "ru";
	
	Если Параметры.РежимПоискаТипов Тогда
		
		СоставнойТип = Истина;
		Элементы.ГруппаШапка.Видимость = Ложь;
		ЭтаФорма.Заголовок = "Метаданные для поиска имен реквизитов:";
		
	Иначе
	
		Заголовок = ПодставитьПараметрыВСтроку(НСтр("ru = 'Редактирование типа %1'; en = 'Edit type %1'"), Параметры.Заголовок);
			
		ДобавитьСтрокуДерева(ДеревоВыбора, "Неопределено", НСтр("ru = 'Неопределено'; en = 'Undefined'", Параметры.КодЯзыкаПрограммирования));
		ДобавитьСтрокуДерева(ДеревоВыбора, "Null");
		ДобавитьСтрокуДерева(ДеревоВыбора, "Число", НСтр("ru = 'Число'; en = 'Number'", Параметры.КодЯзыкаПрограммирования), ОбъектОбработки().КартинкаТипа(Тип("Число")));
		ДобавитьСтрокуДерева(ДеревоВыбора, "Строка", НСтр("ru = 'Строка'; en = 'String'", Параметры.КодЯзыкаПрограммирования), ОбъектОбработки().КартинкаТипа(Тип("Строка")));
		ДобавитьСтрокуДерева(ДеревоВыбора, "Булево", НСтр("ru = 'Булево'; en = 'Boolean'", Параметры.КодЯзыкаПрограммирования), ОбъектОбработки().КартинкаТипа(Тип("Булево")));
		ДобавитьСтрокуДерева(ДеревоВыбора, "Дата", НСтр("ru = 'Дата'; en = 'Date'", Параметры.КодЯзыкаПрограммирования), ОбъектОбработки().КартинкаТипа(Тип("Дата")));
		ДобавитьСтрокуДерева(ДеревоВыбора, "УникальныйИдентификатор", НСтр("ru = 'УникальныйИдентификатор'; en = 'UUID'", Параметры.КодЯзыкаПрограммирования) , ОбъектОбработки().КартинкаТипа(Тип("УникальныйИдентификатор")));
		//ДобавитьСтрокуДерева(ДеревоВыбора, "ХранилищеЗначения", НСтр("ru = 'ХранилищеЗначения'; en = 'ValueStorage'", Параметры.КодЯзыкаПрограммирования), ОбъектОбработки().КартинкаТипа(Тип("ХранилищеЗначения")));
		
	КонецЕсли;
	
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "Справочник");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "Документ");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "Перечисление");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "ПланВидовХарактеристик");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "ПланСчетов");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "ПланВидовРасчета");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "БизнесПроцесс");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "Задача");
	ДобавитьСтрокуКоллекцию(ДеревоВыбора, "ПланОбмена");

	Если Параметры.РежимПоискаТипов Тогда
		
		ДобавитьСтрокуКоллекцию(ДеревоВыбора, "РегистрСведений");
		ДобавитьСтрокуКоллекцию(ДеревоВыбора, "РегистрНакопления");
		ДобавитьСтрокуКоллекцию(ДеревоВыбора, "РегистрБухгалтерии");
		ДобавитьСтрокуКоллекцию(ДеревоВыбора, "РегистрРасчета");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Результат.Количество() > 0 Тогда
		УстановитьВыбранныеТипы();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоВыбора

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДобавитьСтрокуДерева(СтрокаПриемник, Значение, Представление = "", Картинка = Неопределено, Порядок = 0)

	НоваяСтрока = СтрокаПриемник.ПолучитьЭлементы().Добавить();
	НоваяСтрока.Значение = Значение;
	НоваяСтрока.Представление = ?(ЗначениеЗаполнено(Представление), Представление, Значение);
	НоваяСтрока.Картинка = Картинка;
	НоваяСтрока.Порядок = Порядок;
	
	//МД = Метаданные.НайтиПоПолномуИмени(СтрЗаменить(Значение,"Ссылка.","."));
	//Если МД <> Неопределено Тогда
	//	НоваяСтрока.Синоним = МД.Синоним
	//КонецЕсли;
	
    Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция ДобавитьСтрокуКоллекцию(СтрокаПриемник, ИмяОбъектаМетаданных)

	ИмяКоллекцииМетаданных = ОбъектОбработки().ИмяКоллекцииМетаданных(ИмяОбъектаМетаданных, Параметры.КодЯзыкаПрограммирования);
	МетаданныеКоллекции = Метаданные[ИмяКоллекцииМетаданных];
	
	Если МетаданныеКоллекции.Количество() Тогда
		
		НоваяСтрока = ДобавитьСтрокуДерева(СтрокаПриемник, , ИмяКоллекцииМетаданных, БиблиотекаКартинок[ИмяОбъектаМетаданных]);
		Для Каждого ОбъектМетаданных Из МетаданныеКоллекции Цикл
			
			Если Лев(ИмяКоллекцииМетаданных, 7) = "Регистр" Тогда
				ДобавитьСтрокуДерева(НоваяСтрока, ПодставитьПараметрыВСтроку("%1КлючЗаписи.%2", ИмяОбъектаМетаданных, ОбъектМетаданных.Имя), ОбъектМетаданных.Имя, НоваяСтрока.Картинка);
			Иначе
				ДобавитьСтрокуДерева(НоваяСтрока, ПодставитьПараметрыВСтроку("%1Ссылка.%2", ИмяОбъектаМетаданных, ОбъектМетаданных.Имя), ОбъектМетаданных.Имя, НоваяСтрока.Картинка);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

#Область БСП

&НаКлиентеНаСервереБезКонтекста
// Функция "расщепляет" строку на подстроки, используя заданный
//      разделитель. Разделитель может иметь любую длину.
//      Если в качестве разделителя задан пробел, рядом стоящие пробелы
//      считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр
//      игнорируются.
//      Например,
//      РазложитьСтрокуВМассивПодстрок(",один,,,два", ",") возвратит массив значений из пяти элементов,
//      три из которых - пустые строки, а
//      РазложитьСтрокуВМассивПодстрок(" один   два", " ") возвратит массив значений из двух элементов
//
//  Параметры:
//      Стр -           строка, которую необходимо разложить на подстроки.
//                      Параметр передается по значению.
//      Разделитель -   строка-разделитель, по умолчанию - запятая.
//
//  Возвращаемое значение:
//      массив значений, элементы которого - подстроки
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз - 1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				Если (СокрЛП(Стр) <> "") Тогда
					МассивСтрок.Добавить(Стр);
				КонецЕсли;
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз - 1));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Возвращает строку, полученную из массива элементов, разделенных символом разделителя
//
// Параметры:
//  Массив - Массив - массив элементов из которых необходимо получить строку
//  Разделитель - Строка - любой набор символов, который будет использован как разделитель между элементами в строке
//
// Возвращаемое значение:
//  Результат - Строка - строка, полученная из массива элементов, разделенных символом разделителя
// 
Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",")
	
	// возвращаемое значение функции
	Результат = "";
	
	Для Каждого Элемент Из Массив Цикл
		
		Подстрока = ?(ТипЗнч(Элемент) = Тип("Строка"), Элемент, Строка(Элемент));
		
		РазделительПодстрок = ?(ПустаяСтрока(Результат), "", Разделитель);
		
		Результат = Результат + РазделительПодстрок + Подстрока;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  ШаблонСтроки  - Строка - шаблон строки с параметрами (вхождениями вида "%<номер параметра>", 
//                           например "%1 пошел в %2");
//  Параметр<n>   - Строка - значение подставляемого параметра.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел
//  в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач ШаблонСтроки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	ЕстьПараметрыСПроцентом = Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ЕстьПараметрыСПроцентом Тогда
		Возврат ПодставитьПараметрыСПроцентом(ШаблонСтроки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%1", Параметр1);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%2", Параметр2);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%3", Параметр3);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%4", Параметр4);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%5", Параметр5);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%6", Параметр6);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%7", Параметр7);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%8", Параметр8);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%9", Параметр9);
	Возврат ШаблонСтроки;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыСПроцентом(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = Неопределено;
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр = Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр = Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр = Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр = Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр = Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр = Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр = Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр = Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр = Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = Неопределено Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Проверяет наличие реквизита или свойства у произвольного объекта без обращения к метаданным.
//
// Параметры:
//  Объект       - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ИмяРеквизита - Строка       - имя реквизита или свойства.
//
// Возвращаемое значение:
//  Булево - Истина, если есть.
//
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

#КонецОбласти

#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Процедура ПрочитатьВыбранныеТипы(МассивТипов, СтрокаДерева = Неопределено)
	
	Если СтрокаДерева = Неопределено Тогда
		УзелДерева = ДеревоВыбора
	Иначе
		УзелДерева = СтрокаДерева
	КонецЕсли;
	
	Для Каждого УзелПодч Из УзелДерева.ПолучитьЭлементы() Цикл
		Если УзелПодч.Пометка И ЗначениеЗаполнено(УзелПодч.Значение) Тогда
			МассивТипов.Добавить(Тип(УзелПодч.Значение));
		Иначе
			ПрочитатьВыбранныеТипы(МассивТипов, УзелПодч)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбранныеТипы(СтрокаДерева = Неопределено)
	
	Если СтрокаДерева = Неопределено Тогда
		УзелДерева = ДеревоВыбора
	Иначе
		УзелДерева = СтрокаДерева
	КонецЕсли;
	
	Хоть1Помечен = Ложь;  УзелТекущий = Неопределено;
	Для Каждого УзелПодч Из УзелДерева.ПолучитьЭлементы() Цикл
		
		Если Не ПустаяСтрока(УзелПодч.Значение) И
			Результат.НайтиПоЗначению(УзелПодч.Значение) <> Неопределено Тогда
			 
			УзелПодч.Пометка = Истина;
			Хоть1Помечен = Истина;
			Если УзелТекущий = Неопределено Тогда
				УзелТекущий = УзелПодч;
			КонецЕсли;
		Иначе
			УзелПодч.Пометка = Ложь;
			УстановитьВыбранныеТипы(УзелПодч);
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтрокаДерева <> Неопределено И УзелДерева.ПолучитьЭлементы().Количество() > 0 И Хоть1Помечен Тогда
		УзелДерева.Пометка = Истина
	КонецЕсли;
	
	Если УзелТекущий <> Неопределено Тогда
		Элементы.ДеревоВыбора.ТекущаяСтрока = УзелТекущий.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВыбранныеТипы(СтрокаДерева = Неопределено)
	
	Если СтрокаДерева = Неопределено Тогда
		Результат.Очистить();
		УзелДерева = ДеревоВыбора
	Иначе
		УзелДерева = СтрокаДерева
	КонецЕсли;
	
	Для Каждого УзелПодч Из УзелДерева.ПолучитьЭлементы() Цикл
		
		Если УзелПодч.Пометка Тогда
			Если ЗначениеЗаполнено(УзелПодч.Значение) Тогда
				Результат.Добавить(УзелПодч.Значение)
			Иначе
				ПолучитьВыбранныеТипы(УзелПодч);
			КонецЕсли;
		Иначе
			ПолучитьВыбранныеТипы(УзелПодч);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	МассивТипов = Новый Массив;
	ПрочитатьВыбранныеТипы(МассивТипов);
	
	ЧастьДаты = ЧастиДаты.Дата;
	Если ДатаСоставДаты = "Дата и время" Тогда
		ЧастьДаты = ЧастиДаты.ДатаВремя
	ИначеЕсли ДатаСоставДаты = "Дата" Тогда
		ЧастьДаты = ЧастиДаты.Дата
	ИначеЕсли ДатаСоставДаты = "Время" Тогда
		ЧастьДаты = ЧастиДаты.Время
	КонецЕсли;
	
	ОписаниеРезультат = Новый ОписаниеТипов(МассивТипов,,,
		Новый КвалификаторыЧисла(ЧислоДлина,ЧислоТочность),
		Новый КвалификаторыСтроки(СтрокаДлина),
		Новый КвалификаторыДаты(ЧастьДаты));
		
	Если Параметры.РежимПоискаТипов Тогда
		Оповестить("ПоискТиповОтбор", ОписаниеРезультат, ЭтаФорма);
	Иначе
		Оповестить("ОписаниеТипов", ОписаниеРезультат, ЭтаФорма);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораПометкаПриИзменении(Элемент)
	
	УзелДерева = Элементы.ДеревоВыбора.ТекущиеДанные;
	
	Если НЕ СоставнойТип И УзелДерева.ПолучитьЭлементы().Количество()>0 Тогда
		// Если тип НЕ составной - узлы типа "Справочник", "Документ" не отмечаем.
		УзелДерева.Пометка = НЕ УзелДерева.Пометка;
		Возврат
	КонецЕсли;
	
	Если СоставнойТип Тогда
		
		Пометка = УзелДерева.Пометка;
		
		// Отмечаем/снимаем пометку у всех подчиненных узлов.
		Для Каждого УзелПодч Из УзелДерева.ПолучитьЭлементы() Цикл
			УзелПодч.Пометка = Пометка;
			Если Пометка И Результат.НайтиПоЗначению(УзелПодч.Значение) = Неопределено Тогда
				Результат.Добавить(УзелПодч.Значение);
			ИначеЕсли НЕ Пометка И Результат.НайтиПоЗначению(УзелПодч.Значение) <> Неопределено Тогда
				Результат.Добавить(УзелПодч.Значение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;

	// Отмечаем родительский узел (если есть).
	УзелРодитель = УзелДерева.ПолучитьРодителя();
	Если УзелРодитель <> Неопределено Тогда
		УзелРодитель.Пометка = УзелДерева.Пометка
	КонецЕсли;
	
	Если СоставнойТип Тогда
		// Читаем отмеченные типы в верхнее поле "Выбранные типы"
		ПолучитьВыбранныеТипы();
	Иначе
		// Осталяем только 1 выбранный тип.
		Результат.Очистить();
		Если УзелДерева.Пометка Тогда
			Результат.Добавить(УзелДерева.Значение);
		КонецЕсли;
		УстановитьВыбранныеТипы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставнойТипПриИзменении(Элемент)
	
	Если НЕ СоставнойТип Тогда
		
		// Осталяем только 1 выбранный тип.
		Если Результат.Количество() > 0 Тогда
			Значение = Результат[0].Значение;
			Результат.Очистить();
			Результат.Добавить(Значение);
		Иначе
			Результат.Очистить();
		КонецЕсли;
		
		УстановитьВыбранныеТипы();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ СоставнойТип Тогда
		
		УзелДерева = Элементы.ДеревоВыбора.ТекущиеДанные;
		УзелДерева.Пометка = Истина;
		ДеревоВыбораПометкаПриИзменении(Элемент);
		Если УзелДерева.Пометка Тогда
			Выбрать(Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораПриАктивизацииСтроки(Элемент)

	Элементы.ТипДата.Видимость = Ложь;
	Элементы.ТипЧисло.Видимость = Ложь;
	Элементы.ТипСтрока.Видимость = Ложь;
	
	УзелДерева = Элементы.ДеревоВыбора.ТекущиеДанные;
	Если УзелДерева = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если УзелДерева.Значение = "Строка" Тогда
		Элементы.ТипСтрока.Видимость = Истина;
	ИначеЕсли УзелДерева.Значение = "Число" Тогда
		Элементы.ТипЧисло.Видимость = Истина;
	ИначеЕсли УзелДерева.Значение = "Дата" Тогда
		Элементы.ТипДата.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

