local assets =
{
	-- Sound files used by the item.
	Asset("SOUNDPACKAGE", "sound/tf2warsounds.fev"),
	Asset("SOUND", "sound/tf2warsounds.fsb"),

	-- Animation files used for the item.
	Asset("ANIM", "anim/quickiebomblauncher.zip"),
	Asset("ANIM", "anim/swap_quickiebomblauncher.zip"),
	Asset("ANIM", "anim/quickiebomb.zip"),

	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/quickiebomblauncher.xml"),
    Asset("IMAGE", "images/inventoryimages/quickiebomblauncher.tex"),
	
}

local prefabs = 
{ "quickiebomb" }

local function detonatebombs(staff, pos, caster)
	local caster = staff.components.inventoryitem.owner
	--caster.components.talker:Say("staffused")
	if (staff.stickybombs ~= nil and staff.stickybombs > 0) and staff.components.childspawner then
        for _,v in pairs(staff.components.childspawner.childrenoutside) do
			if v then
				v.components.explosive:OnBurnt()
				staff:RemoveComponent("spellcaster")
				staff:RemoveTag("stickiesdeployed")
			end
		end		
    end
end

local function onmounted(inst, target)
	-- since this function is used in ListenForEvent for the player, inst = player, not stickybomblauncher
	if inst ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "quickiebomblauncher" and
	inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.spellcaster then
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):RemoveComponent("spellcaster")
	end
end
	
local function ondismounted(inst, target)
	-- same as in 'onmounted'
	if inst ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "quickiebomblauncher" and
	inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).stickybombs ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).stickybombs > 0 and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.spellcaster then
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):AddComponent("spellcaster")
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.spellcaster:SetSpellFn(detonatebombs)
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.spellcaster.canusefrominventory = true
	end
end

local function onequip(inst, owner) 
	if inst:HasTag("irreplaceable") and owner and owner:HasTag("demoman") then
		inst:RemoveTag("irreplaceable")
	end
		
	owner.AnimState:OverrideSymbol("swap_object", -- Symbol to override.
		"swap_quickiebomblauncher", -- Animation bank we will use to overwrite the symbol.
		"swap_quickiebomblauncher") -- Symbol to overwrite it with.
	owner.AnimState:Show("ARM_carry") 
	owner.AnimState:Hide("ARM_normal") 
	
	if not inst:HasTag("stickyequip") then
		inst:AddTag("stickyequip")
	end
	
	if owner and owner.components.rider and owner.components.rider:IsRiding() then
		if inst.components.spellcaster then
			inst:RemoveComponent("spellcaster") -- remove component when riding
		end
	end
	
	if owner and (not owner.components.rider or owner.components.rider and not owner.components.rider:IsRiding()) and inst.stickybombs ~= nil and inst.stickybombs > 0 then
		if not inst.components.spellcaster then
			inst:AddComponent("spellcaster") -- add component in case something goes wrong (not 100% sure if this breaks something atm)
			inst.components.spellcaster:SetSpellFn(detonatebombs)
			inst.components.spellcaster.canusefrominventory = true
		end
	end
	
	if owner then
		owner:ListenForEvent("mounted", onmounted)
		owner:ListenForEvent("dismounted", ondismounted)
		
		owner:AddTag("quickielauncherequipped")
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
	
	if inst:HasTag("stickyequip") then
		inst:RemoveTag("stickyequip")
	end
	
	if owner then
		owner:RemoveEventCallback("mounted", onmounted)
		owner:RemoveEventCallback("dismounted", ondismounted)
		
		owner:RemoveTag("quickielauncherequipped")
	end
end

local function dodecay(inst)
    if inst.components.lootdropper == nil then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SpawnLootPrefab("gears")
    SpawnPrefab("small_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function startdecay(inst)
    if inst._decaytask == nil then
        inst._decaytask = inst:DoTaskInTime(TUNING.STICKYBOMBLAUNCHER_DECAYTIME, dodecay)
        inst._decaystart = GetTime()
    end
end

local function stopdecay(inst)
    if inst._decaytask ~= nil then
        inst._decaytask:Cancel()
        inst._decaytask = nil
        inst._decaystart = nil
    end
end

local function onputininventory(inst, owner) 
	if inst:HasTag("irreplaceable") and owner and owner:HasTag("demoman") then
		inst:RemoveTag("irreplaceable")
	end	
	stopdecay(inst)
end

local function ondropped(inst)
	if not inst:HasTag("irreplaceable") then
		inst:AddTag("irreplaceable")
	end
	startdecay(inst)
end

local function OnDeploy(inst, pt) 
	if inst.components.fueled.currentfuel > 0 then
		local sticky = nil
		local iscritsticky = nil
		local owner = nil
		
		if inst and inst.components.inventoryitem and inst.components.inventoryitem.owner then
			owner = inst.components.inventoryitem.owner
		end
		
		if owner ~= nil and owner:HasTag("demoman") and (owner.drunkscrumpy == nil or owner.drunkscrumpy == 0) then
			
			if owner.randomcritchance == 1 then
				if owner:HasTag("weebootied") then
					if math.random() > .89 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .99 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 2 then
				if owner:HasTag("weebootied") then
					if math.random() > .88 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .98 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 3 then
				if owner:HasTag("weebootied") then
					if math.random() > .87 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .97 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 4 then
				if owner:HasTag("weebootied") then
					if math.random() > .86 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .96 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 5 then
				if owner:HasTag("weebootied") then
					if math.random() > .85 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .95 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 6 then
				if owner:HasTag("weebootied") then
					if math.random() > .84 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .94 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 7 then
				if owner:HasTag("weebootied") then
					if math.random() > .83 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .93 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 8 then
				if owner:HasTag("weebootied") then
					if math.random() > .82 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .92 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 9 then
				if owner:HasTag("weebootied") then
					if math.random() > .81 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .91 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			elseif owner.randomcritchance == 10 then
				if owner:HasTag("weebootied") then
					if math.random() > .8 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				else
					if math.random() > .9 then
						sticky = SpawnPrefab("quickiebomb_crit")
						iscritsticky = true
					else
						sticky = SpawnPrefab("quickiebomb")
						iscritsticky = false
					end
				end
			end
		elseif owner:HasTag("demoman") and owner.drunkscrumpy ~= nil and owner.drunkscrumpy ~= 0 then
			sticky = SpawnPrefab("quickiebomb_crit")
			iscritsticky = true
		end
		
		if sticky then
			sticky.Transform:SetPosition(pt:Get())
			--sticky:AddTag("stickybombed")
			
			if iscritsticky ~= nil and iscritsticky == false then
				sticky.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/quickiebomblauncher_shoot")
				sticky.AnimState:PlayAnimation("deploying")
				sticky.AnimState:PushAnimation("swap")
			elseif iscritsticky ~= nil and iscritsticky == true then
				sticky.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/quickiebomblauncher_shoot_crit")
				sticky.AnimState:PlayAnimation("crit_deploying")
				sticky.AnimState:PushAnimation("swap_crit_buzz", true)
				sticky.Light:Enable(true)
			end
			inst.components.childspawner:DoTakeOwnership(sticky)
			inst.components.childspawner.childrenoutside[sticky] = sticky
			inst.components.childspawner.numchildrenoutside = GetTableSize(inst.components.childspawner.childrenoutside)
			
			if inst.stickybombs ~= nil then
				inst.stickybombs = inst.stickybombs + 1
				if not inst:HasTag("stickiesdeployed") then
					inst:AddTag("stickiesdeployed")
				end
			else
				inst.stickybombs = 1
				if not inst:HasTag("stickiesdeployed") then
					inst:AddTag("stickiesdeployed")
				end
			end
	
			inst.components.fueled:DoDelta(-1)
	
			if not inst.components.spellcaster then
				inst:AddComponent("spellcaster")
				inst.components.spellcaster:SetSpellFn(detonatebombs)
				inst.components.spellcaster.canusefrominventory = true
			end
			
			if inst.components.fueled.currentfuel == 0 then
				inst:RemoveComponent("deployable")
			end
		end	
	end
end

local function onchildkilled(inst, child)
	if inst.stickybombs ~= nil and inst.stickybombs > 1 then
		inst.stickybombs = inst.stickybombs - 1
	elseif inst.stickybombs ~= nil and inst.stickybombs <= 1 then
		inst.stickybombs = inst.stickybombs - 1
		inst:RemoveTag("stickiesdeployed")
		inst:RemoveComponent("spellcaster")
	end
end

local function onsave(inst, data)
    if inst._decaystart ~= nil then
        local time = GetTime() - inst._decaystart
        if time > 0 then
            data.decaytime = time
        end
    end
end    

local function onload(inst, data)
    if inst._decaytask ~= nil and data ~= nil and data.decaytime ~= nil then
        local remaining = math.max(0, TUNING.STICKYBOMBLAUNCHER_DECAYTIME - data.decaytime)
        inst._decaytask:Cancel()
        inst._decaytask = inst:DoTaskInTime(remaining, dodecay)
        inst._decaystart = GetTime() + remaining - TUNING.STICKYBOMBLAUNCHER_DECAYTIME
    end
end

local function init()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quickiebomblauncher")
    inst.AnimState:SetBuild("quickiebomblauncher")
    inst.AnimState:PlayAnimation("swap")

	inst:AddTag("quickiebomblauncher")
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quickiebomblauncher.tex")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst._decaytask = nil
    inst._decaystart = nil
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
	
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/quickiebomblauncher.xml"
    inst.components.inventoryitem.imagename = "quickiebomblauncher"
	inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)
	inst.components.deployable.spacing = 1
	
	inst:AddComponent("childspawner") -- for keeping track of deployed stickybombs
	inst.components.childspawner.onchildkilledfn = onchildkilled
	
	inst.stickybombs = nil
	inst.stickyreload = nil
	--inst.stickydata = nil
	
	--inst:AddComponent("spellcaster") -- stickybombing is magic!
	--inst.components.spellcaster:SetSpellFn(detonatebombs)
	--inst.components.spellcaster.canusefrominventory = true
	
	inst:AddComponent("fueled")
	inst.components.fueled.maxfuel = TUNING.QUCKIELNCHR_MAXSTICKIES
	inst.components.fueled.currentfuel = TUNING.QUCKIELNCHR_MAXSTICKIES
	--inst.components.fueled.fueltype = FUELTYPE.BURNABLE
	
	inst:DoTaskInTime(0, function() 
		if inst.components.fueled.currentfuel == 0 then 
			inst:AddTag("fueldepleted") 
			inst:RemoveComponent("deployable")
		end 
	end)
	
	inst:DoPeriodicTask(1, function()
		if inst.components.fueled.currentfuel < inst.components.fueled.maxfuel and (inst.stickybombs == nil or inst.stickybombs == 0) then
			if inst.stickyreload == nil then
				inst.stickyreload = 1
				
			elseif inst.stickyreload >= TUNING.QUCKIELNCHR_RLDSPD then
				inst.stickyreload = nil
				inst.components.fueled:DoDelta(1)
				
				if inst.components.equippable:IsEquipped() and not inst.SoundEmitter:PlayingSound("tf2warsounds/tf2warsounds/quickiebomblauncher_reload") then
					inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/quickiebomblauncher_reload")
				end
				
				if not inst.components.deployable then
					inst:AddComponent("deployable")
					inst.components.deployable.ondeploy = OnDeploy
					inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)
					inst.components.deployable.spacing = 1
				end
					
			elseif inst.stickyreload >= 1 and inst.stickyreload < TUNING.QUCKIELNCHR_RLDSPD then
				inst.stickyreload = inst.stickyreload + 1
			end
		end
	end)
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	startdecay(inst)
	
    MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab("common/inventory/quickiebomblauncher", init, assets, prefabs),
		MakePlacer( "common/quickiebomblauncher_placer", "quickiebomb", "quickiebomb", "swap" ) 