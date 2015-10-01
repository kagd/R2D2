class ApiController < ApplicationController
  after_filter :cors_set_access_control_headers

  def cors
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
      headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, X-Requested-With'
      headers['Access-Control-Max-Age'] = '1728000'
      headers['Content-Length'] = '0'
      headers['Content-Type'] = 'text/plain'
      render nothing: true, status: 200
    end
  end

  private #-------------------------------------

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end
end
