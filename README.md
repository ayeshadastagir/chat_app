# chat_app

one to one chat app 

## Getting Started

sql for supabase 
CREATE TABLE profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email TEXT NOT NULL,
  username TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

create table chatroom(
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID REFERENCES profiles(id) on delete cascade,
  receiver_id UUID REFERENCES profiles(id) on delete cascade,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID REFERENCES profiles(id) on delete cascade,
  chatroom_id UUID REFERENCES chatroom(id) on delete cascade,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enable Realtime for the messages table
ALTER PUBLICATION supabase_realtime ADD TABLE messages;


