-- PostgreSQL DDL for LOL Community Project
-- Run this script against the 'lolcommunity' database

-- ============================================
-- SEQUENCES
-- ============================================
CREATE SEQUENCE IF NOT EXISTS seq_match_item_slot START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_runepage START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS sql_free_num START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_guide_num START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_tagnum START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_guide_tagnum START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS seq_user_num START WITH 1 INCREMENT BY 1;

-- ============================================
-- RIOT TABLES
-- ============================================

-- Champion Info
CREATE TABLE IF NOT EXISTS champion_info (
    champion_info_id VARCHAR(100),
    champion_info_name VARCHAR(100),
    champion_info_key INT PRIMARY KEY
);

-- Champion Rotation
CREATE TABLE IF NOT EXISTS champion_rotation (
    champion_info_key INT,
    champion_rotation_key INT
);

-- Champion Spell
CREATE TABLE IF NOT EXISTS champion_spell (
    champion_spell_cost VARCHAR(500),
    champion_spell_cooldown VARCHAR(500),
    champion_spell_range VARCHAR(500),
    champion_spell_name VARCHAR(200),
    champion_spell_id VARCHAR(200),
    champion_spell_description TEXT,
    champion_spell_type CHAR(1),
    champion_info_key INT
);

-- Summoner Info
CREATE TABLE IF NOT EXISTS summoner_info (
    summoner_info_tier VARCHAR(50),
    summoner_info_rank VARCHAR(50),
    summoner_info_id VARCHAR(200) PRIMARY KEY,
    summoner_info_name VARCHAR(200),
    summoner_info_point INT DEFAULT 0,
    summoner_info_wins INT DEFAULT 0,
    summoner_info_losses INT DEFAULT 0,
    summoner_info_mod BIGINT DEFAULT 0,
    summoner_info_icon INT DEFAULT 0,
    summoner_info_level INT DEFAULT 0,
    summoner_info_acid VARCHAR(200)
);

-- Summoner Spell
CREATE TABLE IF NOT EXISTS summoner_spell (
    summoner_spell_name VARCHAR(200),
    summoner_spell_desc TEXT,
    summoner_spell_id VARCHAR(200),
    summoner_spell_key INT PRIMARY KEY
);

-- Rune Info
CREATE TABLE IF NOT EXISTS rune_info (
    rune_name VARCHAR(200),
    rune_key VARCHAR(200),
    rune_img_path VARCHAR(500),
    rune_id INT PRIMARY KEY,
    rune_desc TEXT
);

-- Rune Page
CREATE TABLE IF NOT EXISTS rune_page (
    pk_rune_page INT PRIMARY KEY DEFAULT nextval('seq_runepage'),
    champion_info_key INT,
    match_game_id VARCHAR(200),
    perk_sub_style INT DEFAULT 0,
    perk_primaty_style INT DEFAULT 0,
    perk0 INT DEFAULT 0,
    perk0_var1 INT DEFAULT 0,
    perk0_var2 INT DEFAULT 0,
    perk0_var3 INT DEFAULT 0,
    perk1 INT DEFAULT 0,
    perk1_var1 INT DEFAULT 0,
    perk1_var2 INT DEFAULT 0,
    perk1_var3 INT DEFAULT 0,
    perk2 INT DEFAULT 0,
    perk2_var1 INT DEFAULT 0,
    perk2_var2 INT DEFAULT 0,
    perk2_var3 INT DEFAULT 0,
    perk3 INT DEFAULT 0,
    perk3_var1 INT DEFAULT 0,
    perk3_var2 INT DEFAULT 0,
    perk3_var3 INT DEFAULT 0,
    perk4 INT DEFAULT 0,
    perk4_var1 INT DEFAULT 0,
    perk4_var2 INT DEFAULT 0,
    perk4_var3 INT DEFAULT 0,
    perk5 INT DEFAULT 0,
    perk5_var1 INT DEFAULT 0,
    perk5_var2 INT DEFAULT 0,
    perk5_var3 INT DEFAULT 0,
    statperk0 INT DEFAULT 0,
    statperk1 INT DEFAULT 0,
    statperk2 INT DEFAULT 0
);

-- Match Info
CREATE TABLE IF NOT EXISTS match_info (
    match_tier VARCHAR(50),
    match_id VARCHAR(200) PRIMARY KEY
);

-- Match Item Slot
CREATE TABLE IF NOT EXISTS match_item_slot (
    match_item_0 INT DEFAULT 0,
    match_item_1 INT DEFAULT 0,
    match_item_2 INT DEFAULT 0,
    match_item_3 INT DEFAULT 0,
    match_item_4 INT DEFAULT 0,
    match_item_5 INT DEFAULT 0,
    match_item_6 INT DEFAULT 0,
    pk_match_item_slot INT PRIMARY KEY DEFAULT nextval('seq_match_item_slot')
);

-- Match Game Info
CREATE TABLE IF NOT EXISTS match_game_info (
    match_game_id VARCHAR(200),
    match_game_team INT DEFAULT 0,
    match_game_win VARCHAR(20),
    champion_info_key INT DEFAULT 0,
    match_game_spell1 INT DEFAULT 0,
    match_game_spell2 INT DEFAULT 0,
    match_game_position VARCHAR(50),
    match_game_participant INT DEFAULT 0,
    match_game_kills INT DEFAULT 0,
    match_game_deaths INT DEFAULT 0,
    match_game_assists INT DEFAULT 0,
    pk_rune_page INT DEFAULT 0,
    pk_match_item_slot INT DEFAULT 0,
    total_damage INT DEFAULT 0,
    vision_wards_bought INT DEFAULT 0,
    wards_placed INT DEFAULT 0,
    wards_killed INT DEFAULT 0,
    match_game_cs INT DEFAULT 0,
    match_game_creation BIGINT DEFAULT 0,
    match_game_time INT DEFAULT 0,
    summoner_info_id VARCHAR(200),
    match_game_level INT DEFAULT 0
);

-- ============================================
-- COMMUNITY TABLES
-- ============================================

-- User Info
CREATE TABLE IF NOT EXISTS user_info (
    user_num INT PRIMARY KEY DEFAULT nextval('seq_user_num'),
    user_id VARCHAR(100),
    user_nick VARCHAR(100),
    user_email VARCHAR(200),
    user_pwd VARCHAR(200),
    user_join VARCHAR(20),
    user_icon VARCHAR(200),
    user_modifi VARCHAR(20),
    user_level INT DEFAULT 1,
    user_experience INT DEFAULT 0
);

-- Icon
CREATE TABLE IF NOT EXISTS icon (
    icon_path VARCHAR(500)
);

-- Free Board
CREATE TABLE IF NOT EXISTS free_board (
    user_num INT,
    free_num INT PRIMARY KEY DEFAULT nextval('sql_free_num'),
    free_title VARCHAR(500),
    free_content TEXT,
    free_filepath VARCHAR(500),
    free_filename VARCHAR(500),
    free_join VARCHAR(20),
    free_modifi VARCHAR(20),
    free_cnt INT DEFAULT 0,
    tag_cnt INT DEFAULT 0
);

-- Guide Board
CREATE TABLE IF NOT EXISTS guide_board (
    user_num INT,
    guide_num INT PRIMARY KEY DEFAULT nextval('seq_guide_num'),
    guide_title VARCHAR(500),
    guide_content TEXT,
    guide_filepath VARCHAR(500),
    guide_filename VARCHAR(500),
    guide_join VARCHAR(20),
    guide_modifi VARCHAR(20),
    guide_cnt INT DEFAULT 0,
    tag_cnt INT DEFAULT 0
);

-- Tag Table (Free Board comments)
CREATE TABLE IF NOT EXISTS tag_table (
    tag_num INT PRIMARY KEY DEFAULT nextval('seq_tagnum'),
    user_num INT,
    free_num INT,
    tag_content TEXT,
    user_nick VARCHAR(100),
    tag_join VARCHAR(30),
    ghost_pwd VARCHAR(200),
    tag_modifi VARCHAR(30)
);

-- Guide Tag Table (Guide Board comments)
CREATE TABLE IF NOT EXISTS guide_tag_table (
    guide_tag_num INT PRIMARY KEY DEFAULT nextval('seq_guide_tagnum'),
    user_num INT,
    guide_num INT,
    tag_content TEXT,
    user_nick VARCHAR(100),
    ghost_pwd VARCHAR(200),
    tag_join VARCHAR(30)
);

-- Like Table (Free Board likes)
CREATE TABLE IF NOT EXISTS like_table (
    free_num INT,
    user_num INT
);

-- Guide Like Table (Guide Board likes)
CREATE TABLE IF NOT EXISTS guide_like_table (
    guide_num INT,
    user_num INT
);

-- Free Cnt (View count tracking)
CREATE TABLE IF NOT EXISTS free_cnt (
    free_num INT,
    session_key VARCHAR(200)
);

-- Guide Cnt (View count tracking)
CREATE TABLE IF NOT EXISTS guide_cnt (
    guide_num INT,
    session_key VARCHAR(200)
);
