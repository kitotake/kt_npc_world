CREATE TABLE IF NOT EXISTS `npc_memory` (
    `id`         INT           NOT NULL AUTO_INCREMENT,
    `npc_id`     INT           NOT NULL,
    `event`      VARCHAR(64)   NOT NULL,
    `data`       JSON                   DEFAULT NULL,
    `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_npc_id` (`npc_id`),
    -- FIX: index sur created_at indispensable pour la requête de purge (DELETE WHERE created_at < X)
    -- Sans cet index, MySQL fait un full scan à chaque purge.
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- FIX: event de purge automatique (supprime les souvenirs de plus de 7 jours)
-- À activer sur le serveur MySQL si les events sont supportés (MySQL 5.1+).
-- Remplace un job cron externe ou une purge manuelle dans le code serveur.
DROP EVENT IF EXISTS `purge_old_npc_memory`;
CREATE EVENT `purge_old_npc_memory`
    ON SCHEDULE EVERY 1 DAY
    STARTS CURRENT_TIMESTAMP
    DO
        DELETE FROM `npc_memory`
        WHERE `created_at` < DATE_SUB(NOW(), INTERVAL 7 DAY);
