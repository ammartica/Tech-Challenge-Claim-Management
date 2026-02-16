class AuthController < ApplicationController
  def login
    #look up user in db
    user = User.find_by(email: params[:email])

    #hash password provided, compare to password_digest
    #true if user correct false if incorrect
    if user&.authenticate(params[:password])
      #if valid credentials, generate jwt token
      token = encode_token({ user_id: user.id })
      #send to frontend token and role
      render json: { token: token, role: user.role }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
