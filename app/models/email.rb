class Email < ActiveRecord::Base
  require 'csv'
  belongs_to :cluster
  validates :email_domain, presence: true
#global variable
#hash for look up and persistence model.




  @domains = Domain.all
  DOMAINS_HASH = {}


  @domains.each do |d|
    DOMAINS_HASH[d.url] = d.sat_bridge #creates a domains hash
   end

  @total_Jan_2014 =  (Email.total_contact_month_year_cluster(1,2014,3)).map

  Email.where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
#constants
    DISTICTDOMAINSCOUNT = Email.select("email_domain").distinct.count
    DISTICTDOMAINSBRIDGE = Email.select("email_domain, bridge").distinct.order('bridge ASC')
    DISTINCTBRIDGECOUNT = Email.select("bridge").distinct.count
    DISTINCTEMAIL = Email.count
    BRIDGENAMES = ['Not Yet Classified','Capital','Company','Research','Public Sector', 'Cluster','Global Market','Education','Junk', 'Park']
    BRIDGE_NAMES_CHART = ['Capital','Company','Research','Public Sector', 'Cluster','Global Market','Education']
    BRIDGEVALUE = [0, 1, 2,3,4,5,6,7,8,9]
    MINCONTACT = 4
    MONTHNAMESMODEL = ["0","Jan","Feb","Mar", "Apr", "May", "Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    MONTHVALUESMODEL =  [1,2,3,4,5,6,7,8,9,10,11,12]

#query filters - using scopes with
#example scopes
#scope :with_skill, -> (skill){ joins(:pokemon_skills).where("pokemon_skills.name = ?", skill) }
#scope :by_month, -> (month){ where("'month' = ?", month) }

      #bridge filter removes non-essential bridges (junk, misc and non-categorized from the charting queries)
      scope :bridge_filter, lambda{ where("bridge <> '9' AND bridge <> '8' AND bridge <> '0'")}
      # groups by month, orders by month, summing email frequency.
      scope :gr_month_or_month_su_frequency, lambda{ group('month').order('month ASC').sum('email_frequency')}
      #groups and orders by bridge bridge the total frequency
      scope :gr_bridge_or_bridge_su_frequency, lambda{ group('bridge').order('bridge ASC').sum('email_frequency')}

      #averages by bridge and month
      scope :gr_bridge_or_bridge_av_frequency, lambda{ group('bridge').order('bridge ASC').average('email_frequency')}
      scope :gr_month_or_month_av_frequency, lambda{ group('month').order('month ASC').average('email_frequency')}

      scope :bridge_month, -> (bridge_value){ where("bridge = ?", bridge_value).gr_month_or_month_su_frequency}
  #  @totalCategory1byMonth = EmailAggregate.where("category = '1'").group('month').order('month ASC').sum('frequency')
      scope :email_total, -> (month_value){ where("month = '?'", month_value).bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency}

  #scopes with cluster and year
      #total contact by month, bar chart
      scope :total_contact_month_year_cluster, ->(month_value, year_value, cluster_value){ where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency}

      #Total Volume by month, bridge volume stacked chart
      scope :total_bridge_year_cluster, ->(bridge_value, year_value, cluster_value){ where("bridge = '?'", bridge_value).where("year ='?'", year_value).where("cluster_id ='?'", cluster_value).where("email_frequency >='?'", Email::MINCONTACT).group('month').order('month ASC').sum('email_frequency')}
      # stacked_bar is used in the stacked chart the above is not functional.
      scope :stacked_bar, ->(bridge_value, year_value, cluster_value){where("bridge = '?'", bridge_value).where("year = '?'", year_value).where("cluster_id = '?'", cluster_value).gr_month_or_month_su_frequency}

      #diversity calc
      scope :diversity_metric, -> (month_value, year_value, cluster_value){where("month = '?'", month_value).where("year = '?'", year_value).where("cluster_id ='?'", cluster_value).where("bridge <> '0' AND bridge <> '9' AND bridge <> '8'").select("email_domain").group("bridge").order("bridge").distinct.count}

      #Average intensity by month, barchart for each month
      scope :average_intensity_year_cluster, ->(bridge_value, month_value, year_value, cluster_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).average("email_frequency")}
      scope :sum_intensity_year_cluster, ->(bridge_value, month_value, year_value, cluster_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).where("year='?'", year_value).where("cluster_id ='?'", cluster_value).sum("email_frequency")}
      scope :average_intensity, ->(bridge_value, month_value){ where("bridge ='?'", bridge_value).where("month ='?'", month_value).average("email_frequency")}
      # groups by month and orders by month the sum of freqencies.

      def self.to_csv(options ={})
        CSV.generate(options) do |csv|
            csv << column_names
              all.each do |email|
                csv << email.attributes.values_at(*column_names)
          end
        end
      end

      #import CSV and set value
      def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
          row.to_hash
          row[:bridge] = DOMAINS_HASH.fetch((row.to_hash[:email_domain.to_s]),0)
          row[:cluster_id] = 3
          ##row[:email_domain] = (((row.to_hash)[:email_domain.to_s]) + "added")
          Email.create! row.to_hash
        end
      end

end
