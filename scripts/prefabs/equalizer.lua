local assets =
{
	-- Animation files used for the item.
	Asset("ANIM", "anim/equalizer.zip"),
	Asset("ANIM", "anim/swap_equalizer.zip"),

	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/equalizer.xml"),
    Asset("IMAGE", "images/inventoryimages/equalizer.tex"),
}

local function onsanitydeltaeq(inst, data)
	if data.newpercent ~= nil and data.oldpercent ~= nil and data.newpercent > data.oldpercent then
		data.newpercent = data.oldpercent
		inst.components.sanity:SetPercent(data.oldpercent)
		inst.components.sanity.rate = 0
        inst.components.sanity.ratescale = RATE_SCALE.NEUTRAL
	end
end

local function SetSpeedEqualizer(inst) -- from 1 to 1.6
	if inst.components.health and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("equalizer") then
		local owner_health_max = inst.components.health.maxhealth
		local owner_health_current = inst.components.health.currenthealth
		
		local speedmult = ((((owner_health_max - owner_health_current)/owner_health_max)*TUNING.EQUALIZER_MAX_SPD)+ 1)*100 -- *100 to get 2 numbers after the point
		
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.equippable.walkspeedmult = (math.floor(speedmult))*0.01 -- math.floor to avoid crashes
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.weapon:SetDamage((((owner_health_max - owner_health_current)/owner_health_max)*TUNING.EQUALIZER_MAX_DMG)+ TUNING.EQUALIZER_MIN_DMG)
		
	end
end

local function onremove(inst)
	if inst.equalizer_fx ~= nil then
		inst.equalizer_fx:Remove()
		inst.equalizer_fx = nil
	end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_equalizer","swap_pickaxe")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	
	if owner and owner.components.health then
		owner:ListenForEvent("healthdelta", SetSpeedEqualizer)
		
		local owner_health_max = owner.components.health.maxhealth
		local owner_health_current = owner.components.health.currenthealth
		
		local speedmult = (((((owner_health_max - owner_health_current)/owner_health_max)*TUNING.EQUALIZER_MAX_SPD)+ 1))*100 -- *100 to get 2 numbers after the point
		
		inst.components.equippable.walkspeedmult = (math.floor(speedmult))*0.01 -- math.floor to avoid crashes
		inst.components.weapon:SetDamage((((owner_health_max - owner_health_current)/owner_health_max)*TUNING.EQUALIZER_MAX_DMG)+ TUNING.EQUALIZER_MIN_DMG)
	end
	
	inst.equalizer_fx = SpawnPrefab("equalizer_fx")
	inst.equalizer_fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
	inst.equalizer_fx.entity:SetParent(owner.entity)
				
	local follow_eq_fx = inst.equalizer_fx.entity:AddFollower()
	follow_eq_fx:FollowSymbol(owner.GUID, owner.components.combat.hiteffectsymbol, 0, 0, 0)
				
	inst.equalizer_fx:ListenForEvent("onremove", onremove, owner)
	inst.equalizer_fx:ListenForEvent("death", onremove, owner)
	
	if owner then
		owner:AddTag("equalized")
		if owner.components.sanity and owner.components.sanity.rate ~= nil and owner.components.sanity.ratescale ~= nil then
			inst.ownerrate = owner.components.sanity.rate
			inst.ownerratescale = owner.components.sanity.ratescale
		end
		owner:ListenForEvent("sanitydelta", onsanitydeltaeq)
	end
	
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
	
	if owner then
		owner:RemoveEventCallback("healthdelta", SetSpeedEqualizer)
		owner:RemoveEventCallback("sanitydelta", onsanitydeltaeq)
	end
	
	inst.components.equippable.walkspeedmult = 1
	inst.components.weapon:SetDamage(TUNING.EQUALIZER_MIN_DMG)
	
	onremove(inst)
	
	if owner and owner:HasTag("equalized") then
		owner:RemoveTag("equalized")
	end
	
	if owner then
		if owner.components.sanity and inst.ownerrate ~= nil and inst.ownerratescale ~= nil then
			owner.components.sanity.rate = inst.ownerrate
			owner.components.sanity.ratescale = inst.ownerratescale
		end
	end
end

local function init()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("equalizer")
    inst.AnimState:SetBuild("equalizer")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("equalizer")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst.ownerrate = nil
	inst.ownerratescale = nil
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.EQUALIZER_MIN_DMG)

	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.EQUALIZER_USES)
    inst.components.finiteuses:SetUses(TUNING.EQUALIZER_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, TUNING.EQUALIZER_CONSUMPTION)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/equalizer.xml"
    inst.components.inventoryitem.imagename = "equalizer"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1
	
    MakeHauntableLaunch(inst)
    
    return inst
end

return Prefab("common/inventory/equalizer", init, assets)