CREATE TABLE IF NOT EXISTS `npc_groups` (
    `id`       VARCHAR(64)  NOT NULL,
    `label`    VARCHAR(128) NOT NULL,
    `class`    VARCHAR(32)  NOT NULL DEFAULT 'civil',
    `leader`   INT                   DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;