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
	
		Заголовок = СтрШаблон(НСтр("ru = 'Редактирование типа %1'; en = 'Edit type %1'"), Параметры.Заголовок);
			
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
			
			Если СтрНачинаетсяС(ИмяКоллекцииМетаданных, "Регистр") Тогда
				ДобавитьСтрокуДерева(НоваяСтрока, СтрШаблон("%1КлючЗаписи.%2", ИмяОбъектаМетаданных, ОбъектМетаданных.Имя), ОбъектМетаданных.Имя, НоваяСтрока.Картинка);
			Иначе
				ДобавитьСтрокуДерева(НоваяСтрока, СтрШаблон("%1Ссылка.%2", ИмяОбъектаМетаданных, ОбъектМетаданных.Имя), ОбъектМетаданных.Имя, НоваяСтрока.Картинка);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции

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

