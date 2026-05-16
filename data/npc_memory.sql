CREATE TABLE IF NOT EXISTS `npc_memory` (
    `id`         INT           NOT NULL AUTO_INCREMENT,
    `npc_id`     INT           NOT NULL,
    `event`      VARCHAR(64)   NOT NULL,
    `data`       JSON                   DEFAULT NULL,
    `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_npc_id` (`npc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
