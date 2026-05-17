-- Écoute les événements du monde GTA et les traduit en événements NPC

-- FIX (bug 1 + bug 2): single canonical detection loop.
-- Bug 1: the duplicate loop that was in reactions.lua has been removed.
-- Bug 2: the original loop here fired npc:gunshot_nearby for BOTH gunshots
--        AND explosions. Explosions (damage type 3) now correctly fire
--        npc:explosion_nearby.
CreateThread(function()
    while true do
        Wait(300)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        -- Weapon damage (type 2)
        if HasEntityBeenDamagedByWeapon(player, 0, 2) then
            TriggerEvent("npc:gunshot_nearby", coords)
            ClearEntityLastWeaponDamage(player)
        end

        -- Explosion damage (type 3)
        if HasEntityBeenDamagedByWeapon(player, 0, 3) then
            TriggerEvent("npc:explosion_nearby", coords)
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

-- Commandes debug pour déclencher un événement manuel
RegisterCommand("npc_gunshot", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:gunshot_nearby", coords)
end, false)

RegisterCommand("npc_explosion", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent("npc:explosion_nearby", coords)
end, false)
