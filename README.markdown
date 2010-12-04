iPizza auth strategy for OmniAuth
=================================

iPizza authentication strategy provider for [Omniauth](https://github.com/intridea/omniauth). Uses [ipizza gem](https://github.com/priithaamer/ipizza) as dependency.

Installation
------------

Add gem dependency in your `Gemfile` and install the gem:

    gem 'ipizza-omniauth-provider'

Usage
-----

Make sure you have iPizza configured properly in `config/ipizza.yml` file. See the instructions from [ipizza gem page](https://github.com/priithaamer/ipizza).

For Rails 3, in devise configuration file, e.g `config/initializers/load_devise.rb`, declare ipizza authentication strategy:

    Devise.setup do |config|
    
      # <your existing devise config>
      
      config.omniauth :ipizza,
        'Authenticate with iPizza',
        :logger => Logger.new('log/ipizza_auth.log'),
        :config => Rails.root.join('config/ipizza.yml')
    end

