Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '466104760084896', '43ab75b40d009c94f07e6c6fc21f53e1',
           :scope => 'email, publish_stream'
end
