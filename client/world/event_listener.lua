-- FIX v1.2 :
--   • La mort du joueur ne réduit les émotions qu'UNE seule fois (suppression du doublon
--     qui existait dans memory_system.lua)
--   • Déclenche npc:player_died_nearby pour que memory_system puisse enregistrer
--     le souvenir sans dupliquer la logique d'émotion

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

-- FIX: source unique pour la mort du joueur.
-- memory_system.lua ne gère PLUS ce handler (supprimé là-bas).
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

            -- Notifie memory_system séparément pour l'enregistrement du souvenir
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
