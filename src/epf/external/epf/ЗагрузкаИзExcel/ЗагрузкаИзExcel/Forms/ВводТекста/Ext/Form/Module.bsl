﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Действие = "ТаблицаДанныхExcelЗагрузитьИзТекста" Тогда
		Элементы.ФормаОбработкаДанных.Заголовок = "Загрузить ТЗ из текста";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаДанных(Команда)
	
	Если Параметры.Действие = "ТаблицаДанныхExcelЗагрузитьИзТекста" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаДанныхОбработка", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, "Загрузить данные ТЗ из текста?",РежимДиалогаВопрос.ОКОтмена, 60);
	Иначе
		Закрыть()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаДанныхОбработка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Закрыть(ПолеТекст)
	КонецЕсли;
	
КонецПроцедуры
