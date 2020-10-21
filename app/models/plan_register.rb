class PlanRegister < ApplicationRecord

    def self.getUrl(email: "test@test.com", url:"http://localhost:3000/signup")
        pR = self.find_by(email: email)
        return url + "?k=" + pR.key.to_s + "&s=" + pR.session.to_s
    end
end
