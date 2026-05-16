-- client/systems/skin_system.lua
-- Applique un skin visuel sur les peds freemode selon leur classe
-- + support SQL override (skin DB)

SkinSystem = {}

-- ==============================================================
-- SKINS CONFIG
-- ==============================================================

local Skins = {

    civil = {
        male = {
            {
                components = {
                    [4]  = { drawable = 61,  texture = math.random(0, 5) },
                    [6]  = { drawable = 24,  texture = 0 },
                    [8]  = { drawable = 57,  texture = math.random(0, 8) },
                    [11] = { drawable = 0,   texture = 0 },
                },
                props = {
                    [0] = nil,
                },
            },
            {
                components = {
                    [4]  = { drawable = 21,  texture = math.random(0, 3) },
                    [6]  = { drawable = 25,  texture = 0 },
                    [8]  = { drawable = 0,   texture = 0 },
                    [11] = { drawable = 55,  texture = math.random(0, 4) },
                },
                props = {},
            },
        },
        female = {
            {
                components = {
                    [4]  = { drawable = 34,  texture = math.random(0, 5) },
                    [6]  = { drawable = 35,  texture = 0 },
                    [8]  = { drawable = 5,   texture = math.random(0, 6) },
                    [11] = { drawable = 0,   texture = 0 },
                },
                props = {},
            },
        },
    },

    guard = {
        male = {
            {
                components = {
                    [3]  = { drawable = 4,  texture = 0 },
                    [4]  = { drawable = 24, texture = 0 },
                    [6]  = { drawable = 25, texture = 0 },
                    [8]  = { drawable = 58, texture = 0 },
                    [11] = { drawable = 55, texture = 0 },
                },
                props = {
                    [0] = { drawable = 45, texture = 0 },
                },
            },
        },
        female = {
            {
                components = {
                    [4]  = { drawable = 24, texture = 0 },
                    [6]  = { drawable = 25, texture = 0 },
                    [8]  = { drawable = 58, texture = 0 },
                    [11] = { drawable = 55, texture = 0 },
                },
                props = {
                    [0] = { drawable = 45, texture = 0 },
                },
            },
        },
    },

    gang = {
        male = {
            {
                components = {
                    [4]  = { drawable = 21, texture = 1 },
                    [6]  = { drawable = 24, texture = 0 },
                    [8]  = { drawable = 15, texture = math.random(0, 3) },
                    [11] = { drawable = 15, texture = math.random(0, 5) },
                },
                props = {
                    [0] = { drawable = 11, texture = 0 },
                },
            },
            {
                components = {
                    [4]  = { drawable = 61, texture = 3 },
                    [6]  = { drawable = 36, texture = 0 },
                    [8]  = { drawable = 0,  texture = 0 },
                    [11] = { drawable = 55, texture = 5 },
                },
                props = {
                    [0] = { drawable = 11, texture = 1 },
                },
            },
        },
        female = {
            {
                components = {
                    [4]  = { drawable = 3, texture = math.random(0, 4) },
                    [6]  = { drawable = 36, texture = 0 },
                    [8]  = { drawable = 5, texture = 3 },
                    [11] = { drawable = 15, texture = 2 },
                },
                props = {},
            },
        },
    },

    dealer = {
        male = {
            {
                components = {
                    [4]  = { drawable = 61, texture = 0 },
                    [6]  = { drawable = 24, texture = 0 },
                    [8]  = { drawable = 0,  texture = 0 },
                    [11] = { drawable = 249, texture = 0 },
                },
                props = {},
            },
        },
        female = {
            {
                components = {
                    [4]  = { drawable = 34, texture = 0 },
                    [6]  = { drawable = 35, texture = 0 },
                    [8]  = { drawable = 5,  texture = 0 },
                    [11] = { drawable = 249, texture = 0 },
                },
                props = {},
            },
        },
    },

    medic = {
        male = {
            {
                components = {
                    [4]  = { drawable = 25, texture = 0 },
                    [6]  = { drawable = 25, texture = 0 },
                    [8]  = { drawable = 57, texture = 0 },
                    [11] = { drawable = 55, texture = 0 },
                },
                props = {},
            },
        },
        female = {
            {
                components = {
                    [4]  = { drawable = 25, texture = 0 },
                    [6]  = { drawable = 25, texture = 0 },
                    [8]  = { drawable = 57, texture = 0 },
                    [11] = { drawable = 55, texture = 0 },
                },
                props = {},
            },
        },
    },
}

-- ==============================================================
-- UTILS
-- ==============================================================

local function GetGender(model)
    return model == `mp_f_freemode_01` and "female" or "male"
end

local function GetSkin(class, gender)
    local classSkins = Skins[class] or Skins["civil"]
    local genderSkins = classSkins[gender] or classSkins["male"]

    if not genderSkins or #genderSkins == 0 then return nil end

    return genderSkins[math.random(#genderSkins)]
end

-- ==============================================================
-- APPLY SKIN
-- ==============================================================

function SkinSystem.Apply(ped, class, model, dbSkin)
    if not DoesEntityExist(ped) then return end

    local gender = GetGender(model or GetEntityModel(ped))

    -- PRIORITÉ DB
    local finalClass = dbSkin or class or "civil"

    local skin = GetSkin(finalClass, gender)
    if not skin then return end

    SetPedDefaultComponentVariation(ped)

    -- components
    if skin.components then
        for compId, comp in pairs(skin.components) do
            SetPedComponentVariation(ped, compId, comp.drawable, comp.texture, 0)
        end
    end

    -- props
    if skin.props then
        for propId, prop in pairs(skin.props) do
            if prop then
                SetPedPropIndex(ped, propId, prop.drawable, prop.texture, true)
            else
                ClearPedProp(ped, propId)
            end
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
                local model = GetEntityModel(npc.ped)

                SkinSystem.Apply(
                    npc.ped,
                    npc.class,
                    model,
                    npc.skin -- 👈 SQL OVERRIDE
                )
            end
        end)
    end

    return npc
end