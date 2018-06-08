class ApplicationController < ActionController::Base
  # devise settings on the bottom of the file
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  before_action :session_return
  before_action :prepare_meta_tags, if: -> { request.get? }

  # REVIEW: It's probably not working
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render json: {error: exception.message}.to_json, status: 404
  end

  def session_return
    session[:return_to] = request.fullpath
    cookies[:user_id] = {value: rand(1..999_999_999), expires: 2.years.from_now} if cookies[:user_id].nil?
  end

  def prepare_meta_tags(options={})
    site_name   = "AliBestDeal"
    # image       = options[:image] || "your-default-image-url"
    current_url = request.url
    defaults = {
      site: site_name,
      # image: image,
      keywords: %w[aliexpress shopping china sale quality],
      twitter: {
        site_name: site_name,
        site: "@alibestdeal",
        card: "summary",
        # image: image
        },
      og: {
        url: current_url,
        site_name: site_name,
        # image: image,
        type: "website"
      }
    }
    options.reverse_merge!(defaults)
    set_meta_tags options
  end

  # devise settings
  helper_method :resource_name, :resource, :devise_mapping, :resource_class, :current_user
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :enable_rack_mini_profiler_for_admin

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :name, :surname, :description])
  end

  def enable_rack_mini_profiler_for_admin     
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

end
