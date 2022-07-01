class JsonWebToken
    def self.encode(payload)
        payload[:exp] = 30.days.from_now.to_i 
        JWT.encode(payload, ENV["JWT_SECRET"])
    end
  
    def self.decode(token)
        begin
            decoded = JWT.decode(token, ENV["JWT_SECRET"])[0]
            return HashWithIndifferentAccess.new decoded
        rescue
            return nil
        end
    end
end