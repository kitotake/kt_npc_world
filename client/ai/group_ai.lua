-- client/ai/group_ai.lua
-- FIX v1.3 :
--   • npc:registered ne déclenche plus Register si npc.group n'est pas encore défini
--     (cas SpawnNPCWithJob qui pose group APRÈS SpawnNPC).
--     L'enregistrement effectif se fait via npc:group_assigned déclenché explicitement
--     une fois npc.group positionné.
--   • Idempotence conservée dans Register().

GroupAI = {}

local activeGroups = {}

function GroupAI.Register(npc)
    if not npc.group then return end
    if not activeGroups[npc.group] then
        activeGroups[npc.group] = {}
    end
    if not activeGroups[npc.group][npc.id] then
        activeGroups[npc.group][npc.id] = true
    end
end

function GroupAI.Unregister(npc)
    if not npc.group then return end
    if activeGroups[npc.group] then
        activeGroups[npc.group][npc.id] = nil
    end
end

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

                if dist < 80.0 then
                    if alertType == "engage" then
                        if member.classData.canFight then
                            member.emotion.aggression = Clamp(member.emotion.aggression + 40, 0, 100)
                        else
                            member.emotion.fear = Clamp(member.emotion.fear + 20, 0, 100)
                        end
                    elseif alertType == "flee" then
                        member.emotion.fear   = Clamp(member.emotion.fear + 30, 0, 100)
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

-- FIX v1.3 : npc:registered n'enregistre plus si group est nil à ce stade.
-- SpawnNPCWithJob pose npc.group APRÈS SpawnNPC → le hook était toujours appelé
-- avec group=nil, puis l'appel explicite Register() dans SpawnNPCWithJob enregistrait.
-- Désormais : npc:group_assigned est le seul chemin pour les NPCs avec groupe.
AddEventHandler("npc:registered", function(npc)
    -- Enregistre seulement si le group est déjà connu au moment du spawn
    -- (cas d'un NPC spawné directement avec group pré-rempli)
    if npc.group then
        GroupAI.Register(npc)
    end
end)

-- Nouveau event déclenché par SpawnNPCWithJob une fois npc.group positionné
AddEventHandler("npc:group_assigned", function(npc)
    GroupAI.Register(npc)
end)

AddEventHandler("npc:removed", function(npc)
    GroupAI.Unregister(npc)
end)

AddEventHandler("npc:group_dissolved", function(groupId)
    activeGroups[groupId] = nil
end)