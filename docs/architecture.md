# kt_npc_world — Architecture

## Vue d'ensemble

Moteur de simulation de ville vivante pour FiveM/GTA5.
Chaque NPC est une entité autonome avec psychologie, état, et comportement.

## Cycle de vie d'un NPC

```
Spawn → Emotion → State → AI Brain → Action → Cleanup
```

### 1. Spawn (traffic_manager, spawn_system)
- Déclenché toutes les 4s si NPC actifs < 25
- Modèle sélectionné selon la zone et la classe
- Entité créée et enregistrée dans `ActiveNPCs`

### 2. Emotion (emotion_system)
- Mise à jour chaque seconde
- Entrée : distance au joueur, zone actuelle
- Sorties : fear, stress, aggression (0-100)
- Pondérées par `classData` (multiplicateurs par classe)

### 3. State (state_system)
- Lit les émotions, applique les seuils
- États : calm, scared, panicked, aggressive, fleeing
- Transitions définies dans `shared/states.lua`
- Priorité déterministe : panicked > aggressive > fleeing > scared > calm

### 4. AI Brain (ai_brain, decision_tree)
- Traduit l'état en commandes natives GTA (`Task*`)
- `decision_tree` pour les classes à comportement complexe
- `reactions` pour les événements ponctuels (tirs, explosions)
- **v1.3** : `ClearPedTasks` uniquement si la décision change (`_lastDecision` / `_lastState`)

### 5. Cleanup (despawn_system)
- Supprime les NPC au-delà de 200m du joueur
- Libère la mémoire Lua (`ActiveNPCs[id] = nil`)

## Fichiers clés

| Fichier | Rôle |
|---|---|
| `shared/config.lua` | Paramètres globaux (dont `Config.AI` pour les seuils) |
| `shared/classes.lua` | Données par classe (multiplicateurs, modèles, seuils aggro) |
| `shared/states.lua` | Machine d'états et transitions |
| `shared/zones.lua` | Zones géographiques et modificateurs |
| `client/core/world_tick.lua` | Boucle principale (1s) |
| `client/ai/ai_brain.lua` | Décision comportementale |
| `client/systems/emotion_system.lua` | Psychologie NPC |
| `server/npc_repository.lua` | Templates depuis BDD |

## Commandes debug

```
/npc_debug      — toggle overlay
/npc_info       — stats NPC le plus proche (+ lastDecision)
/npc_spawn      — spawn un NPC
/npc_clear      — supprime tous les NPC
/npc_gunshot    — simule un tir
/npc_explosion  — simule une explosion
```

## Bugs corrigés (v1.0 → v1.2)

| # | Fichier | Description |
|---|---|---|
| 1 | `reactions.lua` | Suppression de la boucle de détection de tir dupliquée |
| 2 | `event_listener.lua` | Les explosions déclenchent maintenant `npc:explosion_nearby` (type 3) |
| 3 | `states.lua` | `ResolveNextState` utilise `ipairs` + liste de priorité |
| 4 | `skin_system.lua` | `math.random` différé au spawn via `textureRange` |
| 5 | `enums.lua` | `NPC_CLASS.civil` → `NPC_CLASS.CIVIL` |
| 6 | `world_service.lua` | `Clamp` disponible côté serveur via `shared/utils.lua` |
| 7 | `behavior_system.lua` | Patrol thread vérifie `npc.ped == ped` (recyclage) |
| 8 | `entity_pool.lua` | Recyclage des IDs via `FreeSlots` |
| 9 | `despawn_system.lua` | Liste différée pour éviter modification de `pairs()` |
| 10 | `memory_system.lua` | `MemorySystem.Event` déclaré en tête de fichier |
| 11 | `states.lua` | Bug logique `fleeing→scared` corrigé |
| 12 | `group_ai.lua` | Double `Register()` éliminé |

## Fixes v1.3

| # | Fichier | Description |
|---|---|---|
| 13 | `ai_brain.lua` | `ClearPedTasks` conditionnel : uniquement si la décision change |
| 14 | `decision_tree.lua` | `aggroThreshold` lu depuis `classData` / `Config.AI`, plus hardcodé |
| 15 | `classes.lua` | `aggroThreshold` et `attackedAggroModifier` définis par classe |
| 16 | `config.lua` | Section `Config.AI` ajoutée (seuils par défaut) |
| 17 | `group_ai.lua` | `npc:group_assigned` remplace l'appel direct à `Register()` |
| 18 | `spawn_system.lua` | `TriggerEvent("npc:group_assigned")` après positionnement de `npc.group` |
| 19 | `vehicle_system.lua` | `Wait(1500)` dans `EjectNPC` déplacé dans `CreateThread` |
| 20 | `interaction_menu.lua` | Assert explicite si `GetTargetedNPC` est nil au démarrage |
| 21 | `entity_pool.lua` | `_lastDecision` / `_lastState` initialisés à nil dans `RegisterEntity` |