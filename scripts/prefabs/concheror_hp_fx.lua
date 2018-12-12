local assets =
{
    Asset("ANIM", "anim/concheror_hp_fx.zip"),
}

local function PlayRingAnim(proxy)
    local inst = CreateEntity()
	
	local parent = proxy.entity:GetParent()
    if parent == nil then
        return
    end

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)
    
    inst.AnimState:SetBank("concheror_hp_fx")
    inst.AnimState:SetBuild("concheror_hp_fx")
    inst.AnimState:PlayAnimation("concheror_hp_fx")
	
    inst.AnimState:SetFinalOffset(-1)

    --inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    --inst.AnimState:SetLayer( LAYER_BACKGROUND )
    --inst.AnimState:SetSortOrder( 3 )

    inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("onremove", function() inst:Remove() end, proxy)
	
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayRingAnim)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
	
    return inst
end

return Prefab("concheror_hp_fx", fn, assets) 
