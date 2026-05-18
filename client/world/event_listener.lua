-- client/world/event_listener.lua
-- FIX v1.2 :
--   • La mort du joueur ne réduit les émotions qu'UNE seule fois (doublon supprimé de memory_system.lua)
--   • Déclenche npc:player_died_nearby pour l'enregistrement mémoire

CreateThread(function()
    while true do
        Wait(300)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        if HasEntityBeenDamagedByWeapon(player, 0, 2) then
            TriggerEvent("npc:gunshot_nearby", coords)
            ClearEntityLastWeaponDamage(player)
        end

        if HasEntityBeenDamagedByWeapon(player, 0, 3) then
            TriggerEvent("npc:explosion_nearby", coords)
            ClearEntityLastWeaponDamage(player)
        end
    end
end)

-- Source unique pour la mort du joueur.
-- La réduction d'émotion se fait ici, l'enregistrement mémoire via npc:player_died_nearby.
AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkEntityDamage" then
        local victim = args[1]
        if victim == PlayerPedId() and IsEntityDead(victim) then
            local pCoords = GetEntityCoords(victim)

            for _, npc in pairs(ActiveNPCs) do
                if DoesEntityExist(npc.ped) then
                    npc.emotion.fear       = math.max(0, npc.emotion.fear - 40)
                    npc.emotion.aggression = math.max(0, npc.emotion.aggression - 40)
                end
            end

            TriggerEvent("npc:player_died_nearby", pCoords)
        end
    end
end)

RegisterCommand("npc_gunshot", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:gunshot_nearby", coords)
end, false)

RegisterCommand("npc_explosion", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:explosion_nearby", coords)
end, false)