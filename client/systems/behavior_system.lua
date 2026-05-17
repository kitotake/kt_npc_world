-- Comportements spécialisés par job

AddEventHandler("npc:start_patrol", function(npcId)
    local npc = ActiveNPCs[npcId]
    if not npc or not npc.routeId then return end

    -- FIX (bug 8): capture the ped handle at thread creation so a later NPC
    -- reusing the same integer ID cannot be accidentally controlled by this thread.
    local ped = npc.ped

    CreateThread(function()
        while ActiveNPCs[npcId] and ActiveNPCs[npcId].ped == ped and DoesEntityExist(ped) do
            if npc.state == "calm" then
                local route = GetRoute(npc.routeId)
                if route then
                    local wp = route.waypoints[npc.waypointIndex]
                    TaskGoStraightToCoord(ped, wp.x, wp.y, wp.z, 1.0, -1, 0.0, 0.1)

                    local timeout = 15000
                    local start   = GetGameTimer()
                    while GetGameTimer() - start < timeout do
                        Wait(500)
                        if not ActiveNPCs[npcId] or ActiveNPCs[npcId].ped ~= ped then return end
                        local dist = #(GetEntityCoords(ped) - wp)
                        if dist < 2.0 then break end
                        if npc.state ~= "calm" then break end
                    end

                    local nextIdx = NextWaypointIndex(route, npc.waypointIndex)
                    if nextIdx then
                        npc.waypointIndex = nextIdx
                    end
                end
            end
            Wait(1000)
        end
    end)
end)

-- Comportement idle : rester en place et regarder autour
function ApplyIdleBehavior(npc)
    local r = math.random()
    if r < 0.4 then
        TaskStartScenarioInPlace(npc.ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)
    elseif r < 0.7 then
        TaskStartScenarioInPlace(npc.ped, "WORLD_HUMAN_SMOKING", 0, true)
    else
        TaskStartScenarioInPlace(npc.ped, "WORLD_HUMAN_LEANING", 0, true)
    end
end
