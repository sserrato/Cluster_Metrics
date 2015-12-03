class Domain < ActiveRecord::Base
  require 'csv'
  belongs_to :clusters
  validates :url, presence: true, uniqueness: true

  def self.to_csv(options ={})
    CSV.generate(options) do |csv|
        csv << column_names
          all.each do |domain|
            csv << domain.attributes.values_at(*column_names)
      end
    end
  end
end
