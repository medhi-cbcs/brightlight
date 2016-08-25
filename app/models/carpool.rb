class Carpool < ActiveRecord::Base
  belongs_to :transport
  before_create :fill_in_details

  scope :since, lambda { |time| where('updated_at > ?', Time.at(time.to_r)).order(:created_at) }

  def passengers
    transport.passengers
  end

  private
    PRIVATE_CAR_PREFIX = "CBCS-"
    SHUTTLE_CAR_PREFIX = "SHUTTLE-"
    def fill_in_details
      if barcode && match = barcode.match(/#{PRIVATE_CAR_PREFIX}(\d{5})/)
        family_no = match[1]
        self.category = "PrivateCar"
        self.transport = Transport.where(category:category,family_no:family_no).take
      elsif barcode && match = barcode.match(/#{SHUTTLE_CAR_PREFIX}([A-Z]{,2})/)
        self.category = "Shuttle"
        self.transport = Transport.where(category:category,name:match[1]).take
      else
        return false
      end
      self.transport_name = transport.try(:name)
      self.arrival = created_at
      self.period = arrival < Time.now.noon ? 0 : 1
      self.active = true
    end

end
