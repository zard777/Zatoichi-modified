name = "WAR! Update"
description = "There could be only one! Expand your favourite class's list of useful items with the WAR! Update!"
author = "<default>"
version = "1.22"
version_compatible = "1.22"
id = "tf2warupdate"

forumthread = "http://steamcommunity.com/sharedfiles/filedetails/?id=729593595"


api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"tf2", "teamfortress2", "war!", "war",
}

priority = -10

configuration_options =
{
	{
		name = "concherorrecipe",
		label = "Concheror Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "battalions_backup_recipe",
		label = "Battalion's Backup Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "ullapool_caberrecipe",
		label = "Ullapool Caber Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "equalizerrecipe",
		label = "Equalizer Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "stickybombrecipes",
		label = "Sticky/Quickiebomb Recipes:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "tf2bountyhatrecipe",
		label = "Bounty Hat Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "half_zatoichirecipe",
		label = "Half-Zatoichi Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "tf2samuraiarmorrecipe",
		label = "Bushi-Dou Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "tf2samuraihatrecipe",
		label = "Samur-Eye Recipe:",
		options =
		{
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true,
	},
	{
		name = "conchdmgreq",
		label = "Concheror Dmg Required:",
		options =
		{
			{description = "1000", data = 1000},
			{description = "1100", data = 1100},
			{description = "1200", data = 1200},
			{description = "1300", data = 1300},
			{description = "1400", data = 1400},
			{description = "1500", data = 1500},
			{description = "1600", data = 1600},
			{description = "1700", data = 1700},
			{description = "1800", data = 1800},
			{description = "1900", data = 1900},
			{description = "2000(Default)", data = 2000},
			{description = "2100", data = 2100},
			{description = "2200", data = 2200},
			{description = "2300", data = 2300},
			{description = "2400", data = 2400},
			{description = "2500", data = 2500},
			{description = "2600", data = 2600},
			{description = "2700", data = 2700},
			{description = "2800", data = 2800},
			{description = "2900", data = 2900},
			{description = "3000", data = 3000},
		},
		default = 2000,
	},
	{
		name = "conchduration",
		label = "Concheror Duration:",
		options =
		{
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60 Sec(Default)", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
		},
		default = 60,
	},
	{
		name = "conchregenperiod",
		label = "Concheror HP Regen Period:",
		options =
		{
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10 Sec(Default)", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
			{description = "16", data = 16},
			{description = "17", data = 17},
			{description = "18", data = 18},
			{description = "19", data = 19},
			{description = "20", data = 20},
		},
		default = 10,
	},
	{
		name = "conchregenamount",
		label = "Concheror Regen Per Tick:",
		options =
		{
			{description = "No regen", data = 0},
			{description = "1 HP(Default)", data = 1},
			{description = "2 HP", data = 2},
			{description = "3 HP", data = 3},
			{description = "4 HP", data = 4},
			{description = "5 HP", data = 5},
		},
		default = 1,
	},
	{
		name = "conchspdbonus",
		label = "Concheror Speed Bonus:",
		options =
		{
			{description = "No bonus", data = 10},
			{description = "+10%", data = 11},
			{description = "+20%", data = 12},
			{description = "+30%", data = 13},
			{description = "+40%", data = 14},
			{description = "+50%", data = 15},
			{description = "+60%(Default)", data = 16},
			{description = "+70%", data = 17},
			{description = "+80%", data = 18},
			{description = "+90%", data = 19},
			{description = "+100%", data = 20},
		},
		default = 16,
	},
	{
		name = "conchcombatheal",
		label = "Concheror Health On Attack:",
		options =
		{
			{description = "No bonus", data = 0},
			{description = "+3%", data = 0.03},
			{description = "+5%(Default)", data = 0.05},
			{description = "+10%", data = 0.1},
			{description = "+15%", data = 0.15},
			{description = "+20%", data = 0.2},
			{description = "+25%", data = 0.25},
		},
		default = 0.05,
	},
	
	{
		name = "batbackdmgreq",
		label = "Battalion's Backup Dmg Required:",
		options =
		{
			{description = "1000", data = 1000},
			{description = "1100", data = 1100},
			{description = "1200", data = 1200},
			{description = "1300", data = 1300},
			{description = "1400", data = 1400},
			{description = "1500", data = 1500},
			{description = "1600", data = 1600},
			{description = "1700", data = 1700},
			{description = "1800", data = 1800},
			{description = "1900", data = 1900},
			{description = "2000(Default)", data = 2000},
			{description = "2100", data = 2100},
			{description = "2200", data = 2200},
			{description = "2300", data = 2300},
			{description = "2400", data = 2400},
			{description = "2500", data = 2500},
			{description = "2600", data = 2600},
			{description = "2700", data = 2700},
			{description = "2800", data = 2800},
			{description = "2900", data = 2900},
			{description = "3000", data = 3000},
		},
		default = 2000,
	},
	{
		name = "batbackduration",
		label = "Battalion's Backup Duration:",
		options =
		{
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70 Sec(Default)", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
		},
		default = 70,
	},
	
	{
		name = "batbackdmgreduction",
		label = "Battalion's Backup Dmg Reduction:",
		options =
		{
			{description = "No reduction", data = 10},
			{description = "10%", data = 9},
			{description = "20%", data = 8},
			{description = "30%", data = 7},
			{description = "40%", data = 6},
			{description = "50%", data = 5},
			{description = "60%", data = 4},
			{description = "70%(Default)", data = 3},
			{description = "80%", data = 2},
			{description = "90%", data = 1},
		},
		default = 3,
	},
	
	-- WAR!
	{
		name = "quickielauncherreloadspd",
		label = "Quickie Launcher Reload:",
		options =
		{
			{description = "5 Sec(Default)", data = 5},
			{description = "10 Seconds", data = 10},
			{description = "15 Seconds", data = 15},
			{description = "20 Seconds", data = 20},
			{description = "25 Seconds", data = 25},
			{description = "30 Seconds", data = 30},
			{description = "35 Seconds", data = 35},
			{description = "40 Seconds", data = 40},
		},
		default = 5,
	},
	{
		name = "maxquickiesdeployed",
		label = "Max Quickiebombs Deployed:",
		options =
		{
			{description = "2", data = 2},
			{description = "4(Default)", data = 4},
			{description = "6", data = 6},
			{description = "8", data = 8},
			{description = "10", data = 10},
		},
		default = 4,
	},
	{
		name = "quickiebombdmg",
		label = "Quickiebomb Damage:",
		options =
		{
			{description = "17", data = 17},
			{description = "27.2", data = 27.2},
			{description = "34", data = 34},
			{description = "42.5", data = 42.5},
			{description = "51", data = 51},
			{description = "62(Default)", data = 62},
			{description = "68", data = 68},
			{description = "100", data = 100},
			{description = "200", data = 200},
		},
		default = 62,
	},
	{
		name = "quickiebombtime",
		label = "Quickiebomb Duration:",
		options =
		{
			{description = "5 sec", data = 5},
			{description = "6 sec(Default)", data = 6},
			{description = "7 sec", data = 7},
		},
		default = 6,
	},
	
	{
		name = "ullapoolcaberdmg",
		label = "Caber Damage (-25% Thrown):",
		options =
		{
			{description = "100", data = 100},
			{description = "110", data = 110},
			{description = "120", data = 120},
			{description = "130", data = 130},
			{description = "140", data = 140},
			{description = "150", data = 150},
			{description = "160", data = 160},
			{description = "170", data = 170},
			{description = "180", data = 180},
			{description = "190", data = 190},
			{description = "200(Default)", data = 200},
			{description = "210", data = 210},
			{description = "220", data = 220},
			{description = "230", data = 230},
			{description = "240", data = 240},
			{description = "250", data = 250},
			{description = "260", data = 260},
			{description = "270", data = 270},
			{description = "280", data = 280},
			{description = "290", data = 290},
			{description = "300", data = 300},
		},
		default = 200,
	},
	{
		name = "ullapoolcaberdist",
		label = "Caber Throw Distance:",
		options =
		{
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10(Default)", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
		},
		default = 10,
	},
	
	{
		name = "bountyhatchance",
		label = "Bounty Hat Bonus Loot Chance:",
		options =
		{
			{description = "1%", data = 10},
			{description = "3%", data = 30},
			{description = "5%(Default)", data = 50},
			{description = "10%", data = 100},
			{description = "15%", data = 150},
			{description = "20%", data = 200},
			{description = "25%", data = 250},
			{description = "30%", data = 300},
			{description = "35%", data = 350},
			{description = "40%", data = 400},
			{description = "45%", data = 450},
			{description = "50%", data = 500},
			{description = "55%", data = 550},
			{description = "60%", data = 600},
			{description = "65%", data = 650},
			{description = "70%", data = 700},
			{description = "75%", data = 750},
			{description = "100%", data = 1000},
		},
		default = 50,
	},
	
	{
		name = "equalizeruses",
		label = "Equalizer Uses:",
		options =
		{
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100(Default)", data = 100},
			{description = "110", data = 110},
			{description = "120", data = 120},
			{description = "130", data = 130},
			{description = "140", data = 140},
			{description = "150", data = 150},
		},
		default = 100,
	},
	{
		name = "equalizerconsumption",
		label = "Equalizer Mining Consumption:",
		options =
		{
			{description = "x0.5", data = 0.5},
			{description = "x1", data = 1},
			{description = "x1.5", data = 1.5},
			{description = "x2(Default)", data = 2},
			{description = "x2.5", data = 2.5},
			{description = "x3", data = 3},
		},
		default = 2,
	},
	{
		name = "equalizermindmg",
		label = "Equalizer Min Damage (Full HP):",
		options =
		{
			{description = "17", data = 17},
			{description = "27.2(Default)", data = 27.2},
			{description = "34", data = 34},
			{description = "42.5", data = 42.5},
			{description = "51", data = 51},
			{description = "62", data = 62},
			{description = "68", data = 68},
			{description = "100", data = 100},
			{description = "200", data = 200},
		},
		default = 27.2,
	},
	
	{
		name = "equalizermaxdmg",
		label = "Equalizer Max Damage (1 HP):",
		options =
		{
			{description = "17", data = 17},
			{description = "27.2", data = 27.2},
			{description = "34", data = 34},
			{description = "42.5", data = 42.5},
			{description = "51", data = 51},
			{description = "62", data = 62},
			{description = "68(Default)", data = 68},
			{description = "100", data = 100},
			{description = "200", data = 200},
		},
		default = 68,
	},
	
	{
		name = "equalizermaxspd",
		label = "Equalizer Max Speed (1 HP):",
		options =
		{
			{description = "+10%", data = 0.1},
			{description = "+20%", data = 0.2},
			{description = "+30%", data = 0.3},
			{description = "+40%(Default)", data = 0.4},
			{description = "+50%", data = 0.5},
			{description = "+60%", data = 0.6},
			{description = "+70%", data = 0.7},
			{description = "+80%", data = 0.8},
			{description = "+90%", data = 0.9},
			{description = "+100%", data = 1.0},
		},
		default = 0.4,
	},
	
	{
		name = "halfzatoichidmg",
		label = "Half-Zatoichi Damage:",
		options =
		{
			{description = "25", data = 25},
			{description = "37.5", data = 37.5},
			{description = "50", data = 50},
			{description = "72.5", data = 72.5},
			{description = "150(Default)", data = 150},
			{description = "285", data = 285},
			{description = "320", data = 320},
			{description = "444", data = 444},
			{description = "666", data = 666},
		},
		default = 150,
	},
	
	{
		name = "halfzatoichiuses",
		label = "Half-Zatoichi Uses:",
		options =
		{
			{description = "99", data = 99},
			{description = "140", data = 140},
			{description = "185", data = 185},
			{description = "220", data = 220},
			{description = "255(Default)", data = 255},
			{description = "333", data = 333},
			{description = "444", data = 444},
			{description = "777", data = 777},
			{description = "990", data = 990},
		},
		default = 255,
	},
	
	{
		name = "halfzatoichidrainmult",
		label = "Half-Zatoichi HP On Kill:",
		options =
		{
			{description = "5%", data = 0.05},
			{description = "10%(Default)", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "25%", data = 0.25},
			{description = "50%", data = 0.5},
			{description = "75%", data = 0.75},
			{description = "90%", data = 0.9},
			{description = "120%", data = 1.2},
			{description = "150%", data = 1.5},
			{description = "180%", data = 1.8},
		},
		default = 0.1,
	},
	
	{
		name = "tf2samarmordurability",
		label = "Bushi-Dou Durability:",
		options =
		{
			{description = "400", data = 400},
			{description = "450", data = 450},
			{description = "500", data = 500},
			{description = "550(Default)", data = 550},
			{description = "750", data = 750},
			{description = "990", data = 990},
			{description = "1550", data = 1550},
			{description = "3650", data = 3650},
			{description = "5550", data = 5550},
			{description = "6666", data = 6666},
			{description = "9990", data = 9990},
		},
		default = 550,
	},
	{
		name = "tf2samarmorresistance",
		label = "Bushi-Dou Resistance:",
		options =
		{
			{description = "50%", data = 0.5},
			{description = "55%", data = 0.55},
			{description = "60%", data = 0.6},
			{description = "65%", data = 0.65},
			{description = "70%(Default)", data = 0.7},
			{description = "75%", data = 0.75},
			{description = "80%", data = 0.8},
			{description = "85%", data = 0.85},
			{description = "90%", data = 0.9},
			{description = "95%", data = 0.95},
			{description = "100%", data = 1},
		},
		default = 0.7,
	},
	{
		name = "tf2samarmorspdbonus",
		label = "Bushi-Dou Speed Bonus:",
		options =
		{
			{description = "No bonus", data = 0},
			{description = "10%(Default)", data = 1.1},
			{description = "20%", data = 1.2},
			{description = "40%", data = 1.4},
			{description = "50%", data = 1.5},
			{description = "75%", data = 1.75},
			{description = "95%", data = 1.95},
		},
		default = 1.1,
	},
	
	{
		name = "tf2samhatdurability",
		label = "Samur-Eye Durability:",
		options =
		{
			{description = "400", data = 400},
			{description = "450", data = 450},
			{description = "500", data = 500},
			{description = "550(Default)", data = 550},
			{description = "750", data = 750},
			{description = "990", data = 990},
			{description = "1550", data = 1550},
			{description = "3650", data = 3650},
			{description = "5550", data = 5550},
			{description = "6666", data = 6666},
		},
		default = 550,
	},
	{
		name = "tf2samhatresistance",
		label = "Samur-Eye Resistance:",
		options =
		{
			{description = "50%", data = 0.5},
			{description = "55%", data = 0.55},
			{description = "60%", data = 0.6},
			{description = "65%", data = 0.65},
			{description = "70%(Default)", data = 0.7},
			{description = "75%", data = 0.75},
			{description = "80%", data = 0.8},
			{description = "85%", data = 0.85},
			{description = "90%", data = 0.9},
			{description = "95%", data = 0.95},
			{description = "100%", data = 1},
		},
		default = 0.7,
	},
	{
		name = "tf2samhatspdbonus",
		label = "Samur-Eye Speed Bonus:",
		options =
		{
			{description = "No bonus", data = 0},
			{description = "10%(Default)", data = 1.1},
			{description = "20%", data = 1.2},
			{description = "40%", data = 1.4},
			{description = "50%", data = 1.5},
			{description = "75%", data = 1.75},
			{description = "95%", data = 1.95},
			{description = "125%", data = 2.25},
			{description = "150%", data = 2.5},
			{description = "180%", data = 2.8},
			{description = "200%", data = 3.0},
			{description = "250%", data = 3.5},
			{description = "300%", data = 4.0},
			{description = "350%", data = 4.5},
		},
		default = 1.1,
	},
}
