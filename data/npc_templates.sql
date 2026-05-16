CREATE TABLE IF NOT EXISTS `npc_templates` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `model`      VARCHAR(64)  NOT NULL DEFAULT 'mp_m_freemode_01',
    `class`      VARCHAR(32)  NOT NULL DEFAULT 'civil',
    `job`        VARCHAR(32)  NOT NULL DEFAULT 'none',
    `skin`       VARCHAR(32)  DEFAULT NULL,
    `group_id`   VARCHAR(64)  DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `npc_templates` (`model`, `class`, `job`, `skin`) VALUES
('mp_m_freemode_01', 'civil', 'none', NULL),
('mp_f_freemode_01', 'civil', 'none', NULL),
('s_m_m_security_01', 'guard', 'patrol', NULL),
('s_m_m_scientist_01', 'civil', 'scientist', NULL),
('g_m_y_lost_01', 'gang', 'stand', NULL),
('g_m_y_lost_02', 'gang', 'stand', NULL),
('g_m_y_lost_03', 'gang', 'stand', NULL),
('a_m_m_skater_01', 'civil', 'skater', NULL),
('a_f_m_skater_01', 'civil', 'skater', NULL);
