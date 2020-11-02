class Payment < ApplicationRecord
  belongs_to :writer

  def create_default_hash
    return({
      :unsettled => self.unsettled,
      :confirm => self.confirm,
      :paid => self.paid
    })
  end
end
