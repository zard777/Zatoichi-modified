local assets =
{
	-- Animation files used for the item.
	Asset("ANIM", "anim/concheror_ground.zip"),
	Asset("ANIM", "anim/swap_concheror.zip"),
	Asset("ANIM", "anim/swap_concheror_flag.zip"),
	
	Asset("ATLAS", "images/inventoryimages/concheror.xml"),
	Asset("IMAGE", "images/inventoryimages/concheror.tex"),
}

local function ForceSpeedBoostRemoval(inst)
	local owner = nil
	
	if inst.components.inventoryitem.owner then
		owner = inst.components.inventoryitem.owner
	end
	
	if owner ~= nil then
		local x,y,z = owner.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, TUNING.CONCHEROR_RANGE, 0, {"flower", "fx"}, {"player", "pig", "beefalo", "manrabbit", "spider", "catcoon", "abigail", "hound", "bee", "rabbit", "critter"})
		for k,v in pairs(ents) do
			if v and v.components.locomotor then
				v.components.locomotor:RemoveExternalSpeedMultiplier(v, "concheror_speed_mod")
			end
		end
	end
end

local function SpeedRemoveOnLoyaltyLost(inst)
	if inst.components.locomotor then
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "concheror_speed_mod")
		inst:RemoveEventCallback("loseloyalty", SpeedRemoveOnLoyaltyLost)
		inst:RemoveEventCallback("attacked", SpeedRemoveOnLoyaltyLost)
	end
end

local function HearHorn(inst, musician, instrument)

end

local function OnAttackedWithConch(inst, data)
	if data.newpercent~= nil and data.oldpercent ~= nil and data.newpercent < data.oldpercent then
		local equipslots = nil
	
		if EQUIPSLOTS["BACK"] then
			equipslots = EQUIPSLOTS["BACK"]
		else
			equipslots = EQUIPSLOTS["BODY"]
		end
	
		if inst.components.inventory:GetEquippedItem(equipslots) ~= nil and inst.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") then
			inst.components.inventory:GetEquippedItem(equipslots).regenperiod = TUNING.CONCHEROR_REGEN_PERIOD -- regen period reset while being hit
		end
	end
end

local function onequip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_body", "swap_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_concheror", "swap_body")
    inst.components.container:Open(owner)
	
	if owner and not owner:HasTag("tf2soldier") then
		if inst.components.fueled then
			inst.bannerfuel = inst.components.fueled.currentfuel
			inst:RemoveComponent("fueled")
		end
	elseif owner and owner:HasTag("tf2soldier") then
		if not inst.components.fueled then
			inst:AddComponent("fueled")
			inst.components.fueled.maxfuel = TUNING.CONCHEROR_DAMAGE_REQUIRED
			if inst.bannerfuel ~= nil then
				inst.components.fueled.currentfuel = inst.bannerfuel
			end
		end
		
		if inst.components.fueled and inst.components.fueled.currentfuel == inst.components.fueled.maxfuel and not inst.components.instrument then
			inst:AddComponent("instrument")
			inst.components.instrument.range = TUNING.CONCHEROR_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
		end
		
		owner:AddTag("concherorequipped")
	end
	
	if owner then
		owner:ListenForEvent("healthdelta", OnAttackedWithConch)
	end
	
	if inst.ownerburnrate == nil and owner and owner.components.hunger then
		inst.ownerburnrate = owner.components.hunger.burnrate
		owner.components.hunger.burnrate = owner.components.hunger.burnrate*1.1
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
		ForceSpeedBoostRemoval(inst) -- gotta force that speed boost removal
	end
	
	if owner:HasTag("concherored") then
		owner:RemoveTag("concherored")
	end
	
	if owner and owner:HasTag("concherorequipped") then
		owner:RemoveTag("concherorequipped")
	end
	
	if owner then
		owner:RemoveEventCallback("healthdelta", OnAttackedWithConch)
	end
	
	if inst.ownerburnrate ~= nil and owner and owner.components.hunger then
		owner.components.hunger.burnrate = inst.ownerburnrate
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
			inst.components.fueled.maxfuel = TUNING.CONCHEROR_DAMAGE_REQUIRED
			inst.components.fueled.currentfuel = inst.bannerfuel
		end
		if inst.bannerfuel == inst.components.fueled.maxfuel then
			inst:AddTag("buffdeployable")
			if not inst.components.instrument then
				inst:AddComponent("instrument")
			end
			inst.components.instrument.range = TUNING.BUFFBANNER_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
		end
	end
end

local function onremove(inst)
	if inst.concheror_hp_fx ~= nil then
		inst.concheror_hp_fx:Remove()
		inst.concheror_hp_fx = nil
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
    
    inst.AnimState:SetBank("concheror_ground")
    inst.AnimState:SetBuild("concheror_ground")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
	inst:AddTag("waterproofer")
	inst:AddTag("concheror")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("concheror.tex")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()
    
	inst.ownerburnrate = nil
	
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "concheror"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/concheror.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
	if EQUIPSLOTS["BACK"] then
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
	else
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	end
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("backpack")
	
	inst:AddComponent("lootdropper")
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)
	
	inst.bannerfuel = nil
	inst.regenperiod = TUNING.CONCHEROR_REGEN_PERIOD
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
	
	inst:ListenForEvent("percentusedchange", function() 
		if inst.components.fueled and inst.components.fueled.currentfuel == inst.components.fueled.maxfuel then
			if not inst.components.instrument then
				inst:AddComponent("instrument")
			end
			inst.components.instrument.range = TUNING.CONCHEROR_RANGE
			inst.components.instrument:SetOnHeardFn(HearHorn)
			
			inst:AddTag("buffdeployable")
			
			--inst.components.fueled:DoDelta(-2000)
		end
	end)
	
	inst:DoPeriodicTask(1, function() 
		if inst.components.equippable and inst.components.equippable:IsEquipped() and inst.components.inventoryitem 
		and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.components.health and inst.components.inventoryitem.owner.components.health.currenthealth ~= inst.components.inventoryitem.owner.components.health:GetMaxWithPenalty() and inst.regenperiod ~= nil then
			local owner = inst.components.inventoryitem.owner
			if inst.regenperiod > 0 then
				inst.regenperiod = inst.regenperiod - 1
			else
				--owner.components.health:DoDelta(TUNING.CONCHEROR_REGEN_AMOUNT)
				owner.components.health.currenthealth = owner.components.health.currenthealth + TUNING.CONCHEROR_REGEN_AMOUNT
				owner.components.health:ForceUpdateHUD()
				inst.regenperiod = TUNING.CONCHEROR_REGEN_PERIOD
				
				inst.concheror_hp_fx = SpawnPrefab("concheror_hp_fx")
				inst.concheror_hp_fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
				inst.concheror_hp_fx.entity:SetParent(owner.entity)
				
				local follow_hp_fx = inst.concheror_hp_fx.entity:AddFollower()
				follow_hp_fx:FollowSymbol(owner.GUID, owner.components.combat.hiteffectsymbol, 0, 0, 0)
				
				inst.concheror_hp_fx:ListenForEvent("onremove", onremove, owner)
				inst.concheror_hp_fx:ListenForEvent("death", onremove, owner)
				inst.concheror_hp_fx:ListenForEvent("unequip", onremove, inst)
			end
		end
		
		if inst.components.equippable and inst.components.equippable:IsEquipped() and inst.components.inventoryitem and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("tf2soldier") then
			if inst.components.fueled and inst.components.fueled.currentfuel >= TUNING.CONCHEROR_TIME and inst:HasTag("buffdeployed") then
				inst.components.fueled:DoDelta(-TUNING.CONCHEROR_TIME)
				if inst.components.inventoryitem.owner and not inst.components.inventoryitem.owner:HasTag("concherored") then
					inst.components.inventoryitem.owner:AddTag("concherored")
				end
				local x,y,z = inst.components.inventoryitem.owner.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z, TUNING.CONCHEROR_RANGE)
				for k,v in pairs(ents) do
					if (v and v:HasTag("player")) or (v and v.components.follower and v.components.follower.leader ~= nil and v.components.follower.leader:HasTag("player")) and v.components.combat ~= nil then
						if v.components.locomotor then
							v.components.locomotor:SetExternalSpeedMultiplier(v, "concheror_speed_mod", TUNING.CONCHEROR_SPEED)
							if not v:HasTag("player") then
								v:ListenForEvent("loseloyalty", SpeedRemoveOnLoyaltyLost)
								v:ListenForEvent("attacked", SpeedRemoveOnLoyaltyLost)
							end
							local observer = v
							observer:DoTaskInTime(0.95, function() --after almost 1 second check if soldier is nearby, if not, then remove speed bonus
									local equipslots = nil
									if EQUIPSLOTS["BACK"] then
										equipslots = EQUIPSLOTS["BACK"]
									else
										equipslots = EQUIPSLOTS["BODY"]
									end
									local a,b,c = observer.Transform:GetWorldPosition()
									local ents7 = TheSim:FindEntities(a,b,c, TUNING.CONCHEROR_RANGE, {"player"}, {"flower", "renewable", "fx", "critter"}, {"tf2soldier"})
									for k,v in pairs(ents7) do
										if (v and v.components.inventory and v.components.inventory:GetEquippedItem(equipslots) ~= nil 
										and v.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") 
										and v.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed"))
										or observer.components.inventory and observer.components.inventory:GetEquippedItem(equipslots) ~= nil 
										and observer.components.inventory:GetEquippedItem(equipslots):HasTag("concheror") 
										and observer.components.inventory:GetEquippedItem(equipslots):HasTag("buffdeployed") then
											--nothing
										else
											--if v then
												--print("observer is: " .. observer.prefab .. " and scanned object is " .. v.prefab)
											--end
											if observer.components.locomotor then
												observer.components.locomotor:RemoveExternalSpeedMultiplier(observer, "concheror_speed_mod") 
											end
											inst:RemoveEventCallback("loseloyalty", SpeedRemoveOnLoyaltyLost)
											inst:RemoveEventCallback("attacked", SpeedRemoveOnLoyaltyLost)
										end
									end
							end)
						end
						if not v:HasTag("concherored") then
							v:AddTag("concherored")
						end
						
						local concherorfx = SpawnPrefab("concherorfx")
						
						if concherorfx then
							concherorfx.Transform:SetPosition(v.Transform:GetWorldPosition())
							concherorfx.Transform:SetScale(0.5, 0.5, 0.5)
							local followerfx = concherorfx.entity:AddFollower()
							followerfx:FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, 0, 0)
						end
					end
				end
				
			elseif inst.components.fueled and inst.components.fueled.currentfuel <= TUNING.CONCHEROR_TIME and inst.components.fueled.currentfuel > 0 and inst:HasTag("buffdeployed") then
				inst.components.fueled:MakeEmpty()
			elseif inst.components.fueled and inst.components.fueled.currentfuel <= 0 and inst:HasTag("buffdeployed") then
				inst:RemoveTag("buffdeployed")
	
				local owner = nil
				if inst.components.inventoryitem and inst.components.inventoryitem.owner then
					owner = inst.components.inventoryitem.owner
					owner.AnimState:ClearOverrideSymbol("swap_body")
					owner.AnimState:OverrideSymbol("swap_body", "swap_concheror", "swap_body")
				end		
				if owner and owner.components.locomotor then
					owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "concheror_speed_mod")
				end
				if owner and owner:HasTag("concherored") then
					owner:RemoveTag("concherored")
				end
				
				--- GOTTA FORCE THAT FREAKING SPEED BOOST REMOVAL ---
				ForceSpeedBoostRemoval(inst)
				-----------------------------------------------------
				
			end
		end
	end)
	
	MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab( "common/inventory/concheror", fn, assets) 