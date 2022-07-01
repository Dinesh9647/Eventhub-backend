module Error
    module ErrorHandler
        def self.included(clazz)
            clazz.class_eval do
                rescue_from ActiveRecord::RecordNotFound do |e|
                    respond(:record_not_found, 404, e.message)
                end
                rescue_from StandardError do |e|
                    respond(:internal_server_error, 500, e.message)
                end
            end
        end
    
        private
            
        def respond(_error, _status, _message)
            json = Helpers::Render.json(_error, _status, _message)
            render json: json, status: _status
        end
    end
end