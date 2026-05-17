-- client/systems/skin_system.lua
-- v1.3 : uniquement mp_m_freemode_01 & mp_f_freemode_01
-- Chaque NPC reçoit un skin aléatoire parmi un pool limité mais varié
-- pour éviter que tout le monde soit habillé pareil sans non plus
-- avoir 500 combinaisons incontrôlables.

SkinSystem = {}

-- Seuls ces deux modèles sont utilisés dans tout le projet
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

-- ==============================================================
-- POOL DE SKINS
-- Principe : on sépare les pièces en catégories indépendantes
-- (hauts, bas, chaussures) et on les combine aléatoirement.
-- Ça donne beaucoup de variété avec peu de valeurs.
-- textureRange = {min, max} résolu au spawn.
-- ==============================================================

local SkinPool = {
    male = {
        -- Hauts (composant 11 = torso/haut du corps)
        tops = {
            { drawable = 0,  textureRange = {0, 3}  }, -- tshirt basique
            { drawable = 4,  textureRange = {0, 5}  }, -- chemise
            { drawable = 14, textureRange = {0, 4}  }, -- hoodie
            { drawable = 21, textureRange = {0, 3}  }, -- veste légère
            { drawable = 55, textureRange = {0, 5}  }, -- veste casual
            { drawable = 61, textureRange = {0, 5}  }, -- blouson
        },
        -- Bas (composant 4 = jambes)
        bottoms = {
            { drawable = 0,  textureRange = {0, 6}  }, -- jean basique
            { drawable = 4,  textureRange = {0, 4}  }, -- chino
            { drawable = 14, textureRange = {0, 3}  }, -- cargo
            { drawable = 24, textureRange = {0, 4}  }, -- slim
            { drawable = 36, textureRange = {0, 3}  }, -- short
        },
        -- Chaussures (composant 6)
        shoes = {
            { drawable = 1,  texture = 0 }, -- baskets blanches
            { drawable = 10, texture = 0 }, -- sneakers
            { drawable = 24, texture = 0 }, -- boots
            { drawable = 25, texture = 0 }, -- chaussures casual
            { drawable = 34, texture = 0 }, -- chaussures de ville
        },
        -- Accessoires tête (prop 0) — optionnel, 40% de chance
        hats = {
            nil,                                          -- pas de chapeau
            nil,                                          -- pas de chapeau (poids double)
            { drawable = 1,  textureRange = {0, 4} },    -- casquette
            { drawable = 11, textureRange = {0, 3} },    -- bonnet
            { drawable = 45, textureRange = {0, 2} },    -- bob
        },
    },
    female = {
        tops = {
            { drawable = 0,  textureRange = {0, 5}  }, -- débardeur
            { drawable = 5,  textureRange = {0, 4}  }, -- top court
            { drawable = 10, textureRange = {0, 4}  }, -- chemisier
            { drawable = 25, textureRange = {0, 3}  }, -- pull
            { drawable = 34, textureRange = {0, 5}  }, -- veste
            { drawable = 48, textureRange = {0, 4}  }, -- hoodie
        },
        bottoms = {
            { drawable = 0,  textureRange = {0, 5}  }, -- jean
            { drawable = 3,  textureRange = {0, 4}  }, -- short
            { drawable = 10, textureRange = {0, 3}  }, -- jupe
            { drawable = 15, textureRange = {0, 4}  }, -- legging
            { drawable = 34, textureRange = {0, 3}  }, -- pantalon taille haute
        },
        shoes = {
            { drawable = 1,  texture = 0 }, -- baskets
            { drawable = 3,  texture = 0 }, -- sandales
            { drawable = 10, texture = 0 }, -- boots
            { drawable = 20, texture = 0 }, -- chaussures plates
            { drawable = 27, texture = 0 }, -- sneakers
        },
        hats = {
            nil,
            nil,
            { drawable = 1,  textureRange = {0, 4} },
            { drawable = 11, textureRange = {0, 3} },
        },
    },
}

-- ==============================================================
-- UTILS
-- ==============================================================

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

-- Construit un skin complet en combinant les pièces aléatoirement
local function BuildSkin(gender)
    local pool = SkinPool[gender] or SkinPool.male

    local top    = ResolveComp(PickRandom(pool.tops))
    local bottom = ResolveComp(PickRandom(pool.bottoms))
    local shoes  = ResolveComp(PickRandom(pool.shoes))
    local hat    = ResolveComp(PickRandom(pool.hats)) -- peut être nil

    return {
        components = {
            [4]  = bottom,
            [6]  = shoes,
            [11] = top,
        },
        props = {
            [0] = hat,
        },
    }
end

-- ==============================================================
-- APPLY
-- ==============================================================

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

-- ==============================================================
-- SPAWN HOOK
-- ==============================================================

local _originalRegisterEntity = RegisterEntity

function RegisterEntity(ped, data)
    local npc = _originalRegisterEntity(ped, data)

    if npc then
        CreateThread(function()
            Wait(100)
            if DoesEntityExist(npc.ped) then
                SkinSystem.Apply(npc.ped, npc.class, GetEntityModel(npc.ped), npc.skin)
            end
        end)
    end

    return npc
end
