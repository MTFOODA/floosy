-- =============================================================================
-- SECTION 8: AI TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.ai_conversations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title varchar,
    created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user ON public.ai_conversations(user_id);

CREATE TABLE IF NOT EXISTS public.ai_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id uuid NOT NULL REFERENCES public.ai_conversations(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role public.ai_message_role NOT NULL, content text,
    tool_name varchar, tool_arguments jsonb, tool_result jsonb,
    created_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ai_messages_conversation ON public.ai_messages(conversation_id);

CREATE TABLE IF NOT EXISTS public.ai_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    conversation_id uuid REFERENCES public.ai_conversations(id) ON DELETE SET NULL,
    tool_name varchar NOT NULL, arguments jsonb DEFAULT '{}'::jsonb,
    status public.ai_action_status DEFAULT 'pending_confirmation',
    result jsonb, created_at timestamptz DEFAULT now(),
    confirmed_at timestamptz, completed_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_ai_actions_user ON public.ai_actions(user_id, status);

-- =============================================================================
-- SECTION 9: SYNC QUEUE
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.sync_queue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    entity_type varchar NOT NULL, entity_id uuid NOT NULL,
    operation public.sync_operation NOT NULL, payload jsonb DEFAULT '{}'::jsonb,
    status public.sync_status DEFAULT 'pending', retry_count integer DEFAULT 0,
    last_error text, created_at timestamptz DEFAULT now(), updated_at timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sync_queue_user ON public.sync_queue(user_id, status);
