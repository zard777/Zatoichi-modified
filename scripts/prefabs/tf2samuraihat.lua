local assets =
{ 
    Asset("ANIM", "anim/tf2samuraihat.zip"),
    Asset("ANIM", "anim/tf2samuraihat_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/tf2samuraihat.xml"),
    Asset("IMAGE", "images/inventoryimages/tf2samuraihat.tex"),
}

local function OnEquip(inst, owner, data) 
    owner.AnimState:OverrideSymbol("swap_hat", "tf2samuraihat_swap", "swap_hat")
	
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Hide("HEAD")
	end

end


local function OnUnequip(inst, owner, data) 

    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tf2samuraihat")
    inst.AnimState:SetBuild("tf2samuraihat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("tf2samuraihat")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armor")
	inst.components.armor:InitCondition(TUNING.TF2SAMURAIHAT_DURABILITY, TUNING.TF2SAMURAIHAT_RESISTANCE)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tf2samuraihat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tf2samuraihat.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.walkspeedmult = TUNING.TF2SAMURAIHAT_SPEED_BONUS
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	

    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/tf2samuraihat", fn, assets)