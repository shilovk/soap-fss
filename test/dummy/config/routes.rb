Rails.application.routes.draw do
  mount Soap::Fss::Engine => "/soap-fss"
end
