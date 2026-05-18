-- FIX: refactorisé pour utiliser RemoveNPC() centralisé au lieu de supprimer
-- les entités manuellement. Élimine :
--   • La double suppression de npc.vehicle (aussi supprimé dans RemoveNPC)
--   • Le double appel ReleaseID/ActiveNPCs=nil (géré dans RemoveNPC)
--   • La modification d'ActiveNPCs pendant un pairs() (via liste différée)

AddEventHandler("npc:update_cleanup", function()
    local player  = PlayerPedId()
    local pCoords = GetEntityCoords(player)

    -- FIX: on collecte d'abord les IDs à supprimer, on supprime ensuite.
    -- Modifier ActiveNPCs pendant pairs() produit un comportement indéfini en Lua.
    local toRemove = {}

    for id, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - pCoords)
            if dist > Config.Spawn.despawnRadius then
                TriggerEvent("npc:removed", npc)
                toRemove[#toRemove + 1] = id
            end
        else
            -- Entité déjà supprimée par le moteur (mort, etc.)
            TriggerEvent("npc:removed", npc)
            toRemove[#toRemove + 1] = id
        end
    end

    for _, id in ipairs(toRemove) do
        RemoveNPC(id)   -- gère ped, vehicle, ReleaseID, ActiveNPCs[id]=nil
    end
end)
