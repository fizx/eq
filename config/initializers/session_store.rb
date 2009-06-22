# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eq_session',
  :secret      => '8fa3051350c5002e311c68198f41a443815308b2f6d9202c7baf22d3964c8efb2272b884b50877fc428b490384921741095cf774cea8e5cc5b25d0e7b62c3587'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
