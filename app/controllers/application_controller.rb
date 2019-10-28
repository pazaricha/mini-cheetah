class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.find_by(id: params[:user_id])
  end

  def validate_current_user
    if current_user.blank?
      render json: { error: 'Please provide a user "user_id=X" query string' }, status: :not_found
    end
  end
end
