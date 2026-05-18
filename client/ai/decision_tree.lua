-- decision_tree.lua
-- FIX v1.2 :
--   • HostileMatrix supprimé (dead code — IsHostileTo n'était jamais appelé dans Evaluate)
--   • back_away remplacé par TaskSmartFleePed courte distance (évite les destinations hors map)
--   • MemorySystem.Event est maintenant garanti disponible (déclaré en tête de memory_system.lua)

DecisionTree = {}

DecisionTree.Evaluate = function(npc, player)
    local pCoords   = GetEntityCoords(player)
    local nCoords   = GetEntityCoords(npc.ped)
    local dist      = #(nCoords - pCoords)
    local cd        = npc.classData
    local hasWeapon = GetSelectedPedWeapon(player) ~= `WEAPON_UNARMED`

    local wasAttacked    = MemorySystem and MemorySystem.Has(npc, MemorySystem.Event.ATTACKED)
    local aggroThreshold = wasAttacked and 15 or 30

    -- Branche 1 : joueur armé à courte portée
    if hasWeapon and dist < 15.0 then
        if cd.canFight and npc.emotion.aggression > aggroThreshold then
            GroupAI.AlertGroup(npc, "engage")
            return "engage"
        elseif cd.preferFlee then
            return "flee_fast"
        else
            return "take_cover"
        end
    end

    -- Branche 2 : joueur proche sans arme
    if dist < 8.0 then
        if npc.emotion.fear > 40 then
            return "back_away"
        else
            return "idle_watch"
        end
    end

    -- Branche 3 : proximité moyenne
    if dist < 25.0 then
        if npc.job == "patrol" then
            return "continue_patrol"
        else
            return "wander_slow"
        end
    end

    return "wander_normal"
end

DecisionTree.Execute = function(npc, decision, player)
    if decision == "engage" then
        TaskCombatPed(npc.ped, player, 0, 16)

    elseif decision == "flee_fast" then
        TaskSmartFleePed(npc.ped, player, 150.0, -1, false, false)

    elseif decision == "take_cover" then
        TaskSeekCoverFromPed(npc.ped, player, -1, true)

    elseif decision == "back_away" then
        -- FIX: TaskSmartFleePed courte distance remplace le calcul manuel de vecteur
        -- qui pouvait envoyer le NPC hors map ou dans un mur.
        TaskSmartFleePed(npc.ped, player, 12.0, 3000, false, false)

    elseif decision == "idle_watch" then
        TaskTurnPedToFaceEntity(npc.ped, player, 2000)

    elseif decision == "continue_patrol" then
        -- laissé au behavior_system

    elseif decision == "wander_slow" then
        TaskWanderStandard(npc.ped, 3.0, 10)

    else
        TaskWanderStandard(npc.ped, 5.0, 10)
    end
end
