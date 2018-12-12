local assets =
{
	-- Sound files used by the item.
	Asset("SOUNDPACKAGE", "sound/tf2warsounds.fev"),
	Asset("SOUND", "sound/tf2warsounds.fsb"),
	
	-- Animation files used for the item.
	Asset("ANIM", "anim/ullapool_caber.zip"),
	Asset("ANIM", "anim/swap_ullapool_caber.zip"),
	
	Asset("ANIM", "anim/ullapool_caber_dud.zip"),
	Asset("ANIM", "anim/swap_ullapool_caber_dud.zip"),

	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/ullapool_caber.xml"),
    Asset("IMAGE", "images/inventoryimages/ullapool_caber.tex"),
	
	Asset("ATLAS", "images/inventoryimages/ullapool_caber_dud.xml"),
    Asset("IMAGE", "images/inventoryimages/ullapool_caber_dud.tex"),
}

local function MakeDud(inst)
	if inst.components.explosive then
		inst:RemoveComponent("explosive")
	end
	if inst.components.complexprojectile then
		inst:RemoveComponent("complexprojectile")
	end
	if inst:HasTag("caber_throwable") then
		inst:RemoveTag("caber_throwable")
	end
	if inst:HasTag("projectile") then
		inst:RemoveTag("projectile")
	end
	if not inst.components.fuel then
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
	end
	if not inst.components.weapon then
		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(17)
	end
	if not inst.components.finiteuses then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(10)
		inst.components.finiteuses:SetUses(10)
		inst.components.finiteuses:SetOnFinished(inst.Remove)
	end
	if not inst.components.tool then
		inst:AddComponent("tool") -- to trigger 'break' animation
	end
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ullapool_caber_dud.xml"
	inst.components.inventoryitem:ChangeImageName("ullapool_caber_dud")
	
	inst.AnimState:SetBank("ullapool_caber_dud")
    inst.AnimState:SetBuild("ullapool_caber_dud")
    inst.AnimState:PlayAnimation("swap")
	
	if inst.components.equippable and inst.components.equippable:IsEquipped() 
	and inst.components.inventoryitem and inst.components.inventoryitem.owner then
		local owner = inst.components.inventoryitem.owner
		owner.AnimState:OverrideSymbol("swap_object", "swap_ullapool_caber_dud", "swap_ullapool_caber_dud")
	end
	
	inst.iscaberdud = true
end

local function ExplodeCaber(inst)
	local owner = nil
	local target = nil
	if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.components.combat and inst.components.inventoryitem.owner.components.combat.target then
		owner = inst.components.inventoryitem.owner
		target = owner.components.combat.target
		SpawnPrefab("explode_small").Transform:SetPosition(target.Transform:GetWorldPosition())
		if target.SoundEmitter then
			target.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/caber_explosion")
		else
			inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/caber_explosion")
		end
	else
		SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/caber_explosion")
	end
	
	--Change into a dud (if not thrown)
	if inst.components.equippable:IsEquipped() then
		MakeDud(inst)
	end
end

local function ForceExplosion(inst)
	if inst.components.explosive then
		inst.components.explosive:OnBurnt()
	end
end

local function ForceExplosionOwner(owner, data)
	local inst = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if inst.components.explosive then
		inst.components.explosive:OnBurnt()
	end
end

local function onequip(inst, owner) 
	if inst.iscaberdud == nil then
		owner.AnimState:OverrideSymbol("swap_object", "swap_ullapool_caber", "swap_ullapool_caber")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_ullapool_caber_dud", "swap_ullapool_caber_dud")
	end
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
	
	inst:ListenForEvent("onhitother", ForceExplosionOwner, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
	
	inst:RemoveEventCallback("onhitother", ForceExplosionOwner, owner)
end

local function OnHitCaber(inst, attacker, target)
    ForceExplosion(inst)
	
    inst:Remove()
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
	
	inst:AddTag("caber_thrown")

    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local x, y, z
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        x, y, z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(x, y, z) then
            return Vector3(x, y, z)
        end
    end
    return Vector3(x, y, z)
end

local function getstatus(inst, viewer)
    return inst.iscaberdud == true and "DUD" or nil
end

local function onsave(inst, data)
	if data and inst.iscaberdud ~= nil then
		data.iscaberdud = inst.iscaberdud
	end
end

local function onpreload(inst, data)
	if data and data.iscaberdud ~= nil then
		inst.iscaberdud = data.iscaberdud
	end
end

local function onload(inst, data)
	if inst.iscaberdud ~= nil then
		MakeDud(inst)
	end
end

local function init()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ullapool_caber")
    inst.AnimState:SetBuild("ullapool_caber")
    inst.AnimState:PlayAnimation("swap")

	inst:AddTag("nopunch")
	inst:AddTag("projectile")
	inst:AddTag("caber")
	inst:AddTag("caber_throwable")
	
	inst.entity:SetPristine()
	
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(ExplodeCaber)
    inst.components.explosive.explosivedamage = TUNING.ULLAPOOL_CABER_DAMAGE -- default 200
	inst.components.explosive.range = 6
	inst.components.explosive.lightonexplode = false
	
    --inst:AddComponent("weapon")
    --inst.components.weapon:SetDamage(0) -- Explosion will deal damage
	--inst.components.weapon.attackrange = nil
	inst:AddComponent("ullapoolhitter")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ullapool_caber.xml"
    inst.components.inventoryitem.imagename = "ullapool_caber"
    
	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitCaber)
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
	inst.iscaberdud = nil
	
	inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
	
	MakeHauntableLaunch(inst)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
	
    return inst
end

return Prefab("common/inventory/ullapool_caber", init, assets)