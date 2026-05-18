-- client/systems/skin_system.lua
-- FIX v1.2 :
--   • Race condition : le thread Wait(100) vérifie maintenant que le NPC est toujours
--     dans ActiveNPCs ET que son ped n'a pas changé avant d'appliquer le skin.

SkinSystem = {}

local FREEMODE_MODELS = {
    [`mp_m_freemode_01`] = true,
    [`mp_f_freemode_01`] = true,
}

local function IsFreemode(modelHash)
    return FREEMODE_MODELS[modelHash] == true
end

local function GetGender(modelHash)
    return modelHash == `mp_f_freemode_01` and "female" or "male"
end

local SkinPool = {
    male = {
        tops = {
            { drawable = 0,  textureRange = {0, 3}  },
            { drawable = 4,  textureRange = {0, 5}  },
            { drawable = 14, textureRange = {0, 4}  },
            { drawable = 21, textureRange = {0, 3}  },
            { drawable = 55, textureRange = {0, 5}  },
            { drawable = 61, textureRange = {0, 5}  },
        },
        bottoms = {
            { drawable = 0,  textureRange = {0, 6}  },
            { drawable = 4,  textureRange = {0, 4}  },
            { drawable = 14, textureRange = {0, 3}  },
            { drawable = 24, textureRange = {0, 4}  },
            { drawable = 36, textureRange = {0, 3}  },
        },
        shoes = {
            { drawable = 1,  texture = 0 },
            { drawable = 10, texture = 0 },
            { drawable = 24, texture = 0 },
            { drawable = 25, texture = 0 },
            { drawable = 34, texture = 0 },
        },
        hats = {
            nil,
            nil,
            { drawable = 1,  textureRange = {0, 4} },
            { drawable = 11, textureRange = {0, 3} },
            { drawable = 45, textureRange = {0, 2} },
        },
    },
    female = {
        tops = {
            { drawable = 0,  textureRange = {0, 5}  },
            { drawable = 5,  textureRange = {0, 4}  },
            { drawable = 10, textureRange = {0, 4}  },
            { drawable = 25, textureRange = {0, 3}  },
            { drawable = 34, textureRange = {0, 5}  },
            { drawable = 48, textureRange = {0, 4}  },
        },
        bottoms = {
            { drawable = 0,  textureRange = {0, 5}  },
            { drawable = 3,  textureRange = {0, 4}  },
            { drawable = 10, textureRange = {0, 3}  },
            { drawable = 15, textureRange = {0, 4}  },
            { drawable = 34, textureRange = {0, 3}  },
        },
        shoes = {
            { drawable = 1,  texture = 0 },
            { drawable = 3,  texture = 0 },
            { drawable = 10, texture = 0 },
            { drawable = 20, texture = 0 },
            { drawable = 27, texture = 0 },
        },
        hats = {
            nil,
            nil,
            { drawable = 1,  textureRange = {0, 4} },
            { drawable = 11, textureRange = {0, 3} },
        },
    },
}

local function ResolveComp(comp)
    if not comp then return nil end
    return {
        drawable = comp.drawable,
        texture  = comp.textureRange
            and math.random(comp.textureRange[1], comp.textureRange[2])
            or  comp.texture,
    }
end

local function PickRandom(tbl)
    return tbl[math.random(#tbl)]
end

local function BuildSkin(gender)
    local pool = SkinPool[gender] or SkinPool.male
    return {
        components = {
            [4]  = ResolveComp(PickRandom(pool.bottoms)),
            [6]  = ResolveComp(PickRandom(pool.shoes)),
            [11] = ResolveComp(PickRandom(pool.tops)),
        },
        props = {
            [0] = ResolveComp(PickRandom(pool.hats)),
        },
    }
end

function SkinSystem.Apply(ped, class, model, dbSkin)
    if not DoesEntityExist(ped) then return end

    local modelHash = model or GetEntityModel(ped)
    if not IsFreemode(modelHash) then return end

    local gender = GetGender(modelHash)
    local skin   = BuildSkin(gender)

    SetPedDefaultComponentVariation(ped)

    for compId, comp in pairs(skin.components) do
        if comp then
            SetPedComponentVariation(ped, compId, comp.drawable, comp.texture, 0)
        end
    end

    for propId, prop in pairs(skin.props) do
        if prop then
            SetPedPropIndex(ped, propId, prop.drawable, prop.texture, true)
        else
            ClearPedProp(ped, propId)
        end
    end
end

local _originalRegisterEntity = RegisterEntity

function RegisterEntity(ped, data)
    local npc = _originalRegisterEntity(ped, data)

    if npc then
        local savedId  = npc.id
        local savedPed = npc.ped

        CreateThread(function()
            Wait(100)
            -- FIX: vérifier que le NPC existe toujours ET que ce n'est pas un NPC recyclé
            local current = ActiveNPCs[savedId]
            if not current or current.ped ~= savedPed then return end
            if not DoesEntityExist(savedPed) then return end
            SkinSystem.Apply(savedPed, current.class, GetEntityModel(savedPed), current.skin)
        end)
    end

    return npc
end
