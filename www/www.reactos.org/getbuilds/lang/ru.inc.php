<?php
/*
  PROJECT:    ReactOS Website
  LICENSE:    GNU GPLv2 or any later version as published by the Free Software Foundation
  PURPOSE:    Easily download prebuilt ReactOS Revisions
  COPYRIGHT:  Copyright 2007-2009 Colin Finck <mail@colinfinck.de>
  TRANSLATOR: Shashkov Maxim <bz00mmer@mail.ru>, Aleksey Bragin <aleksey@reactos.org>
  
  charset=utf-8 without BOM
*/

	$getbuilds_langres["header"] = '<a href="http://www.reactos.org/">Главная</a> &gt; Сборки транка SVN ReactOS';
	$getbuilds_langres["title"] = "Скачать сборки транка ReactOS";
	$getbuilds_langres["intro"] = 'Здесь Вы можете скачать как свежие, так и старые версии ReactOS для разработчиков, которые создаются нашим <a href="http://www.reactos.org/wiki/index.php/RosBuild">BuildBot</a>.';
	
	$getbuilds_langres["overview"] = "Обзор";
	$getbuilds_langres["latestrev"] = "Последняя ревизия ReactOS на SVN-сервере";
	$getbuilds_langres["browsesvn"] = "Обзор репозитория SVN";
	$getbuilds_langres["buildbot_status"] = "Статус BuildBot";
	$getbuilds_langres["buildbot_web"] = "Смотреть подробности через веб-интерфейс BuildBot";
	$getbuilds_langres["browsebuilds"] = "Обзор всех созданных сборок";
	
	$getbuilds_langres["downloadrev"] = "Скачать собранную ревизию ReactOS";
	$getbuilds_langres["js_disclaimer"] = 'Вам необходимо включить поддержку JavaScript в броузере для использования списка файлов ревизий.<br>Также, Вы можете скачать все собранные ревизии <a href="%s">здесь</a>.';
	$getbuilds_langres["showrevfiles"] = "Показать файлы ревизии";
	$getbuilds_langres["prevrev"] = "Предыдущая ревизия";
	$getbuilds_langres["nextrev"] = "Следующая ревизия";
	$getbuilds_langres["showrev"] = "Показать";
	$getbuilds_langres["gettinglist"] = "Получение списка файлов";
	$getbuilds_langres["isotype"] = "Показать типы образов CD-дисков";
	
	$getbuilds_langres["foundfiles"] = "Найдено файлов - %s!";
	
	$getbuilds_langres["filename"] = "Имя файла";
	$getbuilds_langres["filesize"] = "Размер";
	$getbuilds_langres["filedate"] = "Последнее изменение";
	
	$getbuilds_langres["nofiles"] 	 = "Собранных файлов для ревизии %s не существует! Самые последние файлы доступны для ревизии " . $rev;
	$getbuilds_langres["invalidrev"] = "Неправильный номер ревизии!";
	
	$getbuilds_langres["rangelimitexceeded"] = "Диапазон номеров ревизий не должен превышать %s!";
	
	$getbuilds_langres["legend"]= "Обозначения";
	$getbuilds_langres["build_bootcd"] = "<tt>bootcd</tt> - Образы BootCD ISO предназначены для установки новейших версий ReactOS на жёсткий диск. ISO-образ нужен только для процесса установки. Установка с помощью этого типа образа является рекомендуемой для тестирования ReactOS в виртуальной машине (VirtualBox, VMWare, QEMU).";
	$getbuilds_langres["build_livecd"] = "<tt>livecd</tt> - Образы LiveCD ISO позволяет использовать ReactOS без необходимости его установки. Также можно использовать LiveCD, если Ваш жёсткий диск не определяется во время установки с помощью BootCD или у Вас нет свободного ПК или виртуальной машины для установки ReactOS.";
	$getbuilds_langres["build_rel"] = "<tt>-rel</tt> - Release-версия без отладочной информации. Она меньше по размеру, но с её помощью нельзя получать отладочную информацию. (Спасибо, Кэп!)";
	$getbuilds_langres["build_dbg"] = "<tt>-dbg</tt> - Debug-версия включает отладочную информацию, и используя эту версию можно тестировать ReactOS, получать дебаг-логи, создавать описания найденных ошибок. Это рекомендуемый вариант для установки, особенно для тех, кто хочет сообщить о найденных проблемах с системой.";
	$getbuilds_langres["build_dbgwin"] = "<tt>-dbgwin</tt> - Тоже, что и -dbg версия + включает компонент wine Gecko и систему тестирования winetests. ";
	$getbuilds_langres["build_msvc"] = "<strong>-msvc</strong> - Debug version includes debugging information and PDB files, use this version to debug with Windbg.";
?>