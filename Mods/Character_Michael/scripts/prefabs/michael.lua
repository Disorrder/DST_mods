local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset( "ANIM", "anim/player_basic.zip" ),
    Asset( "ANIM", "anim/player_idles_shiver.zip" ),
    Asset( "ANIM", "anim/player_actions.zip" ),
    Asset( "ANIM", "anim/player_actions_axe.zip" ),
    Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
    Asset( "ANIM", "anim/player_actions_shovel.zip" ),
    Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
    Asset( "ANIM", "anim/player_actions_eat.zip" ),
    Asset( "ANIM", "anim/player_actions_item.zip" ),
    Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
    Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
    Asset( "ANIM", "anim/player_actions_fishing.zip" ),
    Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
    Asset( "ANIM", "anim/player_bush_hat.zip" ),
    Asset( "ANIM", "anim/player_attacks.zip" ),
    Asset( "ANIM", "anim/michael.zip" ),
    Asset( "ANIM", "anim/player_rebirth.zip" ),
    Asset( "ANIM", "anim/player_jump.zip" ),
    Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
    Asset( "ANIM", "anim/player_teleport.zip" ),
    Asset( "ANIM", "anim/wilson_fx.zip" ),
    Asset( "ANIM", "anim/player_one_man_band.zip" ),
    Asset( "ANIM", "anim/shadow_hands.zip" ),
    Asset( "SOUND", "sound/sfx.fsb" ),
    Asset( "SOUND", "sound/wilson.fsb" ),
    Asset( "ANIM", "anim/beard.zip" ),

    Asset( "ANIM", "anim/ghost_michael_build.zip" ),
}
local prefabs = {
    "bee",
    "honey"
}
local start_inv = {
    -- Custom starting items
    "armorwood",
    "spear",
    "pickaxe",
    "shovel"
}

-- This initializes for both clients and the host
local common_postinit = function(inst) 
    -- Minimap icon
    inst.MiniMapEntity:SetIcon( "michael.tex" )
end

---- HELPERS ----
function giveItem(inst, name, val)
    if not val then val = 1 end
    for i=1, val, 1 do
        local newBee = GLOBAL.SpawnPrefab(name)
        inst.components.inventory:GiveItem(newBee)
    end
end

----  POSTINIT  ----
local function onEat(inst, food)
    if food and food.components.edible then
        local ds = food.components.edible:GetSanity(inst) -- delta sanity
        print("michael is eating ", food.prefab, ". Food sanity is ", ds)
        if food.prefab == "honey" or food.prefab == "berries" then -- bear likes this
            if ds == 0 then ds = 1 end
            print("Like food! Increase sanity by ", ds)
            inst.components.sanity:DoDelta(ds)
        elseif food.prefab:find("_cap") then -- and dislikes this
            print("Ate shroom!")
            if ds > 0 then 
                print("Dislike food! Decrease sanity by ", ds)
                inst.components.sanity:DoDelta(-ds) 
            end
        end
    end
end
-- This initializes for the host only
local master_postinit = function(inst)
    inst.soundsname = "wolfgang"
    -- Stats    
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(200)

    inst:AddTag("michael")

    --inst.components.combat:SetKeepTargetFunction(keepTargetFn)
    inst.components.eater:SetOnEatFn(onEat)
end

return MakePlayerCharacter("michael", prefabs, assets, common_postinit, master_postinit, start_inv)
