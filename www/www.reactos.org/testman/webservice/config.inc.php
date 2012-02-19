<?php
/*
  PROJECT:    ReactOS Web Test Manager
  LICENSE:    GNU GPLv2 or any later version as published by the Free Software Foundation
  PURPOSE:    Configuration settings for the Web Service
  COPYRIGHT:  Copyright 2008-2009 Colin Finck <colin@reactos.org>
*/

	define("TESTMAN_PATH", "../");
	
	//if you want to change this, change it also in testman's config
	define("BLACKLIST_URL", "http://svn.reactos.org/web/trunk/www/www.reactos.org/testman/blacklist.txt");
	
	// Ensure we don't get bloated logs or even exceed PHP's memory limit
	// by defining a maximum amount of memory, which may be allocated by the
	// aggregator script
	// NOTE: The aggregator script allocates memory per test result, so this
	// has no effect on the total log size
	define("MAX_MEMORY", 4000000);
?>