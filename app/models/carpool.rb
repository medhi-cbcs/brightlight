class Carpool < ActiveRecord::Base
  belongs_to :transport
  has_many :passengers, through: :transport
  has_many :late_passengers
  accepts_nested_attributes_for :late_passengers

  scope :since, lambda { |time| 
    where('carpools.updated_at > ?', Time.at(time.to_r))
    .order('carpools.created_at')
  }
  scope :private_cars, lambda { where(category:'PrivateCar') }
  scope :shuttle_cars, lambda { where(category:'Shuttle') }
  scope :active, lambda { where.not(status:'done') }
  scope :inactive, lambda { where(status:'done') }
  scope :today_am, lambda { where('created_at > ? and created_at < ?', Date.today.beginning_of_day, Date.today.noon) }
  scope :today_pm, lambda { where('created_at > ?', Date.today.noon) }
  scope :today, lambda { where('created_at > ?', Date.today.beginning_of_day) }

  before_create :fill_in_details
  after_update  :sync_late_passengers

  private

    def fill_in_details
      if barcode.present?
        transport = SmartCard.find_by_code(barcode).try(:transport)
      elsif transport_name.present?
        transport = Transport.find_by_name transport_name.upcase
      end 
      unless transport.present?
        return false
      end
      self.transport_id = transport.id
      self.transport_name = transport.name
      self.arrival = created_at
      self.period = arrival < Time.now.noon ? 0 : 1
      self.active = true
      self.status = 'ready'
      self.category = transport.category      
    end

    def sync_late_passengers
      if status == 'done'
        self.late_passengers.update_all active:false
      end
    end

end
