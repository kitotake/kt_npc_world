-- v1.3 : ClearPedTasks ne s'applique plus aveuglément à chaque tick.
-- On track la décision précédente par NPC et on ne clear/reassigne que si elle change.
-- Évite les micro-interruptions visuelles sur TaskCombatPed, TaskSeekCoverFromPed, etc.

local AdvancedClasses = { guard = true, gang = true, dealer = true }

AddEventHandler("npc:update_ai", function()
    local player = PlayerPedId()

    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) and not IsEntityDead(npc.ped) then

            if AdvancedClasses[npc.class] then
                local decision = DecisionTree.Evaluate(npc, player)

                -- FIX: ne reassigner la tâche que si la décision a changé.
                -- ClearPedTasks chaque seconde annulait TaskCombatPed, TaskSeekCoverFromPed, etc.
                -- causant des micro-interruptions et des comportements de combat cassés.
                if decision ~= npc._lastDecision then
                    ClearPedTasks(npc.ped)
                    DecisionTree.Execute(npc, decision, player)
                    npc._lastDecision = decision
                end
            else
                -- Pour les classes simples, on compare aussi l'état
                if npc.state ~= npc._lastState then
                    ClearPedTasks(npc.ped)
                    DecideAction(npc, player)
                    npc._lastState = npc.state
                end
            end

        end
    end
end)

-- Réinitialise le cache de décision lors d'un changement d'état externe
-- (ex : explosion qui force l'état "panicked" indépendamment de l'AI tick)
AddEventHandler("npc:state_changed", function(npc, prevState, newState)
    if npc then
        npc._lastDecision = nil
        npc._lastState    = nil
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