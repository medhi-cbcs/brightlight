class Carpool < ActiveRecord::Base
  belongs_to :transport
  has_many :passengers, through: :transport
  has_many :late_passengers
  accepts_nested_attributes_for :late_passengers

  scope :since, lambda { |time| where('updated_at > ?', Time.at(time.to_r)).order(:created_at) }
  scope :private_cars, lambda { where(category:'PrivateCar') }
  scope :shuttle_cars, lambda { where(category:'Shuttle') }
  scope :active, lambda { where.not(status:'done') }
  scope :inactive, lambda { where(status:'done') }

  before_create :fill_in_details
  after_update  :sync_late_passengers

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
      self.status = 'ready'
    end

    def sync_late_passengers
      if status == 'done'
        self.late_passengers.update_all active:false
      end
    end

end
