class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { token: token, role: user.role }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
