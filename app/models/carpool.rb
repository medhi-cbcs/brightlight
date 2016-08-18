class Carpool < ActiveRecord::Base
  belongs_to :transport
  after_create :fill_in_details

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
      end
      self.transport_name = transport.name
      self.arrival = created_at
      self.period = arrival < Time.now.noon ? 0 : 1
      self.active = true
      self.save
      puts "Filled in details "
    end

end
