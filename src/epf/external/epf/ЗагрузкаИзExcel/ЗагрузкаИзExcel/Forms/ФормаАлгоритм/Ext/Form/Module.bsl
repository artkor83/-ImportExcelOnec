﻿
&НаКлиенте
Процедура ДобавитьОбработкуКолонок(Команда)
	
	Если Параметры.АлгоритмИмя = "Алгоритм_ПоискДанныхСтроки" Тогда
		ДобавитьОбработкуКолонок_ПоискДанныхСтроки(Команда);
	Иначе
		ДобавитьОбработкуКолонок_ПослеЧтенияДанных(Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОбработкуКолонок_ПоискДанныхСтроки(Команда)
	
	СтрокаПараметры = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаЗначения Цикл
		СтрокаПараметры = СтрокаПараметры + "
		|//Значение"+СтрокаДанных.Имя+" = ЗначенияДанных."+СтрокаДанных.Имя+";";		
	КонецЦикла;
	
	ТекстКолонок = "";
	
	НомерСтроки = 0;
	Для Каждого СтрокаКол Из ВладелецФормы.ТаблицаНомеровКолонок Цикл
		
		НомерСтроки = НомерСтроки + 1;
		
		Префикс = "";
		Если НомерСтроки <> 1 Тогда
			Префикс = "Иначе";
		КонецЕсли;
		ТекстКолонок = ТекстКолонок + "
			|"+Префикс+"Если ТекРеквизит = """+СтрокаКол.Имя+""" Тогда
			|";
	
	КонецЦикла;
	
	ТекстКолонок = ТекстКолонок + "
		|КонецЕсли;
		|";
	
	АлгоритмТекст = СтрокаПараметры + "
		|
		|" + ТекстКолонок + "
		|
		|" + АлгоритмТекст;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОбработкуКолонок_ПослеЧтенияДанных(Команда)
	
	Текст = "// {{ КОПИРУЕМ ВО ВНЕШНЮЮ ОБРАБОТКУ, УБИРАЕМ ЛИШНИЙ КОД...
	|Процедура <Имя метода>(ТаблицаДанныхExcel, ПараметрыЧтенияДанных) Экспорт
	|";
	
	// Запрос для отчета по загрузке. +
	СтрокаЗапросДляОтчета = "
	|	//(Используем конструктор запроса с обработкой результата для вывода в ТабДок)
	|	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	|	Запрос = Новый Запрос;
	|	Запрос.Текст =
	|		""ВЫБРАТЬ";
	
	СтрокаЗапросДляОтчетаПоля = "";
	КолонкиГрупп = "";	КолонкиСумм = ""; Кол = 0;
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаНомеровКолонок Цикл
		Кол = Кол + 1;
		Если СтрокаДанных.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			КолонкиСумм = КолонкиСумм + СтрокаДанных.Имя+",";
		Иначе
			КолонкиГрупп = КолонкиГрупп + СтрокаДанных.Имя+",";
		КонецЕсли;
		СтрокаЗапросДляОтчетаПоля = СтрокаЗапросДляОтчетаПоля + "
		|		|	ТаблицаДанных."+СтрокаДанных.Имя+" КАК "+СтрокаДанных.Имя +
			?(Кол = ВладелецФормы.ТаблицаНомеровКолонок.Количество(),"",",");
	КонецЦикла;
	
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + СтрокаЗапросДляОтчетаПоля;
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + "
	|		|ПОМЕСТИТЬ ВТТаблицаДанныхExcel
	|		|ИЗ
	|		|	&ТаблицаДанныхExcel КАК ТаблицаДанных;
	|		|
	|		|////////////////////////////////////////////////////////////////////////////////
	|		|ВЫБРАТЬ ";
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + СтрокаЗапросДляОтчетаПоля;
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + "
	|		|ИЗ
	|		|	ВТТаблицаДанныхExcel КАК ТаблицаДанных"";
	|	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	|
	|	Запрос.УстановитьПараметр(""ТаблицаДанныхExcel"", ТаблицаДанныхExcel);
	|";
	// Запрос для отчета по загрузке -
	
	СтрокаПараметры = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаЗначения Цикл
		СтрокаПараметры = СтрокаПараметры + "
		|	Значение"+СтрокаДанных.Имя+" = ПараметрыЧтенияДанных.ЗначенияДанных."+СтрокаДанных.Имя+";";
	КонецЦикла;
	
	Текст = Текст + "
		|	// Фиксированные значения с закладки ""Параметры"". " +
		СтрокаПараметры + "
		|
		|	// Отчет после чтения данных (возможно добавить несколько).
		|	ТабДок = Новый ТабличныйДокумент;
		|	ТабДок.ТолькоПросмотр = истина;
		|	ПараметрыЧтенияДанных.ОтчетыПослеЧтенияДанных.Вставить(""Отчет"", ТабДок);
		|
		|	ТекстДок = Новый ТекстовыйДокумент;
		|	ТекстДок.ТолькоПросмотр = истина;
		|	ПараметрыЧтенияДанных.ОтчетыПослеЧтенияДанных.Вставить(""Отчет (текст)"", ТекстДок);
		|" +
		СтрокаЗапросДляОтчета + "
		|
		|	// Таблица загрузки: список колонок.  
		|	ТаблицаДанныхExcel.Свернуть(""" + Лев(КолонкиГрупп,СтрДлина(КолонкиГрупп)-1)+ """, """ +Лев(КолонкиСумм,СтрДлина(КолонкиСумм)-1) + """);
		|
		|	Для каждого ДанныеСтроки Из ТаблицаДанныхExcel Цикл
		|		// алгоритм после чтения данных
		|	КонецЦикла;
		|
		|";
		
	Текст = Текст +"
	|КонецПроцедуры
	|//  ЗАКОНЧИЛИ КОПИРОВАТЬ КОД... }}";
	
	АлгоритмТекст = АлгоритмТекст + Текст;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьБуферКода(Команда)

	Если Параметры.АлгоритмИмя = "Алгоритм_ЗагрузкаДанныхСтроки" Тогда
		ДобавитьБуферКодаАлгоритм_ЗагрузкаДанныхСтроки();
	Иначе
		ДобавитьБуферКодаАлгоритм_ПередЗагрузкойДанных();
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьБуферКодаАлгоритм_ПередЗагрузкойДанных()

	Текст = "// {{ КОПИРУЕМ ВО ВНЕШНЮЮ ОБРАБОТКУ, УБИРАЕМ ЛИШНИЙ КОД...
	|Процедура <Имя метода>(ТаблицаДанныхExcel, ПараметрыЗагрузкиДанных, СтандартнаяОбработка) Экспорт
	|";
	
	// Запрос для отчета по загрузке. +
	СтрокаЗапросДляОтчета = "
	|	//(Используем конструктор запроса с обработкой результата для вывода в ТабДок)
	|	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	|	Запрос = Новый Запрос;
	|	Запрос.Текст =
	|		""ВЫБРАТЬ";
	
	СтрокаЗапросДляОтчетаПоля = "";
	КолонкиГрупп = "";	КолонкиСумм = ""; Кол = 0;
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаНомеровКолонок Цикл
		Кол = Кол + 1;
		Если СтрокаДанных.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			КолонкиСумм = КолонкиСумм + СтрокаДанных.Имя+",";
		Иначе
			КолонкиГрупп = КолонкиГрупп + СтрокаДанных.Имя+",";
		КонецЕсли;
		СтрокаЗапросДляОтчетаПоля = СтрокаЗапросДляОтчетаПоля + "
		|		|	ТаблицаДанных."+СтрокаДанных.Имя+" КАК "+СтрокаДанных.Имя +
			?(Кол = ВладелецФормы.ТаблицаНомеровКолонок.Количество(),"",",");
	КонецЦикла;
	
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + СтрокаЗапросДляОтчетаПоля;
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + "
	|		|ПОМЕСТИТЬ ВТТаблицаДанныхExcel
	|		|ИЗ
	|		|	&ТаблицаДанныхExcel КАК ТаблицаДанных;
	|		|
	|		|////////////////////////////////////////////////////////////////////////////////
	|		|ВЫБРАТЬ ";
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + СтрокаЗапросДляОтчетаПоля;
	СтрокаЗапросДляОтчета = СтрокаЗапросДляОтчета + "
	|		|ИЗ
	|		|	ВТТаблицаДанныхExcel КАК ТаблицаДанных"";
	|	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	|
	|	Запрос.УстановитьПараметр(""ТаблицаДанныхExcel"", ТаблицаДанныхExcel);
	|";
	// Запрос для отчета по загрузке -
	
	СтрокаПараметры = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаЗначения Цикл
		СтрокаПараметры = СтрокаПараметры + "
		|	Значение"+СтрокаДанных.Имя+" = ПараметрыЗагрузкиДанных.ЗначенияДанных."+СтрокаДанных.Имя+";";
	КонецЦикла;
	
	СтрокаМакеты = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаВнешниеФайлы Цикл
		Если Прав(СтрокаДанных.Имя, 4) = ".mxl" Тогда
			МакетИмя = СтрЗаменить(СтрокаДанных.Имя,".mxl","");
			СтрокаМакеты = СтрокаМакеты + "
			|	Макет"+МакетИмя+" = ПараметрыЗагрузкиДанных.Макеты."+МакетИмя+";";
		КонецЕсли;
	КонецЦикла;
	
	Текст = Текст + "
		|	// Макеты с закладки ""Внешние файлы"". " +
		СтрокаМакеты + "
		|
		|	// Фиксированные значения с закладки ""Параметры"". " +
		СтрокаПараметры + "
		|
		|	// Отчет по загрузке (возможно добавить несколько).
		|	ТабДок = Новый ТабличныйДокумент;
		|	ТабДок.ТолькоПросмотр = Истина;
		|	ПараметрыЗагрузкиДанных.ОтчетыПоЗагрузке.Вставить(""Отчет по загрузке данных"", ТабДок);
		|
		|	ТекстДок = Новый ТекстовыйДокумент;
		|	ТекстДок.ТолькоПросмотр = Истина;
		|	ПараметрыЗагрузкиДанных.ОтчетыПоЗагрузке.Вставить(""Отчет по загрузке данных(текст)"", ТекстДок);
		|" +
		СтрокаЗапросДляОтчета + "
		|
		|	// Таблица загрузки: список колонок.  
		|	ТаблицаДанныхExcel.Свернуть(""" + Лев(КолонкиГрупп,СтрДлина(КолонкиГрупп)-1)+ """, """ +Лев(КолонкиСумм,СтрДлина(КолонкиСумм)-1) + """);
		|
		|	Для каждого ДанныеСтроки Из ТаблицаДанныхExcel Цикл
		|		// алгоритм обработки загрузки
		|	КонецЦикла;
		|
		|	// Признак отказа от дальнейшей построчной загрузки данных. 
		|	СтандартнаяОбработка = ложь;
		|";
		
	Текст = Текст +"
	|КонецПроцедуры
	|//  ЗАКОНЧИЛИ КОПИРОВАТЬ КОД... }}";
	
	АлгоритмТекст = АлгоритмТекст + Текст;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьБуферКодаАлгоритм_ЗагрузкаДанныхСтроки()

	Текст = "// {{ КОПИРУЕМ ВО ВНЕШНЮЮ ОБРАБОТКУ, УБИРАЕМ ЛИШНИЙ КОД...
	|Процедура <Имя метода>(ДанныеСтроки, ПараметрыЗагрузкиДанных) Экспорт
	|";
	
	КолонкиГрупп = "";	КолонкиСумм = ""; Кол = 0;
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаНомеровКолонок Цикл
		Кол = Кол + 1;
		Если СтрокаДанных.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			КолонкиСумм = КолонкиСумм + СтрокаДанных.Имя+",";
		Иначе
			КолонкиГрупп = КолонкиГрупп + СтрокаДанных.Имя+",";
		КонецЕсли;
	КонецЦикла;
	
	СтрокаПараметры = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаЗначения Цикл
		СтрокаПараметры = СтрокаПараметры + "
		|	Значение"+СтрокаДанных.Имя+" = ПараметрыЗагрузкиДанных.ЗначенияДанных."+СтрокаДанных.Имя+";";
	КонецЦикла;
	
	Текст = Текст + "
		|	// Фиксированные значения с закладки ""Параметры"". " +
		СтрокаПараметры + "
		|
		|	// ДанныеСтроки: список колонок.  
		|	// Не числовые: """ + Лев(КолонкиГрупп,СтрДлина(КолонкиГрупп)-1)+ """, 
		|	// Числовые: """ +Лев(КолонкиСумм,СтрДлина(КолонкиСумм)-1) + """;
		|
		|	// Признак отказа от дальнейшей загрузки данных. 
		|	// ПараметрыЗагрузкиДанных.Отказ = Истина;
		|";
		
	Текст = Текст +"
	|КонецПроцедуры
	|//  ЗАКОНЧИЛИ КОПИРОВАТЬ КОД... }}";
	
	АлгоритмТекст = АлгоритмТекст + Текст;
	
	АлгоритмТекст = АлгоритмТекст + "
		|";
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВызовОбработки(Команда)
	
	СтрокаОбработки = "";
	Для Каждого СтрокаДанных Из ВладелецФормы.ТаблицаВнешниеФайлы Цикл
		Если Прав(СтрокаДанных.Имя, 4) = ".epf" Тогда
			ОбработкаИмя = СтрЗаменить(СтрокаДанных.Имя, ".epf","");
			СтрокаОбработки = СтрокаОбработки + "
			|//ДанныеОбработки"+ОбработкаИмя+" = ТаблицаВнешниеФайлы.Найти("""+СтрокаДанных.Имя+""", ""Имя"").Данные;";		
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.АлгоритмИмя = "Алгоритм_ЗагрузкаДанныхСтроки" Тогда
		Текст = "
			|" + СтрокаОбработки + "
			|АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеОбработки);
			|ИмяОбработки 	 = ВнешниеОбработки.Подключить(АдресВоВременномХранилище,,Ложь);
			|ОбъектОбработка = ВнешниеОбработки.Создать(ИмяОбработки);
			|
			|ОбъектОбработка.<Имя метода>(ДанныеСтроки, ПараметрыЗагрузкиДанных);
			|";
	ИначеЕсли Параметры.АлгоритмИмя = "Алгоритм_ПослеЧтенияДанных" Тогда
		Текст = "
			|" + СтрокаОбработки + "
			|АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеОбработки);
			|ИмяОбработки 	 = ВнешниеОбработки.Подключить(АдресВоВременномХранилище,,Ложь);
			|ОбъектОбработка = ВнешниеОбработки.Создать(ИмяОбработки);
			|
			|ОбъектОбработка.<Имя метода>(ТаблицаДанныхExcel, ПараметрыЧтенияДанных);
			|";
	Иначе
		Текст = "
			|" + СтрокаОбработки + "
			|АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеОбработки);
			|ИмяОбработки 	 = ВнешниеОбработки.Подключить(АдресВоВременномХранилище,,Ложь);
			|ОбъектОбработка = ВнешниеОбработки.Создать(ИмяОбработки);
			|
			|ОбъектОбработка.<Имя метода>(ТаблицаДанныхExcel, ПараметрыЗагрузкиДанных, СтандартнаяОбработка);
			|";
	КонецЕсли;
	
	АлгоритмТекст = Текст + "
		|
		|" + АлгоритмТекст;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКодОтладки(Команда)
	
	Если Параметры.АлгоритмИмя = "Алгоритм_ПослеЧтенияДанных" Тогда
		
		АлгоритмТекст = "
		|// Создаем Команду-кнопку для отладки, переименовываем <Имя Команды> в название команды.
		|// Создаем реквизит формы ""ОтладкаТекст"": Строка(неогр).
		|// Выкладываем на форме у виде ""Текстовое поле"".
		|// В режиме предприятия копируем в реквизит текст, полученный командами ""Отладка (строка таблицы)"", ""Отладка (таблица)"".
		|
		|&НаСервере
		|Процедура <Имя Команды>НаСервере(ПараметрыЧтенияДанных)
		|
		|	ТабДок = Новый ТабличныйДокумент;
		|	ТабДок.ТолькоПросмотр = истина;
		|	ПараметрыЧтенияДанных.ОтчетыПослеЧтенияДанных.Вставить(""Отчет"", ТабДок);
		|
		|	ТекстДок = Новый ТекстовыйДокумент;
		|	ТекстДок.ТолькоПросмотр = Истина;
		|	ПараметрыЧтенияДанных.ОтчетыПослеЧтенияДанных.Вставить(""Отчет (текст)"", ТекстДок);
		|
		|	РеквизитФормыВЗначение(""Объект"").<Имя метода>(ДеСериализоватьОбъект(ОтладкаТекст), ПараметрыЧтенияДанных)
		|КонецПроцедуры
		|
		|&НаКлиенте
		|Процедура <Имя Команды>(Команда)
		|
		|	ПараметрыЧтенияДанных = Новый Структура;
		|	ПараметрыЧтенияДанных.Вставить(""ОтчетыПослеЧтенияДанных"", Новый Соответствие);
		|
		|	<Имя Команды>НаСервере(ПараметрыЧтенияДанных);
		|
		|	Для Каждого ТекОтчет Из ПараметрыЧтенияДанных.ОтчетыПослеЧтенияДанных Цикл
		|		Если ТипЗнч(ТекОтчет.Значение) = Тип(""ТабличныйДокумент"") И ТекОтчет.Значение.ВысотаТаблицы > 0 Тогда
		|			ТекОтчет.Значение.Показать(ТекОтчет.Ключ);
		|		ИначеЕсли ТипЗнч(ТекОтчет.Значение) = Тип(""ТекстовыйДокумент"") И ТекОтчет.Значение.КоличествоСтрок() > 0 Тогда
		|			ТекОтчет.Значение.Показать(ТекОтчет.Ключ);
		|		КонецЕсли;
		|	КонецЦикла;
		|
		|КонецПроцедуры
		|
		|&НаСервереБезКонтекста
		|Функция ДеСериализоватьОбъект(СтрокаXML) Экспорт
		|
		|	//Создаем объект чтения из XML
		|	ЧтениеXML = Новый ЧтениеXML;
		|	ЧтениеXML.УстановитьСтроку(СтрокаXML);
		|	//Читаем таблицу значений из XML    
		|	ОбъектТЗ = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		|
		|	Возврат ОбъектТЗ
		|КонецФункции ";
		
	Иначе
		
		АлгоритмТекст = "
		|// Создаем Команду-кнопку для отладки, переименовываем <Имя Команды> в название команды.
		|// Создаем реквизит формы ""ОтладкаТекст"": Строка(неогр).
		|// Выкладываем на форме у виде ""Текстовое поле"".
		|// В режиме предприятия копируем в реквизит текст, полученный командами ""Отладка (строка таблицы)"", ""Отладка (таблица)"".
		|
		|&НаСервере
		|Процедура <Имя Команды>НаСервере(ПараметрыЗагрузкиДанных)
		|
		|	ТабДок = Новый ТабличныйДокумент;
		|	ТабДок.ТолькоПросмотр = истина;
		|	ПараметрыЗагрузкиДанных.ОтчетыПоЗагрузке.Вставить(""Отчет по загрузке данных"", ТабДок);
		|
		|	ТекстДок = Новый ТекстовыйДокумент;
		|	ТекстДок.ТолькоПросмотр = Истина;
		|	ПараметрыЗагрузкиДанных.ОтчетыПоЗагрузке.Вставить(""Отчет по загрузке данных(текст)"", ТекстДок);
		|
		|	РеквизитФормыВЗначение(""Объект"").<Имя метода>(ДеСериализоватьОбъект(ОтладкаТекст), ПараметрыЗагрузкиДанных, Ложь)
		|КонецПроцедуры
		|
		|&НаКлиенте
		|Процедура <Имя Команды>(Команда)
		|
		|	ПараметрыЗагрузкиДанных = Новый Структура;
		|	ПараметрыЗагрузкиДанных.Вставить(""ОтчетыПоЗагрузке"", Новый Соответствие);
		|
		|	<Имя Команды>НаСервере(ПараметрыЗагрузкиДанных);
		|
		|	Для каждого ТекОтчет Из ПараметрыЗагрузкиДанных.ОтчетыПоЗагрузке Цикл
		|		Если ТипЗнч(ТекОтчет.Значение) = Тип(""ТабличныйДокумент"") И ТекОтчет.Значение.ВысотаТаблицы > 0 Тогда
		|			ТекОтчет.Значение.Показать(ТекОтчет.Ключ);
		|		ИначеЕсли ТипЗнч(ТекОтчет.Значение) = Тип(""ТекстовыйДокумент"") И ТекОтчет.Значение.КоличествоСтрок() > 0 Тогда
		|			ТекОтчет.Значение.Показать(ТекОтчет.Ключ);
		|		КонецЕсли;
		|	КонецЦикла;
		|
		|КонецПроцедуры
		|
		|&НаСервереБезКонтекста
		|Функция ДеСериализоватьОбъект(СтрокаXML) Экспорт
		|
		|	//Создаем объект чтения из XML
		|	ЧтениеXML = Новый ЧтениеXML;
		|	ЧтениеXML.УстановитьСтроку(СтрокаXML);
		|	//Читаем таблицу значений из XML    
		|	ОбъектТЗ = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		|
		|	Возврат ОбъектТЗ
		|КонецФункции ";
	
	КонецЕсли;
	
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	ВладелецФормы[Параметры.АлгоритмИмя] = АлгоритмТекст;
	ВладелецФормы.ОбновитьКолАлгоритмов();
	ВладелецФормы.Модифицированность = Истина;
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Код был изменен, закрыть редактор?';"
		    + " en = 'Do you want to continue?'"), РежимДиалогаВопрос.ДаНет, 0);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ФормаДобавитьОбработкуКолонок.Видимость = Ложь;
	Элементы.ФормаДобавитьВызовОбработки.Видимость = Ложь;
	Элементы.ФормаДобавитьБуферКода.Видимость = Ложь;
	
	Если Параметры.АлгоритмИмя = "Алгоритм_ПоискДанныхСтроки" Тогда
		
		ПодсказкаТекст = "
				|ДанныеСтроки 	 - Загружаемая строка данных (СтрокаТаблицыЗначений)
				|ТекРеквизит  - Имя реквизита (Строка)
				|ТекТип       - Тип реквизита (ОписаниеТипов)
				|ТекКолонкаЗначение       - Значение реквизита (строкой)
				|ТекОтказ 	 - Отказ от загрузки строки	(Булево)
				|ЗначенияДанных  - Фиксированные значения с закладки ""Параметры"" (Структура).
				|					 Обращаться ""Значение1 = ЗначенияДанных.<Имя>"".
				|ДанныеСтроки.__ИмяЛиста__ - Содержит имя листа excel
				|ТекКолонкаЗначениеЗапись - !!! Значение реквизита ДЛЯ ЗАПИСИ
				|							(преобразованное из строки в ТекТип)
				|	Примеры поиска данных:
				|	ТекКолонкаЗначениеЗапись = Справочники.Номенклатура.НайтиПоКоду(СокрЛП(ДанныеСтроки.Код));
				|	ТекКолонкаЗначениеЗапись = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(ДанныеСтроки.Наименование), Истина);
				|	ТекКолонкаЗначениеЗапись = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ТекКолонкаЗначение));
				|
				|Прочие функции:
				|
				|ДатаИзСтроки(ДатаСтрокой) - Возвращаемый тип ""Дата""
				|ЧислоИзСтроки(ЧислоСтрокой) - Возвращаемый тип ""Число""
				|УдалитьПробелыСтроки(Строка) - Возвращаемый тип ""Строка""
				|ЭтоПустаяСтрока(МассивЯчеек) - Возвращаемый тип ""Булево""
				|ИмяПоПредставлению(Представление) - Возвращаемый тип ""Строка"". Преобразует ""мама мыла раму"" в ""МамаМылаРаму"".
				|ЭтоЦифра(Символ) - Возвращаемый тип ""Булево""
				|ЭтоБуква(Символ) - Возвращаемый тип ""Булево""
				|
				|Прочие параметры:
				|
				|ПараметрыПолученияДанных.УникальныйИдентификатор - УникальныйИдентификатор формы обработки
				|		(на случай помещения данных во временное хранилище)
				|";
		Элементы.ФормаДобавитьОбработкуКолонок.Видимость = Истина;
		
	ИначеЕсли Параметры.АлгоритмИмя = "Алгоритм_ПослеЧтенияДанных" Тогда
		
		ПодсказкаТекст = "
				|//ТаблицаДанныхExcel  - Полученная таблица данных (ТаблицаЗначений)
				|
				|Прочие параметры:
				|
				|ПараметрыЧтенияДанных.УникальныйИдентификатор - УникальныйИдентификатор формы обработки
				|		(на случай помещения данных во временное хранилище)
				|";
		Элементы.ФормаДобавитьОбработкуКолонок.Видимость = Истина;
		Элементы.ФормаДобавитьВызовОбработки.Видимость = Истина;
		
	ИначеЕсли Параметры.АлгоритмИмя = "Алгоритм_ЗагрузкаДанныхСтроки" Тогда
		
		ПодсказкаТекст = "
				|//ДанныеСтроки 	 - Загружаемая строка данных (СтрокаТаблицыЗначений)
				|//ТаблицаДанныхExcel  - Загружаемая таблица данных (ТаблицаЗначений) 
				|//УникальныйИдентификатор - УникальныйИдентификатор формы обработки (УникальныйИдентификатор)
				|";
		Элементы.ФормаДобавитьВызовОбработки.Видимость = Истина;
		Элементы.ФормаДобавитьБуферКода.Видимость = Истина;
		
	Иначе
		
		ПодсказкаТекст = "
				|//ТаблицаДанныхExcel  - Загружаемая таблица данных (ТаблицаЗначений)
				|//УникальныйИдентификатор - УникальныйИдентификатор формы обработки (УникальныйИдентификатор)
				|";
		Элементы.ФормаДобавитьВызовОбработки.Видимость = Истина;
		Элементы.ФормаДобавитьБуферКода.Видимость = Истина;
		
	КонецЕсли;
	
	АлгоритмТекст = ВладелецФормы[Параметры.АлгоритмИмя];
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	КлючНастроек = ВладелецФормы.КлючНастроекАлгоритма(Параметры.АлгоритмИмя);
	
	Режим  = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = КлючНастроек;
	Фильтр = "Файл TXT(*.txt)|*.txt";
	ДиалогОткрытияФайла.Фильтр             = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок          = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ТекстФ = Новый ТекстовыйДокумент;
		ТекстФ.УстановитьТекст(АлгоритмТекст);
		ТекстФ.Записать(ДиалогОткрытияФайла.ПолноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	КлючНастроек = ВладелецФормы.КлючНастроекАлгоритма(Параметры.АлгоритмИмя);
	
	Режим  = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = КлючНастроек;
	Фильтр = "Файл TXT(*.txt)|*.txt";
	ДиалогОткрытияФайла.Фильтр             = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок          = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ТекстФ = Новый ТекстовыйДокумент;
		ТекстФ.Прочитать(ДиалогОткрытияФайла.ПолноеИмяФайла);
		АлгоритмТекст = ТекстФ.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

