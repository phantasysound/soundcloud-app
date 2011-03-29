# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_soundcloud-social-download_session',
  :secret      => '466b4765544c222dd5d668a014db5d9cc3f32116d947aa7f2cc4eadb728cee06ecdaa289186c442304335de66acde75385fb72925524b1a5944fbb4266683b6f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
