class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end

  def current_user
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")

    token = header.split(" ")[1]
    decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
    User.find_by(id: decoded[0]["user_id"])
  rescue
    nil
  end

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
