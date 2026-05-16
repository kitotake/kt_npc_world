RegisterNetEvent("npc:update_ai", function()
    local player = PlayerPedId()

    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then

            ClearPedTasks(npc.ped)

            if npc.state == "panicked" then
                TaskSmartFleePed(npc.ped, player, 100.0, -1, false, false)

            elseif npc.state == "aggressive" then
                TaskCombatPed(npc.ped, player, 0, 16)

            elseif npc.state == "scared" then
                TaskWanderStandard(npc.ped, 10.0, 10)

            else
                local r = math.random()

                if r < 0.3 then
                    TaskStartScenarioInPlace(npc.ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)
                else
                    TaskWanderStandard(npc.ped, 5.0, 10)
                end
            end

        end
    end
end)