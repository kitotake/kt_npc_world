-- Comportements de conduite avancés

DrivingAI = {}

local drivingStyles = {
    normal   = 786603,
    aggressive = 1074528293,
    cautious = 524860,
}

function DrivingAI.SetStyle(npc, style)
    if not npc.vehicle or not DoesEntityExist(npc.vehicle) then return end
    local flags = drivingStyles[style] or drivingStyles.normal
    TaskVehicleDriveWander(npc.ped, npc.vehicle, 20.0, flags)
end

-- Quand un NPC devient paniqué dans un véhicule : conduite agressive
AddEventHandler("npc:state_changed", function(npc, prev, next)
    if npc.vehicle and DoesEntityExist(npc.vehicle) then
        if next == "panicked" then
            DrivingAI.SetStyle(npc, "aggressive")
        elseif next == "calm" then
            DrivingAI.SetStyle(npc, "normal")
        end
    end
end)
