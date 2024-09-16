class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout :layout

  def content_not_found
    render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found
  end

  private
    def layout
      if devise_controller?
        "devise"
      else
        "application"
      end

      # if current_user
      #   "dashboard"
      # end
    end
end
