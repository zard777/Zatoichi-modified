local assets =
{
	-- Sound files used by the item.
	Asset("SOUNDPACKAGE", "sound/tf2warsounds.fev"),
	Asset("SOUND", "sound/tf2warsounds.fsb"),

	-- Animation files used for the item.
	Asset("ANIM", "anim/half_zatoichi.zip"),
	Asset("ANIM", "anim/swap_half_zatoichi.zip"),
	Asset("ANIM", "anim/swap_half_zatoichi_bloody_3.zip"),

	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/half_zatoichi.xml"),
    Asset("IMAGE", "images/inventoryimages/half_zatoichi.tex"),
	Asset("ATLAS", "images/inventoryimages/half_zatoichi_bloody_3.xml"),
    Asset("IMAGE", "images/inventoryimages/half_zatoichi_bloody_3.tex"),
}

local function SetZatoichiBlood(inst)
	--print("it's " .. inst.prefab .. ".")
	if inst.components.equippable and inst.components.equippable:IsEquipped() then
		local owner = inst.components.inventoryitem.owner
		if inst.bloody ~= nil then
			owner.AnimState:OverrideSymbol("swap_object", "swap_half_zatoichi_bloody_3","swap_half_zatoichi_bloody_3")
		else
			owner.AnimState:OverrideSymbol("swap_object", "swap_half_zatoichi","swap_half_zatoichi")
		end
	end
	
	if inst.bloody ~= nil then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/half_zatoichi_bloody_3.xml"
		inst.components.inventoryitem:ChangeImageName("half_zatoichi_bloody_3")
	else
		inst.components.inventoryitem.atlasname = "images/inventoryimages/half_zatoichi.xml"
		inst.components.inventoryitem:ChangeImageName("half_zatoichi")
	end
end

local function ZatoichiSlice(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_zatoichi")
	
	if inst.components.inventoryitem.owner ~= nil and inst.components.inventoryitem.owner.components.combat ~= nil 
	and inst.components.inventoryitem.owner.components.combat.target ~= nil 
	and inst.components.inventoryitem.owner.components.combat.target:HasTag("half_zatoichied") then
		inst.components.inventoryitem.owner.components.combat.target:PushEvent("death") -- insta-kill if enemy has a Half-Zatoichi equipped
	end
end

local function IsValidVictim(victim)
    return victim ~= nil
        and not (--not victim:HasTag("hostile") or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
				victim:HasTag("butterfly") or
				victim:HasTag("stickybomb") or
				victim:HasTag("quickiebomb") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local function onkillzatoichi(inst, data)
	local victim = data.victim
	
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)~= nil 
	and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("half_zatoichi") 
	and IsValidVictim(victim) then
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).bloody = true
		local inst = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		SetZatoichiBlood(inst)
	end
	
	
	if inst.components.health and IsValidVictim(victim) and victim.components.health ~= nil then
		-- inst.components.health:DoDelta(victim.components.health.maxhealth*TUNING.HALF_ZATOICHI_DRAIN_MULT)
	   inst.components.health:SetMaxHealth(inst.components.health.currenthealth+(victim.components.health.maxhealth*TUNING.HALF_ZATOICHI_DRAIN_MULT))
	end
end

local function onequip(inst, owner) 
    SetZatoichiBlood(inst)
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	
	owner:AddTag("half_zatoichied")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/draw_zatoichi")
	
	owner:ListenForEvent("killed", onkillzatoichi)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
	
	owner:RemoveTag("half_zatoichied")
	
	owner:RemoveEventCallback("killed", onkillzatoichi)
	
	if inst.bloody == nil or inst.bloody == 0 then
		owner:DoTaskInTime(0, function() 
			if not owner:HasTag("playerghost") and not owner:HasTag("INLIMBO") and
			owner.components.health ~= nil and not owner.components.health:IsDead() then
				if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)~= nil 
				and (owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab ~= "half_zatoichi" 
				or owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "half_zatoichi" and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).bloody ~= nil
				and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).bloody ~= 0) then
					local otheritem = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					owner.components.inventory:DropItem(otheritem)
				end
				if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil 
				or (owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil 
				and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab ~= "half_zatoichi") 
				or (owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil 
				and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "half_zatoichi"
				and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).bloody ~= nil) then
					owner.components.inventory:Equip(inst)
					if owner.components.talker and inst.components.finiteuses and inst.components.finiteuses.current > 0 then
						owner.components.talker:Say(GetString(owner, "ANNOUNCE_HONORBOUND"))
					end
				end
			end
		end)
	end
	
	inst.bloody = nil
	SetZatoichiBlood(inst)
end

local function onsave(inst, data)
	if data and inst.bloody ~= nil then
		data.bloody = inst.bloody
	end
end

local function onpreload(inst, data)
	if data and data.bloody ~= nil then
		inst.bloody = data.bloody
	end
end

local function onload(inst, data)
	if inst.bloody ~= nil then
		SetZatoichiBlood(inst)
	end
end

local function init()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("half_zatoichi")
    inst.AnimState:SetBuild("half_zatoichi")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("half_zatoichi")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.bloody = nil
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HALF_ZATOICHI_DAMAGE)
	inst.components.weapon:SetOnAttack(ZatoichiSlice)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HALF_ZATOICHI_USES)
    inst.components.finiteuses:SetUses(TUNING.HALF_ZATOICHI_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/half_zatoichi.xml"
    inst.components.inventoryitem.imagename = "half_zatoichi"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    MakeHauntableLaunch(inst)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
    
    return inst
end

return Prefab("common/inventory/half_zatoichi", init, assets)