# Be sure to restart your server when you modify this file.

RorMongoidSkeleton::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 30.minutes, :key => '_ror_mongoid_skeleton_session'
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RorMongoidSkeleton::Application.config.session_store :active_record_store
