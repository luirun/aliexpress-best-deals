class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	include SessionsHelper


 before_action :prepare_meta_tags, if: "request.get?"

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
