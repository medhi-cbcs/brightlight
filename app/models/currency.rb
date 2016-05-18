class Currency < ActiveRecord::Base
  belongs_to :user

  def self.rate(foreign, base)
    self.where(foreign:foreign).where(base:base).order('updated_at DESC').take
  end

  def self.rate_to_idr(foreign)
    self.rate(foreign, 'IDR')
  end
end
