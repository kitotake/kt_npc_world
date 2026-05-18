CREATE TABLE IF NOT EXISTS `npc_memory` (
    `id`         INT           NOT NULL AUTO_INCREMENT,
    `npc_id`     INT           NOT NULL,
    `event`      VARCHAR(64)   NOT NULL,
    `data`       JSON                   DEFAULT NULL,
    `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_npc_id` (`npc_id`),
    -- Index indispensable pour la purge (DELETE WHERE created_at < X) : évite le full scan.
    INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP EVENT IF EXISTS `purge_old_npc_memory`;
CREATE EVENT `purge_old_npc_memory`
    ON SCHEDULE EVERY 1 DAY
    STARTS CURRENT_TIMESTAMP
    DO
        DELETE FROM `npc_memory`
        WHERE `created_at` < DATE_SUB(NOW(), INTERVAL 7 DAY);