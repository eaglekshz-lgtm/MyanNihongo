-- ============================================
-- MyanNihongo Multiplayer Database Schema
-- ============================================
-- Run this script in your Supabase SQL Editor
-- to create all required tables for multiplayer features
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- Table: lobbies
-- Stores multiplayer game lobbies
-- ============================================
CREATE TABLE IF NOT EXISTS public.lobbies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_code TEXT NOT NULL UNIQUE,
    creator_id TEXT NOT NULL,
    creator_name TEXT NOT NULL,
    max_players INTEGER NOT NULL DEFAULT 4,
    status TEXT NOT NULL DEFAULT 'waiting' CHECK (status IN ('waiting', 'in_progress', 'completed')),
    quiz_config JSONB NOT NULL,
    current_question_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    started_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Index for faster lookups by lobby code
CREATE INDEX IF NOT EXISTS idx_lobbies_lobby_code ON public.lobbies(lobby_code);
CREATE INDEX IF NOT EXISTS idx_lobbies_status ON public.lobbies(status);
CREATE INDEX IF NOT EXISTS idx_lobbies_created_at ON public.lobbies(created_at DESC);

-- ============================================
-- Table: lobby_players
-- Tracks players in each lobby
-- ============================================
CREATE TABLE IF NOT EXISTS public.lobby_players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_id UUID NOT NULL REFERENCES public.lobbies(id) ON DELETE CASCADE,
    player_id TEXT NOT NULL,
    player_name TEXT NOT NULL,
    avatar_url TEXT,
    is_ready BOOLEAN NOT NULL DEFAULT false,
    is_creator BOOLEAN NOT NULL DEFAULT false,
    score INTEGER NOT NULL DEFAULT 0,
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_active TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(lobby_id, player_id)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_lobby_players_lobby_id ON public.lobby_players(lobby_id);
CREATE INDEX IF NOT EXISTS idx_lobby_players_player_id ON public.lobby_players(player_id);

-- ============================================
-- Table: lobby_quiz_questions
-- Stores quiz questions for each lobby
-- ============================================
CREATE TABLE IF NOT EXISTS public.lobby_quiz_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_id UUID NOT NULL REFERENCES public.lobbies(id) ON DELETE CASCADE,
    question_index INTEGER NOT NULL,
    vocabulary_id TEXT NOT NULL,
    question_text TEXT NOT NULL,
    options TEXT[] NOT NULL,
    correct_answer_index INTEGER NOT NULL,
    explanation TEXT,
    time_limit INTEGER NOT NULL DEFAULT 30,
    revealed_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(lobby_id, question_index)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_lobby_quiz_questions_lobby_id ON public.lobby_quiz_questions(lobby_id);
CREATE INDEX IF NOT EXISTS idx_lobby_quiz_questions_lobby_question ON public.lobby_quiz_questions(lobby_id, question_index);

-- ============================================
-- Table: player_answers
-- Stores player answers to questions
-- ============================================
CREATE TABLE IF NOT EXISTS public.player_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_id UUID NOT NULL REFERENCES public.lobbies(id) ON DELETE CASCADE,
    player_id TEXT NOT NULL,
    question_index INTEGER NOT NULL,
    selected_answer_index INTEGER NOT NULL,
    is_correct BOOLEAN NOT NULL,
    answered_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    time_taken INTEGER NOT NULL,
    UNIQUE(lobby_id, player_id, question_index)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_player_answers_lobby_id ON public.player_answers(lobby_id);
CREATE INDEX IF NOT EXISTS idx_player_answers_lobby_question ON public.player_answers(lobby_id, question_index);
CREATE INDEX IF NOT EXISTS idx_player_answers_player ON public.player_answers(lobby_id, player_id);

-- ============================================
-- Table: question_results
-- Stores results for each question
-- ============================================
CREATE TABLE IF NOT EXISTS public.question_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lobby_id UUID NOT NULL REFERENCES public.lobbies(id) ON DELETE CASCADE,
    question_index INTEGER NOT NULL,
    correct_answer_index INTEGER NOT NULL,
    revealed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(lobby_id, question_index)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_question_results_lobby_id ON public.question_results(lobby_id);
CREATE INDEX IF NOT EXISTS idx_question_results_lobby_question ON public.question_results(lobby_id, question_index);

-- ============================================
-- Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE public.lobbies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lobby_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lobby_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_results ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS Policies - Allow all operations for now
-- (In production, you should implement proper auth-based policies)
-- ============================================

-- Lobbies policies
CREATE POLICY "Allow all operations on lobbies" ON public.lobbies
    FOR ALL USING (true) WITH CHECK (true);

-- Lobby players policies
CREATE POLICY "Allow all operations on lobby_players" ON public.lobby_players
    FOR ALL USING (true) WITH CHECK (true);

-- Lobby quiz questions policies
CREATE POLICY "Allow all operations on lobby_quiz_questions" ON public.lobby_quiz_questions
    FOR ALL USING (true) WITH CHECK (true);

-- Player answers policies
CREATE POLICY "Allow all operations on player_answers" ON public.player_answers
    FOR ALL USING (true) WITH CHECK (true);

-- Question results policies
CREATE POLICY "Allow all operations on question_results" ON public.question_results
    FOR ALL USING (true) WITH CHECK (true);

-- ============================================
-- Function: Update updated_at timestamp
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_lobbies_updated_at
    BEFORE UPDATE ON public.lobbies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Function: Clean up old lobbies
-- ============================================
CREATE OR REPLACE FUNCTION cleanup_old_lobbies()
RETURNS void AS $$
BEGIN
    -- Delete lobbies older than 24 hours that are completed or waiting
    DELETE FROM public.lobbies
    WHERE created_at < NOW() - INTERVAL '24 hours'
    AND status IN ('completed', 'waiting');
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Verification Queries
-- ============================================
-- Run these to verify tables were created successfully:

-- Check all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('lobbies', 'lobby_players', 'lobby_quiz_questions', 'player_answers', 'question_results');

-- Check indexes
SELECT tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
AND tablename IN ('lobbies', 'lobby_players', 'lobby_quiz_questions', 'player_answers', 'question_results');

-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('lobbies', 'lobby_players', 'lobby_quiz_questions', 'player_answers', 'question_results');

-- ============================================
-- Sample Data (Optional - for testing)
-- ============================================
-- Uncomment to insert sample data:

/*
-- Insert a test lobby
INSERT INTO public.lobbies (lobby_code, creator_id, creator_name, max_players, status, quiz_config)
VALUES (
    'TEST01',
    'test_user_1',
    'Test User',
    4,
    'waiting',
    '{"level": "N5", "numberOfQuestions": 10, "timeLimit": 30}'::jsonb
);

-- Get the lobby ID
DO $$
DECLARE
    test_lobby_id UUID;
BEGIN
    SELECT id INTO test_lobby_id FROM public.lobbies WHERE lobby_code = 'TEST01';
    
    -- Insert a test player
    INSERT INTO public.lobby_players (lobby_id, player_id, player_name, is_creator, is_ready)
    VALUES (test_lobby_id, 'test_user_1', 'Test User', true, false);
END $$;
*/

-- ============================================
-- Success Message
-- ============================================
DO $$
BEGIN
    RAISE NOTICE 'Database schema created successfully!';
    RAISE NOTICE 'Tables: lobbies, lobby_players, lobby_quiz_questions, player_answers, question_results';
    RAISE NOTICE 'RLS enabled on all tables';
    RAISE NOTICE 'Indexes created for optimal performance';
    RAISE NOTICE '';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Verify tables were created (run verification queries above)';
    RAISE NOTICE '2. Configure your .env file with Supabase credentials';
    RAISE NOTICE '3. Restart your Flutter app';
    RAISE NOTICE '4. Test creating and joining lobbies';
END $$;
