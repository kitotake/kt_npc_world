CreateThread(function()
    while true do
        Wait(1000)

        TriggerEvent("npc:update_emotion")
        TriggerEvent("npc:update_state")
        TriggerEvent("npc:update_ai")
        TriggerEvent("npc:update_cleanup")
    end
end)