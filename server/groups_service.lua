-- Gestion des groupes de NPC (gangs, escortes, patrouilles)

GroupsService = {}
local groups = {}

function GroupsService.Create(id, label, class, leader)
    groups[id] = {
        id      = id,
        label   = label,
        class   = class,
        leader  = leader,
        members = {},
    }
    return groups[id]
end

function GroupsService.AddMember(groupId, npcId)
    if groups[groupId] then
        table.insert(groups[groupId].members, npcId)
    end
end

function GroupsService.Get(groupId)
    return groups[groupId]
end

function GroupsService.Dissolve(groupId)
    groups[groupId] = nil
    TriggerClientEvent("npc:group_dissolved", -1, groupId)
end
