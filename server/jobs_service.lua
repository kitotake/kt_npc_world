-- Gestion des jobs assignés aux NPC

JobsService = {}
local npcJobs = {}

function JobsService.Assign(npcId, job, routeId)
    npcJobs[npcId] = { job = job, routeId = routeId }
    TriggerClientEvent("npc:job_assigned", -1, npcId, job, routeId)
end

function JobsService.Get(npcId)
    return npcJobs[npcId]
end

function JobsService.Clear(npcId)
    npcJobs[npcId] = nil
end

-- Callback client pour demander le job d'un NPC
lib.callback.register("npc:getJob", function(source, npcId)
    return JobsService.Get(npcId)
end)
