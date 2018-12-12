local assets =
{
	-- Animation files used for the item.
	Asset("ANIM", "anim/battalions_backup_ground.zip"),
	Asset("ANIM", "anim/swap_battalions_backup.zip"),
	Asset("ANIM", "anim/swap_battalions_backup_flag.zip"),
	
	Asset("ANIM", "anim/battalionsbackupfx.zip"),
	
	Asset("ATLAS", "images/inventoryimages/battalions_backup.xml"),
	Asset("IMAGE", "images/inventoryimages/battalions_backup.tex"),
}

local function HearHorn(inst, musician, instrument)

end

local function onequip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_body", "swap_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_battalions_backup", "swap_body")
    inst.components.container:Open(owner)
	
	if owner and not owner:HasTag("tf2soldier") then
		if inst.components.fueled then
			inst.bannerfuel = inst.components.fueled.currentfuel
			inst:RemoveComponent("fueled")
		end
	elseif owner and owner:HasTag("tf2soldier") then
		if not inst.components.fueled then
			inst:AddComponent("fueled")
			inst.components.fueled.maxfuel = TUNING.BATTALIONS_BACKUP_DMG_REQUIRED
			if inst.bannerfuel ~= nil then
				inst.components.fueled.currentfuel = inst.bannerfuel
			end
		end
		
		if inst.components.fueled and inst.components.fueled.currentfuel == inst.components.fueled.maxfuel and not inst.components.instrument then
			inst:AddComponent("instrument")
			inst.components.instrument.range = TUNING.BATTALIONS_BACKUP_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
		end
		
		owner:AddTag("battalions_backup_equipped")
	end
	
end

local function onunequip(inst, owner) 
    --owner.AnimState:ClearOverrideSymbol("backpack")
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.container:Close(owner)
	
	if inst.components.fueled then
		inst.bannerfuel = inst.components.fueled.currentfuel
		inst:RemoveComponent("fueled")
	end
	
	if inst.components.instrument then
		inst:RemoveComponent("instrument")
	end
	
	if inst:HasTag("buffdeployed") then
		inst:RemoveTag("buffdeployed")
	end
	
	if owner:HasTag("battalion_backuped") then
		owner:RemoveTag("battalion_backuped")
	end
	
	if owner and owner:HasTag("battalions_backup_equipped") then
		owner:RemoveTag("battalions_backup_equipped")
	end
	
end

---------------------------------
local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
        inst:RemoveComponent("container")
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function onsave(inst, data)
    if inst.bannerfuel ~= nil and not inst.components.fueled then
		data.bannerfuel = inst.bannerfuel
	end
	
	if inst.components.fueled then
		data.bannerfuel = inst.components.fueled.currentfuel
	end
	
end    

local function onpreload(inst, data)
    if data and data.bannerfuel ~= nil then
		inst.bannerfuel = data.bannerfuel
	end
end

local function onload(inst, data)
	if inst.bannerfuel ~= nil then
		if not inst.components.fueled then
			inst:AddComponent("fueled")
			inst.components.fueled.maxfuel = TUNING.BATTALIONS_BACKUP_DMG_REQUIRED
			inst.components.fueled.currentfuel = inst.bannerfuel
		end
		if inst.bannerfuel == inst.components.fueled.maxfuel then
			inst:AddTag("buffdeployable")
			if not inst.components.instrument then
				inst:AddComponent("instrument")
			end
			inst.components.instrument.range = TUNING.BATTALIONS_BACKUP_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
		end
	end
end

-------------------------------

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("battalions_backup_ground")
    inst.AnimState:SetBuild("battalions_backup_ground")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
	inst:AddTag("waterproofer")
	inst:AddTag("battalions_backup")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("battalions_backup.tex")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "battalions_backup"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/battalions_backup.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
	if EQUIPSLOTS["BACK"] then
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
	else
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	end
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("backpack")
	
	inst:AddComponent("lootdropper")
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)
	
	inst.bannerfuel = nil
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
	
	inst:ListenForEvent("percentusedchange", function() 
		if inst.components.fueled and inst.components.fueled.currentfuel == inst.components.fueled.maxfuel then
			if not inst.components.instrument then
				inst:AddComponent("instrument")
			end
			inst.components.instrument.range = TUNING.BATTALIONS_BACKUP_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
			
			inst:AddTag("buffdeployable")
			
			--inst.components.fueled:DoDelta(-2000)
		end
	end)
	
	inst:DoPeriodicTask(1, function() 
		if inst.components.equippable and inst.components.equippable:IsEquipped() and inst.components.inventoryitem and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("tf2soldier") then
			if inst.components.fueled and inst.components.fueled.currentfuel >= TUNING.BATTALIONS_BACKUP_TIME and inst:HasTag("buffdeployed") then
				inst.components.fueled:DoDelta(-TUNING.BATTALIONS_BACKUP_TIME)
				if inst.components.inventoryitem.owner and not inst.components.inventoryitem.owner:HasTag("battalion_backuped") then
					inst.components.inventoryitem.owner:AddTag("battalion_backuped")
				end
				local x,y,z = inst.components.inventoryitem.owner.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z, TUNING.BATTALIONS_BACKUP_RANGE)
				for k,v in pairs(ents) do
					if (v and v:HasTag("player")) or (v and v.components.follower and v.components.follower.leader ~= nil and v.components.follower.leader:HasTag("player")) and v.components.combat ~= nil then
						if not v:HasTag("battalion_backuped") then
							v:AddTag("battalion_backuped")
						end
						
						
						local battalionsbackupfx = SpawnPrefab("battalionsbackupfx")
						
						if battalionsbackupfx then
							battalionsbackupfx.Transform:SetPosition(v.Transform:GetWorldPosition())
							battalionsbackupfx.Transform:SetScale(0.5, 0.5, 0.5)
							local followerfx = battalionsbackupfx.entity:AddFollower()
							followerfx:FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, 0, 0)
						end
						
					end
				end
				
			elseif inst.components.fueled and inst.components.fueled.currentfuel <= TUNING.BATTALIONS_BACKUP_TIME and inst.components.fueled.currentfuel > 0 and inst:HasTag("buffdeployed") then
				inst.components.fueled:MakeEmpty()
			elseif inst.components.fueled and inst.components.fueled.currentfuel <= 0 and inst:HasTag("buffdeployed") then
				inst:RemoveTag("buffdeployed")
				local owner = nil
				if inst.components.inventoryitem and inst.components.inventoryitem.owner then
					owner = inst.components.inventoryitem.owner
					owner.AnimState:ClearOverrideSymbol("swap_body")
					owner.AnimState:OverrideSymbol("swap_body", "swap_battalions_backup", "swap_body")
				end	
				if owner and owner:HasTag("battalion_backuped") then
					owner:RemoveTag("battalion_backuped")
				end
			end
		end
	end)
	
	MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab( "common/inventory/battalions_backup", fn, assets) 