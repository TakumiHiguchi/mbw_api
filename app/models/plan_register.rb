class PlanRegister < ApplicationRecord

    def self.getUrl(props)
        pR = self.find_by(email:props[:email])
        return "https://music-branchwith-web-gui.web.app/signup?k=" + pR.key.to_s + "&s=" + pR.session.to_s
    end
end
