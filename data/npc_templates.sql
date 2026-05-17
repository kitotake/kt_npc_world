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

-- ================================================================
-- Uniquement mp_m_freemode_01 & mp_f_freemode_01
-- Le skin est géré entièrement par SkinSystem (combinaisons aléatoires)
-- skin = NULL partout : SkinSystem.BuildSkin() choisit tout seul
-- ================================================================

-- CIVILS
INSERT INTO `npc_templates` (`model`, `class`, `job`, `skin`) VALUES
('mp_m_freemode_01', 'civil', 'none',   NULL),
('mp_m_freemode_01', 'civil', 'none',   NULL),
('mp_m_freemode_01', 'civil', 'none',   NULL),
('mp_m_freemode_01', 'civil', 'stand',  NULL),
('mp_m_freemode_01', 'civil', 'patrol', NULL),
('mp_f_freemode_01', 'civil', 'none',   NULL),
('mp_f_freemode_01', 'civil', 'none',   NULL),
('mp_f_freemode_01', 'civil', 'none',   NULL),
('mp_f_freemode_01', 'civil', 'stand',  NULL),
('mp_f_freemode_01', 'civil', 'patrol', NULL),

-- GARDES
('mp_m_freemode_01', 'guard', 'patrol', NULL),
('mp_m_freemode_01', 'guard', 'stand',  NULL),
('mp_m_freemode_01', 'guard', 'drive',  NULL),
('mp_f_freemode_01', 'guard', 'patrol', NULL),
('mp_f_freemode_01', 'guard', 'stand',  NULL),

-- GANGS
('mp_m_freemode_01', 'gang', 'stand',  NULL),
('mp_m_freemode_01', 'gang', 'stand',  NULL),
('mp_m_freemode_01', 'gang', 'patrol', NULL),
('mp_f_freemode_01', 'gang', 'stand',  NULL),
('mp_f_freemode_01', 'gang', 'patrol', NULL),

-- DEALERS
('mp_m_freemode_01', 'dealer', 'stand', NULL),
('mp_f_freemode_01', 'dealer', 'stand', NULL),

-- MEDICS
('mp_m_freemode_01', 'medic', 'stand',  NULL),
('mp_f_freemode_01', 'medic', 'stand',  NULL),
('mp_m_freemode_01', 'medic', 'patrol', NULL);
