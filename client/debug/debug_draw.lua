-- Overlay de debug : affiche les infos de chaque NPC au-dessus de sa tête

CreateThread(function()
    while true do
        Wait(0)

        if not Config.Debug then
            Wait(1000)
        else
            for _, npc in pairs(ActiveNPCs) do
                if DoesEntityExist(npc.ped) then
                    local coords  = GetEntityCoords(npc.ped)
                    local player  = GetEntityCoords(PlayerPedId())
                    local dist    = #(coords - player)

                    if dist < 20.0 then
                        local onScreen, sx, sy = World3dToScreen2d(coords.x, coords.y, coords.z + 1.1)

                        if onScreen then
                            local stateColor = {
                                calm      = {0,   255, 100},
                                scared    = {255, 200, 0  },
                                panicked  = {255, 80,  0  },
                                aggressive = {255, 0,   0  },
                                fleeing   = {200, 0,   255},
                            }
                            local col = stateColor[npc.state] or {255, 255, 255}

                            local txt = ("%s | %s\nF:%d S:%d A:%d"):format(
                                npc.class, npc.state,
                                npc.emotion.fear, npc.emotion.stress, npc.emotion.aggression
                            )

                            SetTextScale(0.28, 0.28)
                            SetTextFont(4)
                            SetTextProportional(1)
                            SetTextColour(col[1], col[2], col[3], 220)
                            SetTextEntry("STRING")
                            AddTextComponentString(txt)
                            DrawText(sx, sy - 0.01)
                        end
                    end
                end
            end
        end
    end
end)
