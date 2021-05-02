class ApplicationController < ActionController::API
    def method_not_found
        render json: nil, status: 405
    end
end
