-- decision_tree.lua
-- FIX v1.3 :
--   • aggroThreshold lu depuis classData.aggroThreshold ou Config.AI.aggroThreshold
--     au lieu d'être hardcodé (15/30 identiques pour tous les NPCs avancés)
--   • HostileMatrix supprimé (dead code)
--   • back_away : TaskSmartFleePed courte distance (v1.2)
--   • MemorySystem.Event garanti disponible (memory_system.lua)

DecisionTree = {}

DecisionTree.Evaluate = function(npc, player)
    local pCoords   = GetEntityCoords(player)
    local nCoords   = GetEntityCoords(npc.ped)
    local dist      = #(nCoords - pCoords)
    local cd        = npc.classData
    local hasWeapon = GetSelectedPedWeapon(player) ~= `WEAPON_UNARMED`

    local wasAttacked = MemorySystem and MemorySystem.Has(npc, MemorySystem.Event.ATTACKED)

    -- FIX: seuil d'agression depuis classData ou Config, pas hardcodé.
    -- Permet aux gangs (aggressionMultiplier 2.0) d'être plus réactifs que les dealers.
    local baseThreshold    = cd.aggroThreshold or (Config.AI and Config.AI.aggroThreshold) or 30
    local attackedModifier = cd.attackedAggroModifier or (Config.AI and Config.AI.attackedAggroModifier) or 15
    local aggroThreshold   = wasAttacked and attackedModifier or baseThreshold

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
        TaskSmartFleePed(npc.ped, player, 12.0, 3000, false, false)

    elseif decision == "idle_watch" then
        TaskTurnPedToFaceEntity(npc.ped, player, 2000)

    elseif decision == "continue_patrol" then
        -- laissé au behavior_system

    elseif decision == "wander_slow" then
        TaskWanderStandard(npc.ped, 3.0, 10)

    else -- wander_normal
        TaskWanderStandard(npc.ped, 5.0, 10)
    end
end