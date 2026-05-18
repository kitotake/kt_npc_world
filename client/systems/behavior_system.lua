-- client/systems/behavior_system.lua
-- FIX v1.2 :
--   • Patrol thread : accès à ActiveNPCs[npcId] sécurisé contre le nil pendant Wait()

AddEventHandler("npc:start_patrol", function(npcId)
    local npc = ActiveNPCs[npcId]
    if not npc or not npc.routeId then return end

    local ped = npc.ped

    CreateThread(function()
        while true do
            local current = ActiveNPCs[npcId]
            if not current or current.ped ~= ped or not DoesEntityExist(ped) then return end

            if current.state == "calm" then
                local route = GetRoute(current.routeId)
                if route then
                    local wp = route.waypoints[current.waypointIndex]
                    TaskGoStraightToCoord(ped, wp.x, wp.y, wp.z, 1.0, -1, 0.0, 0.1)

                    local timeout = 15000
                    local start   = GetGameTimer()
                    while GetGameTimer() - start < timeout do
                        Wait(500)
                        local c = ActiveNPCs[npcId]
                        if not c or c.ped ~= ped then return end
                        local dist = #(GetEntityCoords(ped) - wp)
                        if dist < 2.0 then break end
                        if c.state ~= "calm" then break end
                    end

                    local c = ActiveNPCs[npcId]
                    if not c or c.ped ~= ped then return end

                    local nextIdx = NextWaypointIndex(route, c.waypointIndex)
                    if nextIdx then
                        c.waypointIndex = nextIdx
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