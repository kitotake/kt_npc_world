CreateThread(function()
    while true do
        Wait(4000)

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        if #ActiveNPCs < 25 then
            SpawnNPC("mp_m_freemode_01",
                vector3(coords.x + math.random(-50,50), coords.y + math.random(-50,50), coords.z),
                "civilian"
            )
        end

    end
end)