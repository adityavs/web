<?php
/*
  PROJECT:    ReactOS Shared Website Components
  LICENSE:    GNU GPLv2 or any later version as published by the Free Software Foundation
  PURPOSE:    Language handling for subsystems
  COPYRIGHT:  Copyright 2008-2009 Colin Finck <colin@reactos.org>
*/

	/*
	 * This will return the last two components of the server name, with a leading
	 * dot (i.e. usually .reactos.com or .reactos.org for us). See the PHP docs
	 * on setcookie() why we need the leading dot.
	 */
	function cookie_domain()
	{
		/* Server name might be just an IP address */
		if(preg_match("#[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}#", $_SERVER["SERVER_NAME"]))
			return $_SERVER["SERVER_NAME"];
		
		/* If it' a DNS address, return the domain name along with the suffix */
		if(preg_match("#(\.[^.]+\.[^.]+$)#", $_SERVER["SERVER_NAME"], $matches))
			return $matches[1];
		
		/* Otherwise return nothing */
		return "";
	}

	function GetLanguage()
	{
		global $lang;
		global $supported_languages;
		
		// Get the language and include it
		if(isset($_GET["lang"]))
			$lang = $_GET["lang"];
		else if(isset($_COOKIE["roscms_usrset_lang"]))
			$lang = $_COOKIE["roscms_usrset_lang"];
		
		// Check if the language is valid
		$lang_valid = false;
		
		foreach($supported_languages as $lang_key => $lang_name)
		{
			if($lang == $lang_key)
			{
				$lang_valid = true;
				break;
			}
		}
		
		if(!$lang_valid)
			$lang = "en";
		
		// Set a cookie for one year
		setcookie("roscms_usrset_lang", $lang, time() + 31536000, "/", cookie_domain());
	}
	
	function AdvertisementBox($lang)
	{
		readfile(ROOT_PATH . "$lang/subsys_extern_ad_adzone_left.html");
	}
	
	function BasicLayout($lang)
	{
		readfile(ROOT_PATH . "$lang/subsys_extern_menu_top.html");
		readfile(ROOT_PATH . "$lang/subsys_extern_menu_left.html");
	}
	
	function LanguageBox($lang)
	{
		global $shared_langres;
		global $supported_languages;
		
		printf('<div class="navTitle">%s</div>', $shared_langres["language"]);
		echo   '<ol>';
		echo   '<li style="text-align: center;">';
		printf('<select size="1" onchange="window.location.href = \'http://%s?lang=\' + this.options[this.selectedIndex].value;">', $_SERVER["SERVER_NAME"] . $_SERVER["PHP_SELF"]);
		
		foreach($supported_languages as $lang_key => $lang_name)
			printf('<option value="%s"%s>%s</option>', $lang_key, ($lang_key == $lang ? ' selected="selected"' : ''), $lang_name);
		
		echo '</select></li></ol>';
	}
?>
