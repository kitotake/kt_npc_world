fx_version 'cerulean'
game 'gta5'

author 'kt'
name 'kt_npc_world'
version '1.3.0'

dependencies {
    'oxmysql',
    'kt_lib',
}

shared_script '@kt_lib/init.lua'

shared_scripts {
    'shared/config.lua',
    'shared/enums.lua',
    'shared/utils.lua',
    'shared/zones.lua',
    'shared/classes.lua',
    'shared/states.lua',
    'shared/routes.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/npc_repository.lua',
    'server/npc_service.lua',
    'server/jobs_service.lua',
    'server/groups_service.lua',
    'server/event_service.lua',
    'server/world_service.lua',
}

client_scripts {
    'client/core/main.lua',
    'client/core/entity_pool.lua',
    'client/core/npc_manager.lua',
    'client/core/world_tick.lua',

    'client/systems/spawn_system.lua',
    'client/systems/despawn_system.lua',
    'client/systems/emotion_system.lua',
    'client/systems/state_system.lua',
    'client/systems/behavior_system.lua',
    'client/systems/skin_system.lua',
    'client/systems/memory_system.lua',   -- v1.1

    'client/ai/ai_brain.lua',
    'client/ai/decision_tree.lua',
    'client/ai/group_ai.lua',             -- v1.1
    'client/ai/reactions.lua',

    'client/traffic/traffic_manager.lua',
    'client/traffic/ped_traffic.lua',
    'client/traffic/vehicle_traffic.lua',

    'client/world/zone_manager.lua',
    'client/world/event_listener.lua',

    'client/vehicles/vehicle_system.lua',
    'client/vehicles/driving_ai.lua',

    'client/interaction/target_system.lua',
    'client/interaction/interaction_system.lua',
    'client/interaction/interaction_menu.lua',

    'client/debug/debug_draw.lua',
    'client/debug/debug_menu.lua',
}
