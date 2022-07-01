module Error::Helpers
    class Render
        def self.json(_error, _status, _message)
            {
                status: _status,
                errors: [_error],
                message: _message
            }.as_json
        end
    end
end