-- client/systems/state_system.lua

AddEventHandler("npc:update_state", function()
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local next = ResolveNextState(npc)
            if next and next ~= npc.state then
                local prev = npc.state
                npc.state  = next
                TriggerEvent("npc:state_changed", npc, prev, next)
            end
        end
    end
end)