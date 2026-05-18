CREATE TABLE IF NOT EXISTS `npc_jobs` (
    `id`       INT         NOT NULL AUTO_INCREMENT,
    `npc_id`   INT         NOT NULL,
    `job`      VARCHAR(32) NOT NULL DEFAULT 'none',
    `route_id` VARCHAR(64)          DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_npc` (`npc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;