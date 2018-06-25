Перем Лог;

Перем Имя;
Перем Сервер;
Перем ПутьНаСервере;
Перем Порт;
Перем Приоритет;
Перем Соединение;

Перем ПакетыХаба;

Процедура ПриСозданииОбъекта(Знач ИмяСервера, Знач АдресСервер, Знач ВходящийПутьНаСервере = "", Знач ВходящийПорт = 80, Знач ВходящийПриоритет = 0 )
	
	Имя = ИмяСервера;
	Сервер = АдресСервер;
	ПутьНаСервере = ВходящийПутьНаСервере;
	Порт = ВходящийПорт;
	Приоритет = ВходящийПриоритет;

КонецПроцедуры

Функция ПолучитьИмя() Экспорт
	Возврат Имя;
КонецФункции

Функция СерверДоступен() Экспорт
	Возврат Не Соединение = Неопределено;
КонецФункции

Функция ИнициализироватьСоединение()

	Если Не Соединение = Неопределено Тогда
		Возврат Соединение;
	КонецЕсли;
	
	Порт = ?(Порт = Неопределено, 80, Порт);
	Настройки = НастройкиOpm.ПолучитьНастройки();
	Если Настройки.ИспользоватьПрокси Тогда
		Соединение = Новый HTTPСоединение(Сервер, Порт,,, НастройкиOpm.ПолучитьИнтернетПрокси());
	Иначе
		Соединение = Новый HTTPСоединение(Сервер, Порт);
	КонецЕсли;
	
	Возврат Соединение;
	
КонецФункции

// ИмяРесурса - имя файла относительно "Сервер/ПутьВХранилище"
// Возвращает HttpОтвет или Неопределено, если запрос вернул исключение.
Функция ПолучитьРесурс(Знач ИмяРесурса) Экспорт

	Соединение = ИнициализироватьСоединение();
	Ресурс = ПутьНаСервере + ИмяРесурса;
	Запрос = Новый HTTPЗапрос(Ресурс);

	Попытка
		
		Возврат Соединение.Получить(Запрос);

	Исключение

		Возврат Неопределено;

	КонецПопытки;

КонецФункции

Функция ПрочитатьФайлСпискаПакетов(Текст)
	
	ТекстовыйДокумент  = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	КоличествоПакетовВХабе = ТекстовыйДокумент.КоличествоСтрок();
	Для НомерСтроки = 1 По КоличествоПакетовВХабе Цикл
		ИмяПакета = СокрЛП(ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки));
		
		Если ПустаяСтрока(ИмяПакета) Тогда
			Продолжить;
		КонецЕсли;

		Если ПакетыХаба[ИмяПакета] = Неопределено Тогда
			ПакетыХаба.Вставить(ИмяПакета, Новый Массив);
		КонецЕсли;
		ПакетыХаба[ИмяПакета] = ""; // Тут должна быть строка версий
	КонецЦикла;

КонецФункции

Функция ПолучитьСписокПакетов(Ресурс)

	Ответ = ПолучитьРесурс(Ресурс);
	
	Если Ответ = Неопределено Или Ответ.КодСостояния <> 200 Тогда
		ТекстИсключения = СтрШаблон("Ошибка подключения к зеркалу ");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	Ответ.Закрыть();

	Возврат ТекстОтвета;

КонецФункции

Функция ПолучитьПакеты() Экспорт

	ПакетыХаба = Новый Соответствие;

	ТекстОтвета = "";

	Попытка
		ТекстОтвета = ПолучитьСписокПакетов("list.txt");
	Исключение
		Лог.Предупреждение(
			СтрШаблон("Ошибка получения списка пакетов с хаба %1 по причине %2", 
			Имя, ОписаниеОшибки()
			)
		);
	КонецПопытки;

	ПрочитатьФайлСпискаПакетов(ТекстОтвета);
	
	Возврат ПакетыХаба;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.app.opm");
