-- Écoute les événements du monde GTA et les traduit en événements NPC

-- Détection d'explosion via native
CreateThread(function()
    while true do
        Wait(300)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        -- Vérifie une explosion dans un rayon de 80m
        if HasEntityBeenDamagedByWeapon(player, 0, 2) then
            TriggerEvent("npc:gunshot_nearby", coords)
            ClearEntityLastWeaponDamage(player)
        end
    end
end)

-- Réaction au décès du joueur
AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkEntityDamage" then
        local victim = args[1]
        if victim == PlayerPedId() and IsEntityDead(victim) then
            -- Joueur mort : les NPC proches retrouvent leur calme
            for _, npc in pairs(ActiveNPCs) do
                if DoesEntityExist(npc.ped) then
                    npc.emotion.fear       = math.max(0, npc.emotion.fear - 40)
                    npc.emotion.aggression = math.max(0, npc.emotion.aggression - 40)
                end
            end
        end
    end
end)

-- Commande debug pour déclencher un événement de tir manuel
RegisterCommand("npc_gunshot", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:gunshot_nearby", coords)
end, false)

RegisterCommand("npc_explosion", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:explosion_nearby", coords)
end, false)
