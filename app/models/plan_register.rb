class PlanRegister < ApplicationRecord

  scope :within_deadline, -> { where(:maxage => Time.now.to_i..Float::INFINITY) }

  def self.getUrl(email: "test@test.com", url:"http://mbw-webgui.localhost/signup")
    pR = self.find_by(email: email)
    return url + "?k=" + pR.key.to_s + "&s=" + pR.session.to_s
  end
  def plan_register_check_maxage
    return self.present? && self.maxage > Time.now.to_i
  end

  def create_default_hash
    Rails.env.development? ? uri = "http://mbw-webgui.localhost" : uri = Thread.current[:request].protocol + Thread.current[:request].host
    return({
      :name => self.name,
      :email => self.email,
      :maxAge => self.maxage,
      :url => uri + "/signup?k="+self.key+"&s="+self.session
    })
  end

  def host_with_port
    "#{host}#{port_string}"
  end

end
