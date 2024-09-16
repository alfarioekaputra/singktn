class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout :layout

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
