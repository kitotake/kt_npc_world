-- client/ai/group_ai.lua
-- FIX v1.2 :
--   • GroupAI.Register n'est plus appelé deux fois pour les NPCs avec group.
--     SpawnNPCWithJob appelait Register() explicitement ET déclenchait npc:registered
--     (qui appelle aussi Register via le hook). Un seul chemin suffit : le hook.

GroupAI = {}

local activeGroups = {}

function GroupAI.Register(npc)
    if not npc.group then return end
    if not activeGroups[npc.group] then
        activeGroups[npc.group] = {}
    end
    -- FIX: vérification d'existence avant d'enregistrer (idempotent)
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

-- Hook unique pour l'enregistrement — SpawnNPCWithJob ne doit PAS appeler Register() directement
AddEventHandler("npc:registered", function(npc)
    GroupAI.Register(npc)
end)

AddEventHandler("npc:removed", function(npc)
    GroupAI.Unregister(npc)
end)

AddEventHandler("npc:group_dissolved", function(groupId)
    activeGroups[groupId] = nil
end)
