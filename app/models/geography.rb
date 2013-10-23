module Geography
  extend ActiveSupport::Concern
  STATES =  ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
             'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
             'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
             'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
             'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
             'AS', 'DC', 'FM', 'GU', 'MH', 'MP', 'PW', 'PR', 'VI', 'AA',
             'AE', 'AP']
  PROVINCES = ['AB', 'BC', 'MB', 'NB', 'NL', 'NS', 'NT', 'NU', 'ON',
               'PE', 'QC', 'SK', 'YT']

  def self.included(base)
    base.validates :country, presence: true
    base.validates :city, presence: true
    base.validates :region, presence: true
    base.validates :region, inclusion: { in: Geography::STATES, if: :in_us? }
    base.validates :region, inclusion: { in: Geography::PROVINCES, if: :in_canada? } 
    base.validates :postal_code, :postal_code => true
  end

  def in_us?
    country == 'United States'
  end

  def in_canada?
    country == 'Canada'
  end

  def correct_postal_code
    if in_us? && !(/^\d{5}(-\d{4})?$/.match(postal_code))
      errors.add(:postal_code, "Postal code must be five numbers")
    elsif in_canada? && !(/^\D{1}\d{1}\D{1}(\s|-)?\d{1}\D{1}\d{1}$/.match(postal_code))
      errors.add(:postal_code, "Postal code must be in this format 'A0A 0A0'")
    end
  end
end
