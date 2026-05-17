-- v1.1 : DecisionTree maintenant branché sur les classes canFight (guard, gang, dealer)

-- Classes qui utilisent le decision tree avancé
local AdvancedClasses = { guard = true, gang = true, dealer = true }

AddEventHandler("npc:update_ai", function()
    local player = PlayerPedId()

    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) and not IsEntityDead(npc.ped) then
            ClearPedTasks(npc.ped)

            if AdvancedClasses[npc.class] then
                -- Utilise le decision tree pour les classes complexes
                local decision = DecisionTree.Evaluate(npc, player)
                DecisionTree.Execute(npc, decision, player)
            else
                DecideAction(npc, player)
            end
        end
    end
end)

function DecideAction(npc, player)
    local state = npc.state

    if state == "panicked" then
        TaskSmartFleePed(npc.ped, player, 100.0, -1, false, false)

    elseif state == "aggressive" then
        if npc.classData.canFight then
            TaskCombatPed(npc.ped, player, 0, 16)
        else
            TaskSmartFleePed(npc.ped, player, 80.0, -1, false, false)
        end

    elseif state == "scared" then
        if npc.classData.preferFlee then
            TaskWanderStandard(npc.ped, 10.0, 10)
        else
            TaskStandStill(npc.ped, 3000)
        end

    elseif state == "fleeing" then
        TaskSmartFleePed(npc.ped, player, 150.0, -1, false, false)

    else
        -- calm
        if npc.job == "patrol" then
            -- géré par behavior_system
        elseif npc.job == "stand" then
            ApplyIdleBehavior(npc)
        elseif npc.job == "drive" then
            -- géré par vehicle_traffic
        else
            local r = math.random()
            if r < 0.25 then
                ApplyIdleBehavior(npc)
            elseif r < 0.55 then
                TaskWanderStandard(npc.ped, 5.0, 10)
            else
                local pCoords = GetEntityCoords(player)
                local offset  = vector3(
                    pCoords.x + math.random(-30, 30),
                    pCoords.y + math.random(-30, 30),
                    pCoords.z
                )
                TaskGoStraightToCoord(npc.ped, offset.x, offset.y, offset.z, 1.0, 10000, 0.0, 0.5)
            end
        end
    end
end
