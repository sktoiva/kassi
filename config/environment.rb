# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'casclient'
require 'casclient/frameworks/rails/filter'
#require 'casclient/frameworks/rails/cas_proxy_callback_controller'

# enable detailed CAS logging for easier troubleshooting
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => "https://cos.alpha.sizl.org:8443/cas",
    :logger => cas_logger,
    :proxy_retrieval_url => "https://cos.alpha.sizl.org/cb/cas_proxy_callback/retrieve_pgt",
    :proxy_callback_url => "https://cos.alpha.sizl.org/cb/cas_proxy_callback/receive_pgt",
    :authenticate_on_every_request => true # This is added to avoid the sitution where the pticket has expired after 2h
)

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "ruby-prof"
  config.gem "rubycas-client"
  config.gem "nntp"
  #config.gem "uuidtools" # no need anymore
  config.gem "ferret"
  config.gem "json"
  config.gem "httpclient"
  #config.gem "rest-client"
  config.gem(
    'rest-client',
    :lib     => 'restclient',
    :version => '1.4.1'
  )

  #These below are needed too, but their existence is not detected correctly so commented out.
  #config.gem "rest-client"
  #config.gem "google-geocode"
  
  
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'Helsinki'
  
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :fi

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  secret_file = File.join(RAILS_ROOT, "config/session_secret")
  if File.exist?(secret_file)
    secret = File.read(secret_file)
  else
    secret = ActiveSupport::SecureRandom.hex(64)
    File.open(secret_file, 'w') { |f| f.write(secret) }
  end
  config.action_controller.session = {
    :session_key => '_kassi_session',
    :secret      => secret
  }







  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  #environment variables
  
  BUILT_AT = Time.now # this may be kept here when other constants moved to config.yml?
  
  #COS_URL is different in production env
  
  #COS_URL = "http://maps.cs.hut.fi/cos"
  #COS_URL = "http://localhost:3001"
  COS_URL = "http://cos.alpha.sizl.org"  
  
  if COS_URL =~ /sizl.org/
    SSL_COS_URL = COS_URL.sub("http", "https")
  else
     SSL_COS_URL = COS_URL
  end
  
  COS_URL_PROXIED = COS_URL #this won't work completely in develpment mode

  RESSI_URL = "http://localhost:9000"
  RESSI_TIMEOUT = 5
  RESSI_UPLOAD_HOUR = 1
  #LOG_TO_RESSI = false

  #For example there will be no confirmation when adding profile avatar picture

  COS_TIMEOUT = 10 # Used only by active resource (session, etc.)
  BETA_VERSION = "local"
  
  PRODUCTION_SERVER = "local"

end
