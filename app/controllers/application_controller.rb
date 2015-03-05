class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :cors_set_access_control_headers

  def cors
    if request.method == 'OPTIONS'
      set_domain_header
      headers['Access-Control-Allow-Methods'] = 'GET'
      headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, X-Requested-With'
      headers['Access-Control-Max-Age']       = '1728000'
      headers['Content-Length']               = '0'
      headers['Content-Type']                 = 'text/plain'

      head(:ok)
    end
  end

  private

  def cors_set_access_control_headers
    set_domain_header
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Max-Age']       = "1728000"
  end

  def set_domain_header
    allowed_domains = ['http://prototypeof.com', 'http://localhost:8080']
    if request.referer.present?
      requesting_domain = request.referer.gsub(/\/\z/,'')
    else
      requesting_domain = 'http://localhost:5000'
    end

    if (match = allowed_domains.select{|domain| requesting_domain == domain }).present?
      headers['Access-Control-Allow-Origin']  = match
    end
  end
end
