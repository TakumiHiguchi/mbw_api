class PlanRegister < ApplicationRecord

  scope :within_deadline, -> { where(:maxage => Time.now.to_i..Float::INFINITY) }

  def self.getUrl(email: "test@test.com", url:"http://localhost:3000/signup")
    pR = self.find_by(email: email)
    return url + "?k=" + pR.key.to_s + "&s=" + pR.session.to_s
  end
  def plan_register_check_maxage
    return self.present? && self.maxage > Time.now.to_i
  end

  def create_default_hash
    return({
      :name => self.name,
      :email => self.email,
      :maxAge => self.maxage,
      :url => Thread.current[:request].protocol + Thread.current[:request].host + "/signup?k="+self.key+"&s="+self.session
    })
  end
end
