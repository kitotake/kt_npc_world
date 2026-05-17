-- client/ai/group_ai.lua
-- v1.1 : comportement de groupe côté client
-- Les membres d'un même groupe réagissent aux alertes de leurs alliés

GroupAI = {}

-- Cache local des groupes actifs { [groupId] = { npcId, ... } }
local activeGroups = {}

-- Enregistre un NPC dans un groupe local
function GroupAI.Register(npc)
    if not npc.group then return end
    if not activeGroups[npc.group] then
        activeGroups[npc.group] = {}
    end
    activeGroups[npc.group][npc.id] = true
end

-- Désenregistre un NPC de son groupe (au despawn)
function GroupAI.Unregister(npc)
    if not npc.group then return end
    if activeGroups[npc.group] then
        activeGroups[npc.group][npc.id] = nil
    end
end

-- Alerte tous les membres du groupe d'un NPC
-- alertType : "engage" | "flee" | "cover"
function GroupAI.AlertGroup(npc, alertType)
    if not npc.group then return end
    local group = activeGroups[npc.group]
    if not group then return end

    local origin = GetEntityCoords(npc.ped)

    for memberId, _ in pairs(group) do
        if memberId ~= npc.id then
            local member = ActiveNPCs[memberId]
            if member and DoesEntityExist(member.ped) then
                local dist = #(GetEntityCoords(member.ped) - origin)

                -- Rayon d'alerte : 80m
                if dist < 80.0 then
                    if alertType == "engage" then
                        -- Monte l'aggression des alliés combattants
                        if member.classData.canFight then
                            member.emotion.aggression = Clamp(member.emotion.aggression + 40, 0, 100)
                        else
                            member.emotion.fear = Clamp(member.emotion.fear + 20, 0, 100)
                        end
                    elseif alertType == "flee" then
                        member.emotion.fear  = Clamp(member.emotion.fear + 30, 0, 100)
                        member.emotion.stress = Clamp(member.emotion.stress + 20, 0, 100)
                    end

                    if Config.Debug then
                        print(("[NPC WORLD] GroupAI: NPC #%d alerté par #%d (%s)"):format(
                            memberId, npc.id, alertType
                        ))
                    end
                end
            end
        end
    end
end

-- Hook sur le spawn pour auto-enregistrer les NPCs avec un groupe
AddEventHandler("npc:registered", function(npc)
    GroupAI.Register(npc)
end)

-- Hook sur le despawn
AddEventHandler("npc:removed", function(npc)
    GroupAI.Unregister(npc)
end)

-- Mise à jour côté serveur : un groupe est dissous
AddEventHandler("npc:group_dissolved", function(groupId)
    activeGroups[groupId] = nil
end)
