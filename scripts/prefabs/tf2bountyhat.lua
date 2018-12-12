local assets =
{ 
    Asset("ANIM", "anim/tf2bountyhat.zip"),
    Asset("ANIM", "anim/tf2bountyhat_swap.zip"), 
	
	Asset("ANIM", "anim/tf2bountyhat_open.zip"),
    Asset("ANIM", "anim/tf2bountyhat_open_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/tf2bountyhat.xml"),
    Asset("IMAGE", "images/inventoryimages/tf2bountyhat.tex"),
}

local function IsValidVictim(victim)
    return victim ~= nil
        and not (victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local function bountydrop(inst, data)
	local victim = data.victim
    if IsValidVictim(victim) then
		if victim.prefab == "crow" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "feather_crow", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "robin" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "feather_robin", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "robin_winter" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "feather_robin_winter", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "smallbird" or victim.prefab == "babybeefalo" or victim.prefab == "mole" or victim.prefab == "mole" then
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			
		elseif victim.prefab == "tallbird" or victim.prefab == "teenbird" or victim.prefab == "koalefant_summer" or victim.prefab == "koalefant_winter" or victim.prefab == "deerclops" or victim.prefab == "bearger" or victim.prefab == "minotaur" then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			
		elseif victim.prefab == "bat" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "batwing", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "bee" or victim.prefab == "killerbee" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "honey", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "stinger", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "butterfly" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "butterflywings", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "butter", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "beefalo" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "beefalowool", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif (victim.prefab == "bunnyman" or victim.prefab == "rabbit") and inst:HasTag("player") and inst.components.sanity:GetPercent() < 0.4 then
			if math.random() > .5 then -- TODO: Fix bunnyman/rabbit drop when low sanity
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "beardhair", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "bunnyman" and inst:HasTag("player") and inst.components.sanity:GetPercent() >= 0.4 then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "manrabbit_tail", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "rabbit" and inst:HasTag("player") and inst.components.sanity:GetPercent() >= 0.4 then
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
				
		elseif victim.prefab == "bishop" or victim.prefab == "knight" or victim.prefab == "rook" then
				victim.components.lootdropper:AddChanceLoot( "gears", TUNING.TF2BOUNTYHAT_CHANCE)
				
		elseif victim.prefab == "bishop_nightmare" or victim.prefab == "knight_nightmare" or victim.prefab == "rook_nightmare" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "thulecite_pieces", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "nightmarefuel", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "worm" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "wormlight", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "frog" then
				victim.components.lootdropper:AddChanceLoot( "froglegs", TUNING.TF2BOUNTYHAT_CHANCE)
		
		elseif victim.prefab == "perd" then
				victim.components.lootdropper:AddChanceLoot( "drumstick", TUNING.TF2BOUNTYHAT_CHANCE)
		
		elseif victim.prefab == "hound" or victim.prefab == "warg" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "houndstooth", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "firehound" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "redgem", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "houndstooth", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "icehound" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "bluegem", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "houndstooth", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "krampus" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "charcoal", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "krampus_sack", TUNING.TF2BOUNTYHAT_CHANCE) -- Hell yeah, baby!
			end
			
		elseif victim.prefab == "walrus" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "walrus_tusk", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "merm" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "fish", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "froglegs", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "lureplant" then
				victim.components.lootdropper:AddChanceLoot( "plantmeat", TUNING.TF2BOUNTYHAT_CHANCE)
				
		elseif victim.prefab == "mosquito" then
				victim.components.lootdropper:AddChanceLoot( "mosquitosack", TUNING.TF2BOUNTYHAT_CHANCE)
		
		elseif victim.prefab == "penguin" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "drumstick", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "pigman" or victim.prefab == "pigguard" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "pigskin", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "rocky" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "rocks", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "crawlinghorror" or victim.prefab == "crawlingnightmare" or victim.prefab == "terrorbeak" or victim.prefab == "nightmarebeak" then
				victim.components.lootdropper:AddChanceLoot( "nightmarefuel", TUNING.TF2BOUNTYHAT_CHANCE)
				
		elseif victim.prefab == "slurper" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "lightbulb", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "slurper_pelt", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "slurtle" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "slurtle_shellpieces", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "slurtlehat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "snurtle" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "slurtle_shellpieces", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "armorsnurtleshell", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "monkey" and not victim:HasTag("nightmare") then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "cave_banana", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "monkey" and victim:HasTag("nightmare") then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "cave_banana", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "beardhair", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "spider" or victim.prefab == "spider_warrior" or victim.prefab == "spider_hider" or victim.prefab == "spider_spitter" or victim.prefab == "spider_dropper" or victim.prefab == "spiderqueen" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "silk", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "tentacle" or victim.prefab == "tentacle_pillar" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "tentaclespots", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "tentaclespike", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "leif" or victim.prefab == "leif_sparse" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "livinglog", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "buzzard" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "smallmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "drumstick", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "catcoon" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "coontail", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "glommer" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "monstermeat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "glommerfuel", TUNING.TF2BOUNTYHAT_CHANCE)
			end
			
		elseif victim.prefab == "moose" or victim.prefab == "mossling" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "drumstick", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "goose_feather", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "lightninggoat" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "lightninggoathorn", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "spat" then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "steelwool", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "grassgekko" and not victim:HasTag("diseased") then
			if math.random() > .5 then
				victim.components.lootdropper:AddChanceLoot( "cutgrass", TUNING.TF2BOUNTYHAT_CHANCE)
			else
				victim.components.lootdropper:AddChanceLoot( "plantmeat", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		elseif victim.prefab == "grassgekko" and victim:HasTag("diseased") then
			victim.components.lootdropper:AddChanceLoot( "spoiled_food", TUNING.TF2BOUNTYHAT_CHANCE)
		
		elseif victim.prefab == "dragonfly" then
			if math.random() > .5 then -- DRAGON TABLE
				victim.components.lootdropper:AddChanceLoot( "dragon_scales", TUNING.TF2BOUNTYHAT_CHANCE)
				victim.components.lootdropper:AddChanceLoot( "lavae_egg", TUNING.TF2BOUNTYHAT_CHANCE)
				victim.components.lootdropper:AddChanceLoot( "meat", TUNING.TF2BOUNTYHAT_CHANCE)
			else -- GEMS TABLE
				victim.components.lootdropper:AddChanceLoot( "purplegem", TUNING.TF2BOUNTYHAT_CHANCE)
				victim.components.lootdropper:AddChanceLoot( "orangegem", TUNING.TF2BOUNTYHAT_CHANCE)
				victim.components.lootdropper:AddChanceLoot( "yellowgem", TUNING.TF2BOUNTYHAT_CHANCE)
				victim.components.lootdropper:AddChanceLoot( "greengem", TUNING.TF2BOUNTYHAT_CHANCE)
			end
		
		end
	end
end

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
	
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then
		owner.AnimState:Hide("HEAD")
		owner.AnimState:Show("HEAD_HAT")
	end
	
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
	
	if owner then
		owner:ListenForEvent("killed", bountydrop)
	end
	
	if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
	
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
	
	if owner then
		owner:RemoveEventCallback("killed", bountydrop)
	end
	
	if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function OnOpen(inst, doer)
    if inst.components.inventoryitem and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("player") then
		inst.components.inventoryitem.owner.sg:GoToState("openbountyhat")
		inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_open_swap", "swap_hat")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end
end

local function OnClose(inst)
	if inst.components.inventoryitem and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("player") then
		inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_hat", "tf2bountyhat_swap", "swap_hat")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	end
end

---

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

local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tf2bountyhat")
    inst.AnimState:SetBuild("tf2bountyhat")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("tf2bountyhat")
	inst:AddTag("backpack")
	inst:AddTag("waterproofer")
	
	inst.entity:SetPristine()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tf2bountyhat.tex")
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tf2bountyhat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tf2bountyhat.xml"
	inst.components.inventoryitem.cangoincontainer = false
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("container")
    inst.components.container:WidgetSetup("treasurechest")
	
	inst:AddComponent("lootdropper")
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
    MakeHauntableLaunch(inst)
	
	inst:ListenForEvent("onopen", OnOpen)
	inst:ListenForEvent("onclose", OnClose)
	
    return inst
end

return  Prefab("common/inventory/tf2bountyhat", fn, assets)