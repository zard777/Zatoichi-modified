PrefabFiles = {
	"concherorfx",
	"concheror",
	"concheror_hp_fx",
	"quickiebomblauncher",
	"quickiebomb",
	"quickiebomb_crit",
	"quickiebomb_meter",
	"ullapool_caber",
	"tf2bountyhat",
	"equalizer",
	"equalizer_fx",
	"battalions_backup",
	"battalionsbackupfx",
	-- Testing:
	"half_zatoichi",
	"tf2samuraihat",
	"tf2samuraiarmor",
}

Assets = {
	Asset("ANIM", "anim/conch.zip"),
	Asset("ANIM", "anim/conch_pre.zip"),
	
	Asset("ANIM", "anim/swap_concheror_flag.zip"),
	
	Asset("ANIM", "anim/concherorfx.zip"),
	
	Asset("ANIM", "anim/battalions_horn.zip"),
	Asset("ANIM", "anim/battalions_horn_pre.zip"),
	
	Asset("ANIM", "anim/swap_battalions_backup_flag.zip"),
	
	Asset("ANIM", "anim/battalionsbackupfx.zip"),
	
	Asset("ANIM", "anim/tf2bountyhat.zip"),
    Asset("ANIM", "anim/tf2bountyhat_swap.zip"), 
	
	Asset("ATLAS", "images/inventoryimages/tf2bountyhat.xml"),
    Asset("IMAGE", "images/inventoryimages/tf2bountyhat.tex"),
	
	Asset("ATLAS", "images/inventoryimages/ullapool_caber.xml"),
    Asset("IMAGE", "images/inventoryimages/ullapool_caber.tex"),
	
	Asset("ATLAS", "images/inventoryimages/equalizer.xml"),
    Asset("IMAGE", "images/inventoryimages/equalizer.tex"),
	
	Asset("ATLAS", "images/inventoryimages/concheror.xml"),
    Asset("IMAGE", "images/inventoryimages/concheror.tex"),
	
	Asset("ATLAS", "images/inventoryimages/battalions_backup.xml"),
    Asset("IMAGE", "images/inventoryimages/battalions_backup.tex"),
	
	Asset( "IMAGE", "images/inventoryimages/quickiebomblauncher.tex" ),
    Asset( "ATLAS", "images/inventoryimages/quickiebomblauncher.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/quickiebomb.tex" ),
    Asset( "ATLAS", "images/inventoryimages/quickiebomb.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/half_zatoichi.tex" ),
    Asset( "ATLAS", "images/inventoryimages/half_zatoichi.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/tf2samuraiarmor.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tf2samuraiarmor.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/tf2samuraihat.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tf2samuraihat.xml" ),
	
	Asset("SOUNDPACKAGE", "sound/tf2warsounds.fev"),
	Asset("SOUND", "sound/tf2warsounds.fsb"),
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING

-- Variables related to stategraphs:
local State = GLOBAL.State
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local ACTIONS = GLOBAL.ACTIONS
local FRAMES = GLOBAL.FRAMES

RemapSoundEvent( "dontstarve/wilson/attack_zatoichi", "tf2warsounds/tf2warsounds/half_zatoichi_swing" )
RemapSoundEvent( "dontstarve/wilson/hit_zatoichi", "tf2warsounds/tf2warsounds/half_zatoichi_hit" )
RemapSoundEvent( "dontstarve/wilson/draw_zatoichi", "tf2warsounds/tf2warsounds/half_zatoichi_draw" )

modimport("libs/env.lua")
modimport("strings.lua")

TUNING.CONCHEROR_DAMAGE_REQUIRED = GetModConfigData("conchdmgreq")
TUNING.CONCHEROR_DURATION = GetModConfigData("conchduration")
TUNING.CONCHEROR_TIME = TUNING.CONCHEROR_DAMAGE_REQUIRED/TUNING.CONCHEROR_DURATION
TUNING.CONCHEROR_RANGE = 15
TUNING.CONCHEROR_REGEN_PERIOD = GetModConfigData("conchregenperiod")
TUNING.CONCHEROR_REGEN_AMOUNT = GetModConfigData("conchregenamount")
TUNING.CONCHEROR_SPEED = (GetModConfigData("conchspdbonus")*0.1)
TUNING.CONCHEROR_COMBAT_HEAL = GetModConfigData("conchcombatheal")

TUNING.BATTALIONS_BACKUP_DMG_REQUIRED = GetModConfigData("batbackdmgreq")
TUNING.BATTALIONS_BACKUP_RANGE = 15
TUNING.BATTALIONS_BACKUP_DURATION = GetModConfigData("batbackduration")
TUNING.BATTALIONS_BACKUP_TIME = TUNING.BATTALIONS_BACKUP_DMG_REQUIRED/TUNING.BATTALIONS_BACKUP_DURATION
TUNING.BATTALIONS_BACKUP_DMG_REDUCTION = (GetModConfigData("batbackdmgreduction")*0.1)

TUNING.QUCKIELNCHR_RLDSPD = GetModConfigData("quickielauncherreloadspd")
TUNING.QUCKIELNCHR_MAXSTICKIES = GetModConfigData("maxquickiesdeployed")
TUNING.QUCKIE_DAMAGE = GetModConfigData("quickiebombdmg")
TUNING.QUICKIE_LIFE_TIME = GetModConfigData("quickiebombtime")
TUNING.QUICKIE_METER_ANIMNAME = "meter"
if TUNING.QUICKIE_LIFE_TIME == 5 then
	TUNING.QUICKIE_METER_ANIMNAME = "meter_short"
elseif TUNING.QUICKIE_LIFE_TIME == 7 then
	TUNING.QUICKIE_METER_ANIMNAME = "meter_long"
end

TUNING.ULLAPOOL_CABER_DAMAGE = GetModConfigData("ullapoolcaberdmg")
TUNING.ULLAPOOL_CABER_DIST = GetModConfigData("ullapoolcaberdist")

TUNING.TF2BOUNTYHAT_CHANCE = (GetModConfigData("bountyhatchance")*0.001)

TUNING.EQUALIZER_MIN_DMG = GetModConfigData("equalizermindmg")
TUNING.EQUALIZER_MAX_DMG = GetModConfigData("equalizermaxdmg") - TUNING.EQUALIZER_MIN_DMG
TUNING.EQUALIZER_MAX_SPD = GetModConfigData("equalizermaxspd")
TUNING.EQUALIZER_USES = GetModConfigData("equalizeruses")
TUNING.EQUALIZER_CONSUMPTION = GetModConfigData("equalizerconsumption")

TUNING.HALF_ZATOICHI_DAMAGE = GetModConfigData("halfzatoichidmg")
TUNING.HALF_ZATOICHI_USES = GetModConfigData("halfzatoichiuses")
TUNING.HALF_ZATOICHI_DRAIN_MULT = GetModConfigData("halfzatoichidrainmult")

TUNING.TF2SAMURAIARMOR_DURABILITY = GetModConfigData("tf2samarmordurability")
TUNING.TF2SAMURAIARMOR_RESISTANCE = GetModConfigData("tf2samarmorresistance")
TUNING.TF2SAMURAIARMOR_SPEED_BONUS = GetModConfigData("tf2samarmorspdbonus")

TUNING.TF2SAMURAIHAT_DURABILITY = GetModConfigData("tf2samhatdurability")
TUNING.TF2SAMURAIHAT_RESISTANCE = GetModConfigData("tf2samhatresistance")
TUNING.TF2SAMURAIHAT_SPEED_BONUS = GetModConfigData("tf2samhatspdbonus")

if GetModConfigData("concherorrecipe") == true then
local concherorrecipe = AddRecipe("concheror", 
{Ingredient("boards", 3), Ingredient("papyrus", 2)},
RECIPETABS.WAR, 
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
"tf2soldier", 
"images/inventoryimages/concheror.xml", 
"concheror.tex")
concherorrecipe.sortkey = 0
end

if GetModConfigData("battalions_backup_recipe") == true then
local battalions_backup_recipe = AddRecipe("battalions_backup", 
{Ingredient("pigskin", 3), Ingredient("marble", 2)},
RECIPETABS.WAR, 
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
"tf2soldier", 
"images/inventoryimages/battalions_backup.xml", 
"battalions_backup.tex")
battalions_backup_recipe.sortkey = 0
end

if GetModConfigData("equalizerrecipe") == true then
local equalizerrecipe = AddRecipe("equalizer", 
{Ingredient("flint", 3), Ingredient("twigs", 3)},
RECIPETABS.TOOLS,
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
"tf2soldier", 
"images/inventoryimages/equalizer.xml", 
"equalizer.tex")
equalizerrecipe.sortkey = -1
end

if GetModConfigData("ullapool_caberrecipe") == true then
local ullapool_caberrecipe = AddRecipe("ullapool_caber", 
{Ingredient("gunpowder", 1), Ingredient("twigs", 4)},
RECIPETABS.WAR, 
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
"demoman", 
"images/inventoryimages/ullapool_caber.xml", 
"ullapool_caber.tex")
ullapool_caberrecipe.sortkey = -4
end

if GetModConfigData("tf2bountyhatrecipe") == true then
local tf2bountyhatrecipe = AddRecipe("tf2bountyhat", 
{Ingredient("boards", 3), Ingredient("goldnugget", 6), Ingredient("gunpowder", 2),},
RECIPETABS.DRESS, 
TECH.NONE, 
nil, 
nil, 
nil, 
nil, 
"demoman", 
"images/inventoryimages/tf2bountyhat.xml", 
"tf2bountyhat.tex")
tf2bountyhatrecipe.sortkey = 0
end

if GetModConfigData("half_zatoichirecipe") == true then
local half_zatoichirecipe = AddRecipe("half_zatoichi", 
{Ingredient(CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("flint", 4), Ingredient("twigs", 2)},
RECIPETABS.WAR, 
TECH.SCIENCE_ONE, 
nil, 
nil, 
nil, 
nil, 
"demoman", 
"images/inventoryimages/half_zatoichi.xml", 
"half_zatoichi.tex")
half_zatoichirecipe.sortkey = -2
end

if GetModConfigData("tf2samuraiarmorrecipe") == true then
local tf2samuraiarmorrecipe = AddRecipe("tf2samuraiarmor", 
{Ingredient(CHARACTER_INGREDIENT.HEALTH, 5), Ingredient("charcoal", 10), Ingredient("rope", 2)},
RECIPETABS.WAR, 
TECH.SCIENCE_ONE, 
nil, 
nil, 
nil, 
nil, 
"demoman", 
"images/inventoryimages/tf2samuraiarmor.xml", 
"tf2samuraiarmor.tex")
tf2samuraiarmorrecipe.sortkey = -1
end

if GetModConfigData("tf2samuraihatrecipe") == true then
local tf2samuraihatrecipe = AddRecipe("tf2samuraihat", 
{Ingredient(CHARACTER_INGREDIENT.HEALTH, 10), Ingredient("charcoal", 8), Ingredient("rope", 1)},
RECIPETABS.WAR, 
TECH.SCIENCE_ONE, 
nil, 
nil, 
nil, 
nil, 
"demoman", 
"images/inventoryimages/tf2samuraihat.xml", 
"tf2samuraihat.tex")
tf2samuraihatrecipe.sortkey = 0
end

for k,v in pairs(GLOBAL.ModManager.mods) do
	if v.modinfo and v.modinfo.name == "Demoman" then
		if GetModConfigData("stickybombrecipes") == true then
		
		local stickybomblauncher = Ingredient( "stickybomblauncher", 1)
		stickybomblauncher.atlas = "images/inventoryimages/stickybomblauncher.xml"

		local quickiebomblauncher = Ingredient( "quickiebomblauncher", 1)
		quickiebomblauncher.atlas = "images/inventoryimages/quickiebomblauncher.xml"
	
		stickybomblauncherrecipe = AddRecipe("stickybomblauncher", 
			{quickiebomblauncher, Ingredient("gears", 1)},
			RECIPETABS.WAR, 
			TECH.NONE, 
			nil, 
			nil, 
			nil, 
			nil, 
			"demoman", 
			"images/inventoryimages/stickybomblauncher.xml", 
			"stickybomblauncher.tex")
		stickybomblauncherrecipe.sortkey = -6

		quickiebomblauncherrecipe = AddRecipe("quickiebomblauncher", 
			{stickybomblauncher, Ingredient("gears", 1)},
			RECIPETABS.WAR, 
			TECH.NONE, 
			nil, 
			nil, 
			nil, 
			nil, 
			"demoman", 
			"images/inventoryimages/quickiebomblauncher.xml", 
			"quickiebomblauncher.tex")
		quickiebomblauncherrecipe.sortkey = -5 
		
		end
	end
end

-- CONTAINERS:
local containers = GLOBAL.require("containers")
local oldwidgetsetup = containers.widgetsetup
_G=GLOBAL
mods=_G.rawget(_G,"mods")or(function()local m={}_G.rawset(_G,"mods",m)return m end)()
mods.old_widgetsetup = mods.old_widgetsetup or containers.smartercrockpot_old_widgetsetup or oldwidgetsetup
containers.widgetsetup = function(container, prefab, ...)
    if (not prefab and container and container.inst and container.inst.prefab == "concheror") or (prefab and container and container.inst and container.inst.prefab == "concheror") or
	   (not prefab and container and container.inst and container.inst.prefab == "battalions_backup") or (prefab and container and container.inst and container.inst.prefab == "battalions_backup") then
		prefab = "backpack"
	elseif(not prefab and container and container.inst and container.inst.prefab == "tf2bountyhat") or (prefab and container and container.inst and container.inst.prefab == "tf2bountyhat") then
		prefab = "treasurechest"
    end
    return oldwidgetsetup(container, prefab, ...)
end

-- Make a special action for Battalion's Backup

local play_battalions_backup = State({
        name = "play_battalions_backup",
        tags = { "doing", "playing", "busy" },

        onenter = function(inst)
			local equipslots = nil
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
			local battalions_backup = inst.components.inventory:GetEquippedItem(equipslots)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
			inst.AnimState:OverrideSymbol("horn01", "battalions_horn_pre", "horn01")
			inst:DoTaskInTime(0.7, function() inst.AnimState:OverrideSymbol("horn01", "battalions_horn", "horn01") end)
            --inst.AnimState:Hide("ARM_carry") 
            inst.AnimState:Show("ARM_normal")
            if inst.components.inventory.activeitem and inst.components.inventory.activeitem.components.instrument then
                inst.components.inventory:ReturnActiveItem()
            end
        end,

        timeline =
        {
            TimeEvent(21*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/battalions_backup")
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry") 
                inst.AnimState:Hide("ARM_normal")
            end
			
			local equipslots = nil
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
			local battalions_backup = inst.components.inventory:GetEquippedItem(equipslots)
			if battalions_backup ~= nil and battalions_backup:HasTag("battalions_backup") then
				battalions_backup:AddTag("buffdeployed")
				battalions_backup:RemoveTag("buffdeployable")
				if battalions_backup.components.fueled then
					battalions_backup.components.fueled:DoDelta(-1) -- to avoid "Play" bug
				end
				battalions_backup:RemoveComponent("instrument")
				inst.AnimState:ClearOverrideSymbol("swap_body")
				inst.AnimState:OverrideSymbol("swap_body", "swap_battalions_backup_flag", "swap_body")
			end
        end,
    })
local function SGWilsonPostInit(sg)
    sg.states["play_battalions_backup"] = play_battalions_backup
end

AddStategraphState("SGwilson", play_battalions_backup)
AddStategraphPostInit("wilson", SGWilsonPostInit) 

-- Make a special action for concheror
local play_concheror = State({
        name = "play_concheror",
        tags = { "doing", "playing", "busy" },

        onenter = function(inst)
			local equipslots = nil
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
			local concheror = inst.components.inventory:GetEquippedItem(equipslots)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
			inst.AnimState:OverrideSymbol("horn01", "conch_pre", "horn01")
			inst:DoTaskInTime(0.7, function() inst.AnimState:OverrideSymbol("horn01", "conch", "horn01") end)
            --inst.AnimState:Hide("ARM_carry") 
            inst.AnimState:Show("ARM_normal")
            if inst.components.inventory.activeitem and inst.components.inventory.activeitem.components.instrument then
                inst.components.inventory:ReturnActiveItem()
            end
        end,

        timeline =
        {
            TimeEvent(21*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/concheror")
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry") 
                inst.AnimState:Hide("ARM_normal")
            end
			
			local equipslots = nil
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
			local concheror = inst.components.inventory:GetEquippedItem(equipslots)
			if concheror ~= nil and concheror:HasTag("concheror") then
				concheror:AddTag("buffdeployed")
				concheror:RemoveTag("buffdeployable")
				if concheror.components.fueled then
					concheror.components.fueled:DoDelta(-1) -- to avoid "Play" bug
				end
				concheror:RemoveComponent("instrument")
				inst.AnimState:ClearOverrideSymbol("swap_body")
				inst.AnimState:OverrideSymbol("swap_body", "swap_concheror_flag", "swap_body")
				if inst.components.locomotor then
					inst.components.locomotor:SetExternalSpeedMultiplier(inst, "concheror_speed_mod", TUNING.CONCHEROR_SPEED)
					
					inst:DoTaskInTime(0.95, function() --we gotta prevent infinite speed bonus just in case
						local a,b,c = inst.Transform:GetWorldPosition()
						local ents7 = TheSim:FindEntities(a,b,c, TUNING.CONCHEROR_RANGE, {"player"}, {"flower", "renewable", "fx"}, {"tf2soldier"})
						for k,v in pairs(ents7) do
							if (v and v.components.inventory and v.components.inventory:GetEquippedItem(equipslots) ~= nil 
							and v.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") 
							and v.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed"))
							or inst.components.inventory and inst.components.inventory:GetEquippedItem(equipslots) ~= nil 
							and inst.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") 
							and inst.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") then
								--nothing
							else
								if inst.components.locomotor then
									inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "concheror_speed_mod") 
								end
							end
						end
					end)
				end
			end
        end,
    })
local function SGWilsonPostInit(sg)
    sg.states["play_concheror"] = play_concheror
end

AddStategraphState("SGwilson", play_concheror)
AddStategraphPostInit("wilson", SGWilsonPostInit) 

local BUFFBANNERING = GLOBAL.Action({ priority= 10 })	
BUFFBANNERING.str = "Deploy Banner"
BUFFBANNERING.id = "BUFFBANNERING"
BUFFBANNERING.fn = function(act)
	if act.invobject and act.invobject.components.instrument and act.doer and act.doer:HasTag("tf2soldier") then
        return act.invobject.components.instrument:Play(act.doer)
    end
end
AddAction(BUFFBANNERING)

AddComponentAction("INVENTORY", "instrument", function(inst, doer, actions)
    if (inst:HasTag("buffbanner") or inst:HasTag("concheror") or inst:HasTag("battalions_backup")) and inst:HasTag("buffdeployable") and doer:HasTag("tf2soldier") then
        table.insert(actions, ACTIONS.BUFFBANNERING)
    end
end)
AddStategraphActionHandler("wilson_client", buffbanner_handler)

local buffbanner_handler = ActionHandler(ACTIONS.BUFFBANNERING, function(inst)
	if inst:HasTag("buffbannerequipped") then
		return "play_buffbanner"
	elseif inst:HasTag("concherorequipped") then
		return "play_concheror"
	elseif inst:HasTag("battalions_backup_equipped") then
		return "play_battalions_backup"
	end
end)
AddStategraphActionHandler("wilson", buffbanner_handler)

local buffbanner_handler_client = ActionHandler(ACTIONS.BUFFBANNERING, "play")
AddStategraphActionHandler("wilson_client", buffbanner_handler_client)

-- Battalion's Backup effect! --

AddComponentPostInit("combat", function(Combat)
    local OldCalcDamage = Combat.CalcDamage
    Combat.CalcDamage = function(self, target, weapon, multiplier, ...)
		local old_mult = nil
		
		if target and target:HasTag("battalion_backuped") and self.inst.components.combat.damagemultiplier ~= nil and self.inst.components.combat.damagemultiplier > 0 then
			old_mult = self.inst.components.combat.damagemultiplier
		else
			old_mult = 1
		end
		
		if target and target:HasTag("battalion_backuped") and not target:HasTag("equalized") then -- don't scan area and all that stuff to avoid lag if target isn't battalion-backuped
			local x,y,z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z, TUNING.BATTALIONS_BACKUP_RANGE, {"player"}, {"flower", "renewable", "fx"}, {"tf2soldier"})
			for k,v in pairs(ents) do
				if v ~= nil and v:HasTag("player") and v:HasTag("tf2soldier") and v.components.inventory:GetEquippedItem(equipslots) ~= nil and v.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") and v.components.inventory:GetEquippedItem(equipslots):HasTag("battalions_backup")  then
				
				else
					target:RemoveTag("battalion_backuped")
				end
			end
		
			self.inst.components.combat.damagemultiplier = TUNING.BATTALIONS_BACKUP_DMG_REDUCTION
		end
		
        local ret = OldCalcDamage(self, target, weapon, ...)
        if old_mult ~= nil and self.inst then
            self.inst.components.combat.damagemultiplier = old_mult
        end
        return ret
    end
end)

-- Equalizer's Debuff
AddComponentPostInit("health", function(Health)
    local OldDoDelta = Health.DoDelta
    Health.DoDelta = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
	
	local old_absorb = nil
	
	if self.inst and self.inst:HasTag("equalized") and self.inst.components.health.absorb ~= 0 then
		old_absorb = self.inst.components.health.absorb
	else
		old_absorb = 0
	end
		
	if self.inst and self.inst:HasTag("equalized") then
		if self.inst.components.health.absorb == nil or self.inst.components.health.absorb == 0 then
			self.inst.components.health.absorb = -0.5
		else
			self.inst.components.health.absorb = old_absorb-0.5
		end
	end
	
	local ret = OldDoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
		if old_absorb ~= nil and self.inst then
            self.inst.components.health.absorb = old_absorb
        end
        return ret
    end
end)

-- Concheror's effect! --
AddComponentPostInit("combat", function(Combat)
    local OldCalcDamage = Combat.CalcDamage
    Combat.CalcDamage = function(self, target, weapon, ...)
        if weapon and target and self.inst:HasTag("concherored") then
			local equipslots = nil
			local isbuffernearby = nil
	
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
		
			local x,y,z = self.inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z, TUNING.BUFFBANNER_RANGE, {"player"}, {"flower", "renewable", "fx"}, {"tf2soldier"})
			for k,v in pairs(ents) do
				if v ~= nil and v:HasTag("player") and v:HasTag("tf2soldier") and v.components.inventory:GetEquippedItem(equipslots) ~= nil and v.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") and v.components.inventory:GetEquippedItem(equipslots):HasTag("concheror")  then
					isbuffernearby = true
				else
					self.inst:RemoveTag("concherored")
				end
			end
			
			if self.inst.components.combat.damagemultiplier ~= nil and isbuffernearby ~= nil and self.inst.components.health and (self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.weapon ~= nil) then
				self.inst.components.health:DoDelta(self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.weapon.damage*TUNING.CONCHEROR_COMBAT_HEAL)
			end
			
		elseif weapon == nil and self.inst:HasTag("concherored") and self.inst.components.combat then
			local equipslots = nil
			local isbuffernearby = nil
	
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
		
			local x,y,z = self.inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z, TUNING.CONCHEROR_RANGE, {"player"}, {"flower", "renewable", "fx"}, {"tf2soldier"})
			for k,v in pairs(ents) do
				if v ~= nil and v:HasTag("player") and v:HasTag("tf2soldier") and v.components.inventory:GetEquippedItem(equipslots) ~= nil and v.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") and v.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") then
					isbuffernearby = true
				else
					self.inst:RemoveTag("concherored")
				end
			end
		
			if isbuffernearby ~= nil and self.inst.components.health and self.inst:HasTag("player") then
				self.inst.components.health:DoDelta(1)
			elseif isbuffernearby ~= nil and self.inst.components.health and not self.inst:HasTag("player") then
				self.inst.components.health:DoDelta(5) -- animal followers get 5 hp on attack
			end
		end
        local ret = OldCalcDamage(self, target, weapon, ...)
        return ret
    end
end)

AddComponentPostInit("explosive", function(Explosive)
    local OldOnBurnt = Explosive.OnBurnt
    Explosive.OnBurnt = function(self, target, weapon, ...)
        for i, v in ipairs(AllPlayers) do
        local distSq = v:GetDistanceSqToInst(self.inst)
        local k = math.max(0, math.min(1, distSq / 1600))
        local intensity = k * (k - 2) + 1 --easing.outQuad(k, 1, -1, 1)
        if intensity > 0 then
            v:ScreenFlash(intensity)
            v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
        end
    end

    if self.onexplodefn ~= nil then
        self.onexplodefn(self.inst)
    end

    local stacksize = self.inst.components.stackable ~= nil and self.inst.components.stackable:StackSize() or 1
    local totaldamage = self.explosivedamage * stacksize

    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, self.explosiverange, nil, { "INLIMBO" })

    for i, v in ipairs(ents) do
        if v ~= self.inst and v:IsValid() and not v:IsInLimbo() then
            if not self.inst:HasTag("stickybomb") and not self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                v.components.workable:WorkedBy(self.inst, self.buildingdamage) -- other explosive work
			elseif self.inst:HasTag("stickybomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and v.components.workable.action ~= ACTIONS.NET and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage) -- stickybomb work (excluding below)
			elseif self.inst:HasTag("stickybomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and not v:HasTag("structure") and (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.25) -- boulders
			elseif self.inst:HasTag("stickybomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v:HasTag("structure") then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.2) -- structures
			elseif self.inst:HasTag("stickybomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and v.entity and v.entity:HasTag("statue") and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.35) -- statues
			elseif self.inst:HasTag("stickybomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and v.components.pickable and v.components.pickable:CanBePicked() and v.components.lootdropper then
				v.components.lootdropper:SpawnLootPrefab(v.components.pickable.product) -- plants
				v.components.pickable:MakeEmpty()
			-- Quickies!
			elseif self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and v.components.workable.action ~= ACTIONS.NET and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.4) -- quickiebomb work (excluding below)
			elseif self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and not v:HasTag("structure") and (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.125) -- boulders
			elseif self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v:HasTag("structure") then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.1) -- structures
			elseif self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and v.components.workable.action ~= ACTIONS.DIG and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and v.entity and v.entity:HasTag("statue") and not v.components.pickable then
				v.components.workable:WorkedBy(self.inst.components.homeseeker.home.components.inventoryitem.owner, self.buildingdamage*0.175) -- statues
			elseif self.inst:HasTag("quickiebomb") and v.components.workable ~= nil and v.components.workable:CanBeWorked() and not v:HasTag("structure") and not (v:HasTag("boulder") or v.prefab == "rock_ice") and not (v.entity and v.entity:HasTag("statue")) and v.components.pickable and v.components.pickable:CanBePicked() and v.components.lootdropper then
				v.components.lootdropper:SpawnLootPrefab(v.components.pickable.product) -- plants
				v.components.pickable:MakeEmpty()
            end

            --Recheck valid after work
            if v:IsValid() and not v:IsInLimbo() then
                if self.lightonexplode and
                    v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end
				
                if v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and not v:HasTag("player") and not v:HasTag("demoman") then
                    v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, totaldamage, nil) -- attack stickybomb launcher owner
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and not self.inst:HasTag("stickybomb") and not self.inst:HasTag("caber") and not self.inst:HasTag("quickiebomb") and not v:HasTag("player") and not v:HasTag("demoman") then
                    v.components.combat:GetAttacked(self.inst, totaldamage, nil) -- what attacked me? gunpowder? huh, i can't attack that...
					
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and not self.inst:HasTag("caber_thrown") and self.inst.components.inventoryitem.owner and not v:HasTag("demoman") and (self.inst.components.inventoryitem.owner.drunkscrumpy == nil or self.inst.components.inventoryitem.owner.drunkscrumpy == 0) then
					v.components.combat:GetAttacked(self.inst.components.inventoryitem.owner, totaldamage, nil) -- ullapool caber melee on non-players
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and not self.inst:HasTag("caber_thrown") and self.inst.components.inventoryitem.owner and not v:HasTag("demoman") and (self.inst.components.inventoryitem.owner.drunkscrumpy ~= nil and self.inst.components.inventoryitem.owner.drunkscrumpy > 0) then
					v.components.combat:GetAttacked(self.inst.components.inventoryitem.owner, totaldamage*2, nil) -- CRIT ullapool caber melee on non-players
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and not v:HasTag("player") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, totaldamage*0.75, nil) -- ullapool caber thrown on non-players
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and not v:HasTag("player") and (self.inst.components.complexprojectile.attacker.drunkscrumpy ~= nil and self.inst.components.complexprojectile.attacker.drunkscrumpy > 0) then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, (totaldamage*0.75)*2, nil) -- CRIT ullapool caber thrown on non-players
					
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and not self.inst:HasTag("caber_thrown") and self.inst.components.inventoryitem.owner and self.inst.components.inventoryitem.owner == v and v:HasTag("demoman") and (self.inst.components.inventoryitem.owner.drunkscrumpy == nil or self.inst.components.inventoryitem.owner.drunkscrumpy == 0) then
					v.components.combat:GetAttacked(self.inst.components.inventoryitem.owner, totaldamage*0.5, nil) -- ullapool caber melee on demo if demo is the attacker
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and not self.inst:HasTag("caber_thrown") and self.inst.components.inventoryitem.owner and self.inst.components.inventoryitem.owner == v and v:HasTag("demoman") and (self.inst.components.inventoryitem.owner.drunkscrumpy ~= nil and self.inst.components.inventoryitem.owner.drunkscrumpy > 0) then
					v.components.combat:GetAttacked(self.inst.components.inventoryitem.owner, totaldamage, nil) -- CRIT ullapool caber melee on demo if demo is the attacker
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, (totaldamage*0.75)*0.5, nil) -- ullapool caber thrown on demo(PVP)
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy ~= nil and self.inst.components.complexprojectile.attacker.drunkscrumpy > 0) and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, totaldamage*0.75, nil) -- CRIT ullapool caber thrown on demo(PVP)
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker ~= v and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, 1, nil) -- ullapool caber thrown on demo(non-PVP) if demo is not the attacker
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker ~= v and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy ~= nil and self.inst.components.complexprojectile.attacker.drunkscrumpy > 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, 1, nil) -- CRIT ullapool caber thrown on demo(non-PVP) if demo is not the attacker
					elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker == v and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, (totaldamage*0.75)*0.5, nil) -- ullapool caber thrown on demo(non-PVP) if demo is the attacker
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker == v and v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy ~= nil and self.inst.components.complexprojectile.attacker.drunkscrumpy > 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, totaldamage*0.75, nil) -- CRIT ullapool caber thrown on demo(non-PVP) if demo is the attacker
					
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and v:HasTag("player") and not v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, totaldamage*0.75, nil) -- ullapool caber thrown on player PVP
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and v:HasTag("player") and not v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy ~= nil and self.inst.components.complexprojectile.attacker.drunkscrumpy > 0) and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, (totaldamage*0.75)*2, nil) -- CRIT ullapool caber thrown on player PVP
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker == v and v:HasTag("player") and not v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, totaldamage*0.75, nil) -- ullapool caber thrown on player non-PVP and thrower is the player
				elseif v.components.combat ~= nil and self.inst:HasTag("caber") and self.inst:HasTag("caber_thrown") and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker ~= v and v:HasTag("player") and not v:HasTag("demoman") and (self.inst.components.complexprojectile.attacker.drunkscrumpy == nil or self.inst.components.complexprojectile.attacker.drunkscrumpy == 0) and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.complexprojectile.attacker, 1, nil) -- ullapool caber thrown on player non-PVP and thrower is not the player
					
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and not self.inst:HasTag("stickybomb") and not self.inst:HasTag("quickiebomb") and v:HasTag("player") and v:HasTag("demoman") then
					v.components.combat:GetAttacked(self.inst, totaldamage*0.5, nil) -- demoman's 50% dmg reduction for all explosives BUT stickies
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and v:HasTag("player") and v:HasTag("demoman") and self.inst.components.homeseeker.home.components.inventoryitem.owner == v then
					v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, totaldamage*0.5, nil) -- demoman's 50% dmg reduction for HIS stickies
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and v:HasTag("player") and v:HasTag("demoman") and self.inst.components.homeseeker.home.components.inventoryitem.owner ~= v and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, 1, nil) -- demoman takes 1 dmg from OTHER'S stickies if PVP is disabled
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and v:HasTag("player") and v:HasTag("demoman") and self.inst.components.homeseeker.home.components.inventoryitem.owner ~= v and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, totaldamage*0.5, nil) -- demoman takes 50% dmg from OTHER'S stickies if PVP is enabled
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and not v:HasTag("demoman") and v:HasTag("player") and not TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, 1, nil) -- players take only 1 damage from stickies if PVP is disabled
				elseif v.components.combat ~= nil and not v:HasTag("stickybomb") and not v:HasTag("quickiebomb") and (self.inst:HasTag("stickybomb") or self.inst:HasTag("quickiebomb")) and not v:HasTag("demoman") and v:HasTag("player") and TheNet:GetPVPEnabled() then
					v.components.combat:GetAttacked(self.inst.components.homeseeker.home.components.inventoryitem.owner, totaldamage, nil) -- PVP enabled, be ready for spawncamping...
                end

				if self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner and self.inst.components.inventoryitem.owner.components.health and self.inst.components.inventoryitem.owner:HasTag("concherored") then
					self.inst.components.inventoryitem.owner.components.health:DoDelta(totaldamage*0.15)
				elseif self.inst.components.homeseeker and self.inst.components.homeseeker.home.components.inventoryitem.owner and self.inst.components.homeseeker.home.components.inventoryitem.owner.components.health and self.inst.components.homeseeker.home.components.inventoryitem.owner:HasTag("concherored") then
					self.inst.components.homeseeker.home.components.inventoryitem.owner.components.health:DoDelta(totaldamage*0.1)
				elseif self.inst.components.complexprojectile and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker and self.inst.components.complexprojectile.attacker:HasTag("concherored") then
					self.inst.components.complexprojectile.attacker.components.health:DoDelta((totaldamage*0.1)*0.75)
				end
				
                v:PushEvent("explosion", { explosive = self.inst })
            end
        end
    end

    local world = TheWorld
    for i = 1, stacksize do
        world:PushEvent("explosion", { damage = self.explosivedamage })
    end

    if self.inst.components.health ~= nil then
        self.inst:PushEvent("death")
    end

	if not self.inst:HasTag("caber") then
		self.inst:Remove()
	end

    end
end)

-- Make a special actions for stickybomb/quickiebomb launcher -------------------------------------------------
local STICKYBOMBING = GLOBAL.Action({ priority= 10, mindistance=1 })	
STICKYBOMBING.str = "Set bomb"
STICKYBOMBING.id = "STICKYBOMBING"
STICKYBOMBING.fn = function(act)
	if act.doer:HasTag("demoman") and act.invobject and (act.invobject:HasTag("stickybomblauncher") or act.invobject:HasTag("quickiebomblauncher")) and (act.invobject.stickybombs == nil or act.invobject.stickybombs < TUNING.STCKYLNCHR_MAXSTICKIES) and act.invobject.components.fueled and act.invobject.components.fueled.currentfuel > 0 and act.invobject.components.deployable and act.invobject.components.deployable:CanDeploy(act.pos) then
        if act.invobject.components.deployable:Deploy(act.pos, act.doer) then
            return true
        end
    end
end
AddAction(STICKYBOMBING)

local stickybombing_handler = ActionHandler(ACTIONS.STICKYBOMBING, function(inst) 
	if inst:HasTag("stickylauncherequipped") then
		return "dolongaction"
	elseif inst:HasTag("quickielauncherequipped") then
		return "attack"
	end
end)
AddStategraphActionHandler("wilson", stickybombing_handler)

AddComponentAction("POINT", "deployable", function(inst, doer, pos, actions, right)
    if right and (inst:HasTag("stickybomblauncher") or inst:HasTag("quickiebomblauncher")) and (inst.stickybombs == nil or inst.stickybombs < TUNING.STCKYLNCHR_MAXSTICKIES) and not inst:HasTag("fueldepleted") and inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:CanDeploy(pos) then
        table.insert(actions, ACTIONS.STICKYBOMBING)
    end
end)
AddStategraphActionHandler("wilson_client", stickybombing_handler)

-- Ka-boom! ----------------------------------
local KABLOOIE = GLOBAL.Action({ priority= 10 })	
KABLOOIE.str = "Detonate"
KABLOOIE.id = "KABLOOIE"
KABLOOIE.fn = function(act)
	local lawnchair = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

    if lawnchair and (lawnchair:HasTag("stickybomblauncher") or lawnchair:HasTag("quickiebomblauncher")) and (lawnchair.stickybombs ~= nil and lawnchair.stickybombs > 0)
	and lawnchair:HasTag("stickyequip") and lawnchair.components.spellcaster and lawnchair.components.spellcaster:CanCast(act.doer, act.target, act.pos) then
        lawnchair.components.spellcaster:CastSpell(act.target, act.pos)
        return true
    end
end
AddAction(KABLOOIE)

local kablooeing_handler = ActionHandler(ACTIONS.KABLOOIE, "doshortaction")
AddStategraphActionHandler("wilson", kablooeing_handler)

AddComponentAction("INVENTORY", "spellcaster", function(inst, doer, actions)
    if (inst:HasTag("stickybomblauncher") or inst:HasTag("quickiebomblauncher")) and inst:HasTag("stickiesdeployed") and inst:HasTag("stickyequip") then
        table.insert(actions, ACTIONS.KABLOOIE)
    end
end)
AddStategraphActionHandler("wilson_client", kablooeing_handler)

-- Ullapool stategraph states: ---

local ullapoolattack = State{
        name = "ullapoolattack",
        tags = { "ullapoolattack", "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("caber") then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
                cooldown = math.max(cooldown, 13 * FRAMES)
            end

            inst.sg:SetTimeout(cooldown)

            if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
					if equip ~= nil and equip.components.explosive then
						inst:DoTaskInTime(0.33, function() -- a kinda hacky way to make caber actually do something (affects left-click only, not auto-attack)
							if equip ~= nil and equip.components.explosive and target ~= nil and target:IsValid() 
							and (inst:GetDistanceSqToInst(target) <= 1.75 and not target:HasTag("largecreature") or target:HasTag("largecreature") and inst:GetDistanceSqToInst(target) <= 3.5) then 
								equip.components.explosive:OnBurnt() 
							end
						end)
					end
                end
            end
        end,

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    }
	
local function SGWilsonPostInit(sg)
    sg.states["ullapoolattack"] = ullapoolattack
end

AddStategraphState("SGwilson", ullapoolattack)
AddStategraphPostInit("wilson", SGWilsonPostInit) 
---
local ullapoolthrow = State{
        name = "throw",
        tags = { "ullapoolthrow", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = math.max(inst.components.combat.min_attack_period + .5 * FRAMES, 11 * FRAMES)

            inst.AnimState:PlayAnimation("throw")

            inst.sg:SetTimeout(cooldown)

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
            end
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    }

local function SGWilsonPostInit(sg)
    sg.states["ullapoolthrow"] = ullapoolthrow
end

AddStategraphState("SGwilson", ullapoolthrow)
AddStategraphPostInit("wilson", SGWilsonPostInit) 
	
-- Ullapolean Throw! ----------------------------------
local ULLATHROW = GLOBAL.Action({ priority= 10, distance= TUNING.ULLAPOOL_CABER_DIST, canforce=false, mount_valid=true })	
ULLATHROW.str = "Throw"
ULLATHROW.id = "ULLATHROW"
ULLATHROW.fn = function(act)
	if act.invobject and act.doer then
        if act.invobject.components.complexprojectile and act.invobject:HasTag("caber_throwable") and act.doer.components.inventory then
            local projectile = act.doer.components.inventory:DropItem(act.invobject, false)
            if projectile then
                local pos = nil
                if act.target then
                    pos = act.target:GetPosition()
                    projectile.components.complexprojectile.targetoffset = {x=0,y=1.5,z=0}
                else
                    pos = act.pos
                end
                projectile.components.complexprojectile:Launch(pos, act.doer)
                return true
            end
        end
    end
end
AddAction(ULLATHROW)

local ullathrowing_handler = ActionHandler(ACTIONS.ULLATHROW, "ullapoolthrow")
AddStategraphActionHandler("wilson", ullathrowing_handler)

AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)
    if inst:HasTag("caber") and inst:HasTag("caber_throwable") and right then
        table.insert(actions, ACTIONS.ULLATHROW)
    end
end)

AddComponentAction("EQUIPPED", "complexprojectile", function(inst, doer, target, actions, right)
    if inst:HasTag("caber") and inst:HasTag("caber_throwable") and right then
        table.insert(actions, ACTIONS.ULLATHROW)
    end
end)

local ullathrowing_handler_client = ActionHandler(ACTIONS.ULLATHROW, "throw")
AddStategraphActionHandler("wilson_client", ullathrowing_handler_client)

-- Ullapolean Hit! ----------------------------------
-- ...and Half-Zatoichi attack (mainly made for sound): ----

local ULLAHIT = GLOBAL.Action({ priority= 10, canforce=true, mount_valid=true })	
ULLAHIT.str = "Attack"
ULLAHIT.id = "ULLAHIT"
ULLAHIT.fn = function(act)
	act.doer.components.combat:DoAttack(act.target)
	return true
end
AddAction(ULLAHIT)

local ullahitting_handler = ActionHandler(ACTIONS.ULLAHIT, "ullapoolattack")
AddStategraphActionHandler("wilson", ullahitting_handler)

AddComponentAction("EQUIPPED", "ullapoolhitter", function(inst, doer, target, actions, right)
    if not right
    and doer.replica.combat ~= nil
    and (inst:HasTag("caber") and inst:HasTag("caber_throwable"))
	and target and target.components.health and not target.components.health:IsDead() 
	and target.components.combat and target.components.combat:CanBeAttacked(doer) then
        table.insert(actions, ACTIONS.ULLAHIT)
	end
end)

local ullahitting_handler_client = ActionHandler(ACTIONS.ULLAHIT, "attack")
AddStategraphActionHandler("wilson_client", ullahitting_handler_client)
	
-- New state for Bounty Hat: --
local openbountyhat = State{
        name = "openbountyhat",
        tags = { "openbountyhat" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()

			inst:DoTaskInTime(0.33, function(inst)
				if not inst.AnimState:IsCurrentAnimation("idle_wardrobe1_pre") and not inst.AnimState:IsCurrentAnimation("idle_wardrobe1_loop") 
				and not inst.sg:HasStateTag("busy") and not inst:HasTag("moving") then
					inst.AnimState:PlayAnimation("idle_wardrobe1_pre")
					inst.AnimState:PushAnimation("idle_wardrobe1_loop", true)
				end
			end)
			
        end,

        events =
        {
            EventHandler("firedamage", function(inst)
				if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "tf2bountyhat" then
					local bountyhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
					bountyhat.components.container:Close()
					inst.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
				end
                inst.sg:GoToState("idle")
            end),
			
			EventHandler("attacked", function(inst)
				if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "tf2bountyhat" then
					inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.container:Close()
					inst.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
				end
            end),
			
			EventHandler("unequip", function(inst)
				if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "tf2bountyhat" then
					inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.container:Close()
					inst.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
				end
				inst.sg:GoToState("idle")
            end),
			
        },

        onexit = function(inst)
			if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "tf2bountyhat" then
				inst:DoTaskInTime(0.25, function(inst) -- dotaskintime to prevent instant reopen on 'Close' action
					if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).prefab == "tf2bountyhat" then
						inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.container:Close() 
					end
				end)
				inst.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
			end
        end,
    }

local function SGWilsonPostInit(sg)
    sg.states["openbountyhat"] = openbountyhat
end

AddStategraphState("SGwilson", openbountyhat)
AddStategraphPostInit("wilson", SGWilsonPostInit) 

-- Bounty Hat inventory item overflow fix -- REMOVED DUE TO BUGS

for k,v in pairs(GLOBAL.ModManager.mods) do
if v.modinfo and v.modinfo.name == "Soldier (TF2)" then

function SoldierBackupPostInit(inst)
    if GLOBAL.TheWorld.ismastersim then
		local function IsValidVictim(victim)
			return victim ~= nil
			and not (victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("companion"))
			and victim.components.health ~= nil
			and victim.components.combat ~= nil
		end

		local function onattackbackup(inst, data)
			local victim = data.target
			local damage = data.weapon ~= nil and data.weapon.components.weapon.damage or inst.components.combat.defaultdamage
			local total_health = nil
	
			if victim.components.health then
				total_health = victim.components.health:GetMaxWithPenalty()
			end
	
			local total_damage = nil
	
			if total_health ~= nil and damage > total_health then
				total_damage = total_health
			else
				total_damage = damage
			end
	
			local equipslots = nil
	
			if EQUIPSLOTS["BACK"] then
				equipslots = EQUIPSLOTS["BACK"]
			else
				equipslots = EQUIPSLOTS["BODY"]
			end
	
			if IsValidVictim(victim) and total_health ~= nil and inst.components.inventory:GetEquippedItem(equipslots)~= nil and inst.components.inventory:GetEquippedItem(equipslots).prefab == "battalions_backup" and not inst.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") then
				inst.components.inventory:GetEquippedItem(equipslots).components.fueled:DoDelta(total_damage)
			end
		end
		inst:ListenForEvent("onattackother", onattackbackup)
	end
end
AddPrefabPostInit("tf2soldier", SoldierBackupPostInit)

end
end
	
-- WAR! --
AddMinimapAtlas("images/inventoryimages/concheror.xml")
AddMinimapAtlas("images/inventoryimages/battalions_backup.xml")
AddMinimapAtlas("images/inventoryimages/quickiebomblauncher.xml") 
AddMinimapAtlas("images/inventoryimages/quickiebomb.xml") 
AddMinimapAtlas("images/inventoryimages/tf2bountyhat.xml") 
