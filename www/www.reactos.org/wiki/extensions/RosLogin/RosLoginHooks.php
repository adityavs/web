<?php
/*
 * PROJECT:     RosLogin - A simple Self-Service and Single-Sign-On around an LDAP user directory
 * LICENSE:     AGPL-3.0-or-later (https://spdx.org/licenses/AGPL-3.0-or-later)
 * PURPOSE:     Hooks for MediaWiki
 * COPYRIGHT:   Copyright 2018 Colin Finck (colin@reactos.org)
 */

	class RosLoginHooks
	{
		public static function onSpecialPage_initList(&$specialPages) {
			$specialPages['Userlogin'] = "SpecialRosLogin";
			return true;
		}

		public static function onUserLogout(&$user) {
			global $wgOut;
			$redirect = array_key_exists("returnto", $_GET) ? "/wiki/index.php?title=" . $_GET["returnto"] : "/wiki";
			$wgOut->redirect("/roslogin/?a=logout&redirect=" . rawurlencode($redirect));
			return true;
		}
	}
