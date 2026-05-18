-- client/interaction/interaction_menu.lua
-- FIX v1.3 :
--   • Assert au démarrage si target_system.lua n'est pas chargé (GetTargetedNPC absent).
--     Auparavant : retournait nil silencieusement à chaque frame sans aucun log.

CreateThread(function()
    -- FIX: vérification explicite au démarrage plutôt qu'un guard silencieux dans la boucle.
    if not GetTargetedNPC then
        print("^1[NPC WORLD]^0 ERREUR : GetTargetedNPC est nil. Vérifier que target_system.lua est chargé AVANT interaction_menu.lua dans fxmanifest.")
        return
    end

    while true do
        local waitTime = 500
        local target   = GetTargetedNPC()

        if target and target.ped and DoesEntityExist(target.ped) then
            waitTime = 0

            lib.showTextUI('[E] Interagir')

            if IsControlJustReleased(0, 38) then
                lib.notify({
                    title       = 'Interaction',
                    description = 'Tu interagis avec le PNJ.',
                    type        = 'success'
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