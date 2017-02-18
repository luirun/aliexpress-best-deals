class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	include SessionsHelper
  include ApplicationHelper

 before_action :session_return
 before_action :prepare_meta_tags, if: "request.get?"

  def session_return
    session[:return_to] = request.fullpath
    if cookies[:user_id] == nil
      cookies[:user_id] = {:value => rand(1..99999999), :expires => 2.year.from_now}
    end
  end
  
  def prepare_meta_tags(options={})
    site_name   = "AliBestDeal"
    image       = options[:image] || "your-default-image-url"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      image:       image,
      keywords:    %w[web software development mobile app],
      twitter: {
        site_name: site_name,
        site: '@thecookieshq',
        card: 'summary',
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        image: image,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
	
end
