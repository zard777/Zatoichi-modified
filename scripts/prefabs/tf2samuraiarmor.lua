local assets=
{
	Asset("ANIM", "anim/tf2samuraiarmor.zip"),
	Asset("ANIM", "anim/tf2samuraiarmor_ground.zip"),
	
	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/tf2samuraiarmor.xml"),
    Asset("IMAGE", "images/inventoryimages/tf2samuraiarmor.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "tf2samuraiarmor", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function tf2samuraiarmor()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("torso_hawaiian")
    inst.AnimState:SetBuild("tf2samuraiarmor_ground")
    inst.AnimState:PlayAnimation("anim")
    
	--inst.foleysound = "dontstarve/movement/foley/logarmour"
	
	inst.entity:AddNetwork()
		
	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.entity:SetPristine()
	
	inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tf2samuraiarmor.xml"
	inst.components.inventoryitem.imagename = "tf2samuraiarmor"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = TUNING.TF2SAMURAIARMOR_SPEED_BONUS

	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.TF2SAMURAIARMOR_DURABILITY, TUNING.TF2SAMURAIARMOR_RESISTANCE)	
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	MakeHauntableLaunch(inst)
	
    return inst
end

	
return Prefab( "common/inventory/tf2samuraiarmor", tf2samuraiarmor, assets) 
