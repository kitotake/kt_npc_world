-- State definitions and valid transitions for NPC state machine

StateTransitions = {
    calm = {
        scared    = function(npc) return npc.emotion.stress > EMOTION_THRESHOLDS.STRESS_SCARE end,
        panicked  = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
        aggressive = function(npc) return npc.emotion.aggression > EMOTION_THRESHOLDS.AGGRO end,
    },
    scared = {
        calm      = function(npc) return npc.emotion.stress <= 20 and npc.emotion.fear <= 20 end,
        panicked  = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
        aggressive = function(npc) return npc.emotion.aggression > EMOTION_THRESHOLDS.AGGRO end,
    },
    panicked = {
        scared    = function(npc) return npc.emotion.fear <= 40 end,
        calm      = function(npc) return npc.emotion.fear <= 10 end,
    },
    aggressive = {
        calm      = function(npc) return npc.emotion.aggression <= 10 end,
        panicked  = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
    },
    fleeing = {
        calm      = function(npc) return npc.emotion.fear <= 10 end,
        panicked  = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
    },
    dead = {},
}

-- Returns the next state for the given NPC, or nil if no transition applies
function ResolveNextState(npc)
    local current = npc.state
    local transitions = StateTransitions[current]
    if not transitions then return nil end

    for nextState, condition in pairs(transitions) do
        if condition(npc) then
            return nextState
        end
    end
    return nil
end
