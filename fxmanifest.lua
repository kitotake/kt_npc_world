fx_version 'cerulean'
game 'gta5'

author 'kt'
name 'kt_npc_world'
version '1.0.4'

shared_scripts {
    'shared/config.lua',
    'shared/zones.lua',
    'shared/classes.lua',
    'shared/states.lua',
    'shared/routes.lua',
    'shared/utils.lua',
    'shared/enums.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/npc_repository.lua'
}

client_scripts {
    'client/core/main.lua',
    'client/core/entity_pool.lua',
    'client/core/world_tick.lua',
    'client/core/npc_manager.lua',

    'client/systems/spawn_system.lua',
    'client/systems/despawn_system.lua',
    'client/systems/behavior_system.lua',
    'client/systems/state_system.lua',
    'client/systems/emotion_system.lua',

    'client/ai/ai_brain.lua',
    'client/ai/decision_tree.lua',
    'client/ai/reactions.lua',

    'client/traffic/traffic_manager.lua',
    'client/traffic/ped_traffic.lua',
    'client/traffic/vehicle_traffic.lua',

    'client/world/zone_manager.lua',
    'client/world/event_listener.lua',

    'client/debug/debug_draw.lua'
}