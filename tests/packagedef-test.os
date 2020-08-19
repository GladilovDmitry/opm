﻿#Использовать asserts
#Использовать "../src/core"

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ЗадатьОсновныеМетаданные");
	СписокТестов.Добавить("ТестДолжен_ЗадатьЗависимостьБезВерсий");
	СписокТестов.Добавить("ТестДолжен_ЗадатьЗависимостьОтВерсии");
	СписокТестов.Добавить("ТестДолжен_ЗадатьЗависимостьОтВерсииНоНеБольшеДругой");
	СписокТестов.Добавить("ТестДолжен_ЗадатьСпецификациюМодуля");
	СписокТестов.Добавить("ТестДолжен_ЗадатьСпецификациюМодуляПовторно");
	СписокТестов.Добавить("ТестДолжен_ЗадатьСпецификациюКласса");
	СписокТестов.Добавить("ТестДолжен_ЗадатьСпецификациюКлассаПовторно");
	СписокТестов.Добавить("ТестДолжен_ЗадатьСпецификациюПриложения");
	
	Возврат СписокТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
КонецПроцедуры

Функция СоздатьОпределениеПакета()
	
	Пакет = Новый ОписаниеПакета();
	Пакет.Имя("имя").Версия("1.0");
	Возврат Пакет;
	
КонецФункции

Функция ТестДолжен_ЗадатьОсновныеМетаданные() Экспорт
	
	Описание = СоздатьОпределениеПакета();
	
	Описание.Имя("ТестовыйПакет")
			.Автор("Я")
			.Версия("1.0.5")
			.ВерсияСреды("1.0")
			.ВерсияМанифеста("1.0")
			.Описание("Это пакет для тестирования")
			.АдресАвтора("mail@server.com")
			;
	
	Свойства = Описание.Свойства();
	
	Ожидаем.Что(Свойства.Имя).Равно("ТестовыйПакет");
	Ожидаем.Что(Свойства.Автор).Равно("Я");
	Ожидаем.Что(Свойства.Версия).Равно("1.0.5");
	Ожидаем.Что(Свойства.ВерсияСреды).Равно("1.0");
	Ожидаем.Что(Свойства.ВерсияМанифеста).Равно("1.0");
	Ожидаем.Что(Свойства.Описание).Равно("Это пакет для тестирования");
	Ожидаем.Что(Свойства.АдресАвтора).Равно("mail@server.com");
		
КонецФункции

Функция ТестДолжен_ЗадатьЗависимостьБезВерсий() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ЗависитОт("asserts")
		 .ЗависитОт("cmdline");
		 
	Ожидаем.Что(Пакет.Зависимость("asserts")).Заполнено();
	Ожидаем.Что(Пакет.Зависимость("cmdline")).Заполнено();
	
КонецФункции

Функция ТестДолжен_ЗадатьЗависимостьОтВерсии() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ЗависитОт("asserts", "1.0")
		 .ЗависитОт("cmdline",">=2.1");
		 
	Ожидаем.Что(Пакет.Зависимость("asserts")).Заполнено();
	Ожидаем.Что(Пакет.Зависимость("cmdline")).Заполнено();
	Ожидаем.Что(Пакет.Зависимость("asserts").МинимальнаяВерсия).Равно("1.0");
	Ожидаем.Что(Пакет.Зависимость("cmdline").МинимальнаяВерсия).Равно(">=2.1");
	
КонецФункции

Функция ТестДолжен_ЗадатьЗависимостьОтВерсииНоНеБольшеДругой() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ЗависитОт("cmdline",">=2.1","<3.0");
		 
	Ожидаем.Что(Пакет.Зависимость("cmdline")).Заполнено();
	Ожидаем.Что(Пакет.Зависимость("cmdline").МинимальнаяВерсия).Равно(">=2.1");
	Ожидаем.Что(Пакет.Зависимость("cmdline").МаксимальнаяВерсия).Равно("<3.0");
	
КонецФункции

Процедура ТестДолжен_ЗадатьСпецификациюМодуля() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ОпределяетМодуль("СуперДелательХорошо", "src/goodmaker.os");
	Пакет.ОпределяетМодуль("СуперДелательХорошо2", "src/goodmaker2.os");
	
	Классы = Пакет.Модули();
	
	Ожидаем.Что(Классы).ИмеетДлину(2);
	Ожидаем.Что(Классы[0].Идентификатор).Равно("СуперДелательХорошо");
	Ожидаем.Что(Классы[0].Тип).Равно("Модуль");
	Ожидаем.Что(Классы[0].Файл).Равно("src/goodmaker.os");
	
	Ожидаем.Что(Классы[1].Идентификатор).Равно("СуперДелательХорошо2");
	Ожидаем.Что(Классы[1].Тип).Равно("Модуль");
	Ожидаем.Что(Классы[1].Файл).Равно("src/goodmaker2.os");
	
КонецПроцедуры

Процедура ТестДолжен_ЗадатьСпецификациюМодуляПовторно() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ОпределяетМодуль("СуперДелательХорошо", "src/goodmaker.os");
	Попытка
		Пакет.ОпределяетМодуль("СуперДелательХорошо", "src/goodmaker2.os");
	Исключение
		Если ИнформацияОбОшибке().Описание = "Уже определен модуль с именем СуперДелательХорошо" Тогда
			Возврат;
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;

	юТест.ПрерватьТест("Ожидали что будет выброшено исключение");
	
КонецПроцедуры

Процедура ТестДолжен_ЗадатьСпецификациюКласса() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ОпределяетКласс("СуперДелательХорошо", "src/goodmaker.os");
	Пакет.ОпределяетКласс("СуперДелательХорошо2", "src/goodmaker2.os");
	
	Классы = Пакет.Классы();
	
	Ожидаем.Что(Классы).ИмеетДлину(2);
	Ожидаем.Что(Классы[0].Идентификатор).Равно("СуперДелательХорошо");
	Ожидаем.Что(Классы[0].Тип).Равно("Класс");
	Ожидаем.Что(Классы[0].Файл).Равно("src/goodmaker.os");
	
	Ожидаем.Что(Классы[1].Идентификатор).Равно("СуперДелательХорошо2");
	Ожидаем.Что(Классы[1].Тип).Равно("Класс");
	Ожидаем.Что(Классы[1].Файл).Равно("src/goodmaker2.os");
	
КонецПроцедуры

Процедура ТестДолжен_ЗадатьСпецификациюКлассаПовторно() Экспорт
	
	Пакет = СоздатьОпределениеПакета();
	
	Пакет.ОпределяетКласс("СуперДелательХорошо", "src/goodmaker.os");
	Попытка
		Пакет.ОпределяетКласс("СуперДелательХорошо", "src/goodmaker2.os");
	Исключение
		Если ИнформацияОбОшибке().Описание = "Уже определен класс с именем СуперДелательХорошо" Тогда
			Возврат;
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	юТест.ПрерватьТест("Ожидали что будет выброшено исключение");
КонецПроцедуры

Процедура ТестДолжен_ЗадатьСпецификациюПриложения() Экспорт
	Пакет = СоздатьОпределениеПакета();
	Пакет.ИсполняемыйФайл("src/main.os");
	
	Утверждения.ПроверитьРавенство("src/main.os", Пакет.ИсполняемыеФайлы()[0].Путь);
	
КонецПроцедуры
