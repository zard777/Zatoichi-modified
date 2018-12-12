local assets =
{
	-- Sound files used by the item.
	Asset("SOUNDPACKAGE", "sound/tf2warsounds.fev"),
	Asset("SOUND", "sound/tf2warsounds.fsb"),

	-- Animation files used for the item.
	Asset("ANIM", "anim/quickiebomb.zip"),
	Asset("ANIM", "anim/quickiebomb_demo.zip"),

	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/quickiebomb.xml"),
    Asset("IMAGE", "images/inventoryimages/quickiebomb.tex"),
	
}

local function OnExplodeFn(inst)
    inst.SoundEmitter:PlaySound("tf2warsounds/tf2warsounds/quickiebomb_explode")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.homeseeker.home.components.childspawner:OnChildKilled(inst) -- remove sticky from the table, otherwise it may bug out after some time
end

local function onremove(inst)
	if inst.quickiemeter ~= nil then
		inst.quickiemeter:Remove()
		inst.quickiemeter = nil
	end
end

local function init()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quickiebomb")
    inst.AnimState:SetBuild("quickiebomb")
    inst.AnimState:PlayAnimation("swap_crit_buzz", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(255/255, 0/255, 0/255)
    inst.Light:Enable(true)

	inst:AddTag("quickiebomb")
	inst:AddTag("criticalhit")
	
	--inst.AnimState:SetClientsideBuildOverride("demoman", "quickiebomb", "quickiebomb_demo") -- Clientside build override
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quickiebomb.tex")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.QUCKIE_DAMAGE*2
	inst.components.explosive.range = 5
	inst.components.explosive.lightonexplode = false
	
	inst:AddComponent("health")
	inst.components.health.maxhealth = 1
	inst.components.health.currenthealth = 1
	
	inst:AddComponent("combat")
    
	inst.iscritsticky = false
	inst.quickietimer = TUNING.QUICKIE_LIFE_TIME
	inst.quickiemeter = nil
	
	inst:DoTaskInTime(0, function() 
		if not inst.components.homeseeker then
			onremove(inst)
			inst:Remove()
		end 
		
		if inst.components.homeseeker and inst.quickiemeter == nil then
			inst.quickiemeter = SpawnPrefab("quickiebomb_meter")
			inst.quickiemeter.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.quickiemeter.entity:SetParent(inst.entity)
			inst.quickiemeter:ListenForEvent("onremove", onremove, inst)
		end
	end)
	
	inst:DoPeriodicTask(1, function()
		if not inst.components.homeseeker and inst.components.health.currenthealth > 0 then 
			inst.components.health:DoDelta(-1)
		end
		
		if inst.quickietimer > 0 then
			inst.quickietimer = inst.quickietimer - 1
			--if inst.components.explosive then
			--	inst.components.explosive.explosivedamage = inst.components.explosive.explosivedamage - 2
			--end
		else
			if inst.components.homeseeker then
				inst.components.homeseeker.home.components.childspawner:OnChildKilled(inst) -- remove sticky from the table, otherwise it may bug out after some time
			end
			if inst and inst.components.health.currenthealth > 0 then
				local fx = SpawnPrefab("small_puff")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				fx.Transform:SetScale(0.6, 0.6, 0.6)
			end
			
			onremove(inst)
			
			inst:Remove()
		end
	end)
	
	inst:ListenForEvent("minhealth", function() 
		inst.AnimState:PlayAnimation("destroyed")
		if inst.components.homeseeker then
			inst.components.homeseeker.home.components.childspawner:OnChildKilled(inst) -- remove sticky from the table, otherwise it may bug out after some time
			onremove(inst)
		end
	end)
	
    --MakeHauntableLaunch(inst) -- Haunting should have no effect on the stickybomb
	
    return inst
end

return Prefab("common/inventory/quickiebomb_crit", init, assets)