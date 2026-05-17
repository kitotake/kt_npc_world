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

### 5. Cleanup (despawn_system)
- Supprime les NPC au-delà de 200m du joueur
- Libère la mémoire Lua (`ActiveNPCs[id] = nil`)

## Fichiers clés

| Fichier | Rôle |
|---|---|
| `shared/config.lua` | Paramètres globaux |
| `shared/classes.lua` | Données par classe (multiplicateurs, modèles) |
| `shared/states.lua` | Machine d'états et transitions |
| `shared/zones.lua` | Zones géographiques et modificateurs |
| `client/core/world_tick.lua` | Boucle principale (1s) |
| `client/ai/ai_brain.lua` | Décision comportementale |
| `client/systems/emotion_system.lua` | Psychologie NPC |
| `server/npc_repository.lua` | Templates depuis BDD |

## Commandes debug

```
/npc_debug      — toggle overlay
/npc_info       — stats NPC le plus proche
/npc_spawn      — spawn un NPC
/npc_clear      — supprime tous les NPC
/npc_gunshot    — simule un tir
/npc_explosion  — simule une explosion
```

## Bugs corrigés (v1.0.7)

| # | Fichier | Description |
|---|---|---|
| 1 | `reactions.lua` | Suppression de la boucle de détection de tir dupliquée |
| 2 | `event_listener.lua` | Les explosions déclenchent maintenant `npc:explosion_nearby` (type 3) au lieu de `npc:gunshot_nearby` |
| 3 | `states.lua` | `ResolveNextState` utilise `ipairs` + liste de priorité au lieu de `pairs` |
| 4 | `skin_system.lua` | `math.random` différé au spawn via `textureRange` + `ResolveSkin()` |
| 5 | `enums.lua` | `NPC_CLASS.civil` → `NPC_CLASS.CIVIL` (casse uniforme) |
| 6 | `world_service.lua` | `Clamp` disponible côté serveur via `shared/utils.lua` |
| 7 | `behavior_system.lua` | Patrol thread vérifie `npc.ped == ped` pour éviter de contrôler un NPC recyclé |
