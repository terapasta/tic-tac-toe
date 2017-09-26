# Rails.application.config.middleware.insert_before 0, 'Rack::Cors' do
#   allow do
#     origins '*'
#
#     options = {
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#     }
#
#     resource '/embed/*', options
#     resource '/api/public_bots/*', options
#   end
# end
