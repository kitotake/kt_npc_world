-- client/interaction/interaction_menu.lua
-- Menu d'interaction contextuel (appui sur touche près d'un NPC)

local menuOpen = false

CreateThread(function()
    while true do
        local waitTime = 500
        local target = GetTargetedNPC and GetTargetedNPC() or nil

        if target and target.ped and DoesEntityExist(target.ped) then
            waitTime = 0

            lib.showTextUI('[E] Interagir')

            if IsControlJustReleased(0, 38) then
                lib.notify({
                    title = 'Interaction',
                    description = 'Tu interagis avec le PNJ.',
                    type = 'success'
                })

                TriggerEvent('npc:interact', target)
                Wait(500)
            end
        else
            lib.hideTextUI()
        end

        Wait(waitTime)
    end
end)
