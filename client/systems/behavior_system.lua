-- Comportements spécialisés par job

AddEventHandler("npc:start_patrol", function(npcId)
    local npc = ActiveNPCs[npcId]
    if not npc or not npc.routeId then return end

    CreateThread(function()
        while ActiveNPCs[npcId] and DoesEntityExist(npc.ped) do
            if npc.state == "calm" then
                local route = GetRoute(npc.routeId)
                if route then
                    local wp = route.waypoints[npc.waypointIndex]
                    TaskGoStraightToCoord(npc.ped, wp.x, wp.y, wp.z, 1.0, -1, 0.0, 0.1)

                    local timeout = 15000
                    local start   = GetGameTimer()
                    while GetGameTimer() - start < timeout do
                        Wait(500)
                        if not ActiveNPCs[npcId] then return end
                        local dist = #(GetEntityCoords(npc.ped) - wp)
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
