class Currency < ActiveRecord::Base
  belongs_to :user

  def self.exchange_rate(foreign, base)
    self.where(foreign:foreign).where(base:base).order('updated_at DESC').take.try(:rate)
  end

  def self.exchange_rate_to_idr(foreign)
    self.exchange_rate(foreign, 'IDR')
  end

  def self.dollar_rate
    self.exchange_rate_to_idr('USD')
  end
end
