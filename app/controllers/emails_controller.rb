class EmailsController < ApplicationController
  before_action :admin_only, except: [:index, :classify, :upload, :import]
  helper_method :analytics, :year_helper

  def year_helper
    @year_helper = 2000
  end

  def year_set
    @year_set || params[:year]
  end

  def analytics
      year_set = params(:year) ||  3314
      redirect_to emails_metrics_path, notice: "reset year"
  end #end def analytics

  def volume
    @test_volume = Email.total_bridge_year_cluster(2,2014,3)
    @email = Email.where("bridge = '1' AND cluster_id = '3' AND year = '2014'").sum("email_frequency")
    #volume requires Bridge_ID, Year, Cluster ID
    @bridge1_2014_volume = (Email.total_bridge_year_cluster(1,2014,3)).map
    @bridge2_2014_volume = (Email.total_bridge_year_cluster(2,2014,3)).map
    @bridge3_2014_volume = (Email.total_bridge_year_cluster(3,2014,3)).map
    @bridge4_2014_volume = (Email.total_bridge_year_cluster(4,2014,3)).map
    @bridge5_2014_volume = (Email.total_bridge_year_cluster(5,2014,3)).map
    @bridge6_2014_volume = (Email.total_bridge_year_cluster(6,2014,3)).map
    @bridge7_2014_volume = (Email.total_bridge_year_cluster(7,2014,3)).map


    @email2 = Email.stacked_bar(3, 2014, 3)
    @volume2014 = LazyHighCharts::HighChart.new('graph') do |f|
    f.title(:text => "Total Volume of Communication across Bridges")
    f.xAxis(:categories => Email::MONTHNAMESMODEL)
    f.series(:name => "Capital", :yAxis => 0, :data => @bridge1_2014_volume)
    f.series(:name => "Company", :yAxis => 0, :data => @bridge2_2014_volume)
    f.series(:name => "Research", :yAxis => 0, :data => @bridge3_2014_volume)
    f.series(:name => "Public Sector", :yAxis => 0, :data => @bridge4_2014_volume)
    f.series(:name => "Cluster", :yAxis => 0, :data => @bridge5_2014_volume)
    f.series(:name => "Global Market", :yAxis => 0, :data => @bridge6_2014_volume)
    f.series(:name => "Education", :yAxis => 0, :data => @totalCategory7byMonth)

    f.yAxis [
      {:title => {:text => "", :margin => 0} },
      {:title => {:text => "Contacts per month"}, :opposite => true},
    ]

    f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    f.chart({:defaultSeriesType=>"column"})
    f.plot_options({:column=>{:stacking=>"normal"}})
  end

  end # end def volume

  def intensity
    # year = 2014
    #2014 - Jan
    @b1_m1_y14_c3 = (Email.average_intensity_year_cluster(1,1,2014,3)).to_i
    @b2_m1_y14_c3 = (Email.average_intensity_year_cluster(2,1,2014,3)).to_i
    @b3_m1_y14_c3 = (Email.average_intensity_year_cluster(3,1,2014,3)).to_i
    @b4_m1_y14_c3 = (Email.average_intensity_year_cluster(4,1,2014,3)).to_i
    @b5_m1_y14_c3 = (Email.average_intensity_year_cluster(5,1,2014,3)).to_i
    @b6_m1_y14_c3 = (Email.average_intensity_year_cluster(6,1,2014,3)).to_i
    @b7_m1_y14_c3 = (Email.average_intensity_year_cluster(7,1,2014,3)).to_i
    #2014 - Feb
    @b1_m2_y14_c3 = (Email.average_intensity_year_cluster(1,2,2014,3)).to_i
    @b2_m2_y14_c3 = (Email.average_intensity_year_cluster(2,2,2014,3)).to_i
    @b3_m2_y14_c3 = (Email.average_intensity_year_cluster(3,2,2014,3)).to_i
    @b4_m2_y14_c3 = (Email.average_intensity_year_cluster(4,2,2014,3)).to_i
    @b5_m2_y14_c3 = (Email.average_intensity_year_cluster(5,2,2014,3)).to_i
    @b6_m2_y14_c3 = (Email.average_intensity_year_cluster(6,2,2014,3)).to_i
    @b7_m2_y14_c3 = (Email.average_intensity_year_cluster(7,2,2014,3)).to_i
    #2014 - March
    @b1_m3_y14_c3 = (Email.average_intensity_year_cluster(1,3,2014,3)).to_i
    @b2_m3_y14_c3 = (Email.average_intensity_year_cluster(2,3,2014,3)).to_i
    @b3_m3_y14_c3 = (Email.average_intensity_year_cluster(3,3,2014,3)).to_i
    @b4_m3_y14_c3 = (Email.average_intensity_year_cluster(4,3,2014,3)).to_i
    @b5_m3_y14_c3 = (Email.average_intensity_year_cluster(5,3,2014,3)).to_i
    @b6_m3_y14_c3 = (Email.average_intensity_year_cluster(6,3,2014,3)).to_i
    @b7_m3_y14_c3 = (Email.average_intensity_year_cluster(7,3,2014,3)).to_i
    #2014- April
    @b1_m4_y14_c3 = (Email.average_intensity_year_cluster(1,4,2014,3)).to_i
    @b2_m4_y14_c3 = (Email.average_intensity_year_cluster(2,4,2014,3)).to_i
    @b3_m4_y14_c3 = (Email.average_intensity_year_cluster(3,4,2014,3)).to_i
    @b4_m4_y14_c3 = (Email.average_intensity_year_cluster(4,4,2014,3)).to_i
    @b5_m4_y14_c3 = (Email.average_intensity_year_cluster(5,4,2014,3)).to_i
    @b6_m4_y14_c3 = (Email.average_intensity_year_cluster(6,4,2014,3)).to_i
    @b7_m4_y14_c3 = (Email.average_intensity_year_cluster(7,4,2014,3)).to_i
    #2014- May
    @b1_m5_y14_c3 = (Email.average_intensity_year_cluster(1,5,2014,3)).to_i
    @b2_m5_y14_c3 = (Email.average_intensity_year_cluster(2,5,2014,3)).to_i
    @b3_m5_y14_c3 = (Email.average_intensity_year_cluster(3,5,2014,3)).to_i
    @b4_m5_y14_c3 = (Email.average_intensity_year_cluster(4,5,2014,3)).to_i
    @b5_m5_y14_c3 = (Email.average_intensity_year_cluster(5,5,2014,3)).to_i
    @b6_m5_y14_c3 = (Email.average_intensity_year_cluster(6,5,2014,3)).to_i
    @b7_m5_y14_c3 = (Email.average_intensity_year_cluster(7,5,2014,3)).to_i
    #2014- June
    @b1_m6_y14_c3 = (Email.average_intensity_year_cluster(1,6,2014,3)).to_i
    @b2_m6_y14_c3 = (Email.average_intensity_year_cluster(2,6,2014,3)).to_i
    @b3_m6_y14_c3 = (Email.average_intensity_year_cluster(3,6,2014,3)).to_i
    @b4_m6_y14_c3 = (Email.average_intensity_year_cluster(4,6,2014,3)).to_i
    @b5_m6_y14_c3 = (Email.average_intensity_year_cluster(5,6,2014,3)).to_i
    @b6_m6_y14_c3 = (Email.average_intensity_year_cluster(6,6,2014,3)).to_i
    @b7_m6_y14_c3 = (Email.average_intensity_year_cluster(7,6,2014,3)).to_i
    #2014- July
    @b1_m7_y14_c3 = (Email.average_intensity_year_cluster(1,7,2014,3)).to_i
    @b2_m7_y14_c3 = (Email.average_intensity_year_cluster(2,7,2014,3)).to_i
    @b3_m7_y14_c3 = (Email.average_intensity_year_cluster(3,7,2014,3)).to_i
    @b4_m7_y14_c3 = (Email.average_intensity_year_cluster(4,7,2014,3)).to_i
    @b5_m7_y14_c3 = (Email.average_intensity_year_cluster(5,7,2014,3)).to_i
    @b6_m7_y14_c3 = (Email.average_intensity_year_cluster(6,7,2014,3)).to_i
    @b7_m7_y14_c3 = (Email.average_intensity_year_cluster(7,7,2014,3)).to_i
    #2014- August
    @b1_m8_y14_c3 = (Email.average_intensity_year_cluster(1,8,2014,3)).to_i
    @b2_m8_y14_c3 = (Email.average_intensity_year_cluster(2,8,2014,3)).to_i
    @b3_m8_y14_c3 = (Email.average_intensity_year_cluster(3,8,2014,3)).to_i
    @b4_m8_y14_c3 = (Email.average_intensity_year_cluster(4,8,2014,3)).to_i
    @b5_m8_y14_c3 = (Email.average_intensity_year_cluster(5,8,2014,3)).to_i
    @b6_m8_y14_c3 = (Email.average_intensity_year_cluster(6,8,2014,3)).to_i
    @b7_m8_y14_c3 = (Email.average_intensity_year_cluster(7,8,2014,3)).to_i
    #2014- September
    @b1_m9_y14_c3 = (Email.average_intensity_year_cluster(1,9,2014,3)).to_i
    @b2_m9_y14_c3 = (Email.average_intensity_year_cluster(2,9,2014,3)).to_i
    @b3_m9_y14_c3 = (Email.average_intensity_year_cluster(3,9,2014,3)).to_i
    @b4_m9_y14_c3 = (Email.average_intensity_year_cluster(4,9,2014,3)).to_i
    @b5_m9_y14_c3 = (Email.average_intensity_year_cluster(5,9,2014,3)).to_i
    @b6_m9_y14_c3 = (Email.average_intensity_year_cluster(6,9,2014,3)).to_i
    @b7_m9_y14_c3 = (Email.average_intensity_year_cluster(7,9,2014,3)).to_i
    #2014- October
    @b1_m10_y14_c3 = (Email.average_intensity_year_cluster(1,10,2014,3)).to_i
    @b2_m10_y14_c3 = (Email.average_intensity_year_cluster(2,10,2014,3)).to_i
    @b3_m10_y14_c3 = (Email.average_intensity_year_cluster(3,10,2014,3)).to_i
    @b4_m10_y14_c3 = (Email.average_intensity_year_cluster(4,10,2014,3)).to_i
    @b5_m10_y14_c3 = (Email.average_intensity_year_cluster(5,10,2014,3)).to_i
    @b6_m10_y14_c3 = (Email.average_intensity_year_cluster(6,10,2014,3)).to_i
    @b7_m10_y14_c3 = (Email.average_intensity_year_cluster(7,10,2014,3)).to_i
    #2014- November
    @b1_m11_y14_c3 = (Email.average_intensity_year_cluster(1,11,2014,3)).to_i
    @b2_m11_y14_c3 = (Email.average_intensity_year_cluster(2,11,2014,3)).to_i
    @b3_m11_y14_c3 = (Email.average_intensity_year_cluster(3,11,2014,3)).to_i
    @b4_m11_y14_c3 = (Email.average_intensity_year_cluster(4,11,2014,3)).to_i
    @b5_m11_y14_c3 = (Email.average_intensity_year_cluster(5,11,2014,3)).to_i
    @b6_m11_y14_c3 = (Email.average_intensity_year_cluster(6,11,2014,3)).to_i
    @b7_m11_y14_c3 = (Email.average_intensity_year_cluster(7,11,2014,3)).to_i
    #2014- December
    @b1_m12_y14_c3 = (Email.average_intensity_year_cluster(1,12,2014,3)).to_i
    @b2_m12_y14_c3 = (Email.average_intensity_year_cluster(2,12,2014,3)).to_i
    @b3_m12_y14_c3 = (Email.average_intensity_year_cluster(3,12,2014,3)).to_i
    @b4_m12_y14_c3 = (Email.average_intensity_year_cluster(4,12,2014,3)).to_i
    @b5_m12_y14_c3 = (Email.average_intensity_year_cluster(5,12,2014,3)).to_i
    @b6_m12_y14_c3 = (Email.average_intensity_year_cluster(6,12,2014,3)).to_i
    @b7_m12_y14_c3 = (Email.average_intensity_year_cluster(7,12,2014,3)).to_i

    #chart for intensity
    @averageIntensityChart2014 = LazyHighCharts::HighChart.new('graph') do |f|
    f.title(:text => "2014: Average intensity of communication per bridge")
    f.xAxis(:categories =>  ["Capital", "Company", "Research", "Public Sector", "Cluster", "Global Market", "Education"])
    f.series(:name => "January", :yAxis => 1, :data => [@b1_m1_y14_c3, @b2_m1_y14_c3, @b3_m1_y14_c3, @b4_m1_y14_c3, @b5_m1_y14_c3, @b6_m1_y14_c3, @b7_m1_y14_c3])
    f.series(:name => "February", :yAxis => 1, :data => [@b1_m2_y14_c3, @b2_m2_y14_c3, @b3_m2_y14_c3, @b4_m2_y14_c3, @b5_m2_y14_c3, @b6_m2_y14_c3, @b7_m2_y14_c3])
    f.series(:name => "March", :yAxis => 1, :data => [@b1_m3_y14_c3, @b2_m3_y14_c3, @b3_m3_y14_c3, @b4_m3_y14_c3, @b5_m3_y14_c3, @b6_m3_y14_c3, @b7_m3_y14_c3])
    f.series(:name => "April", :yAxis => 1, :data =>[@b1_m4_y14_c3, @b2_m4_y14_c3, @b3_m4_y14_c3, @b4_m4_y14_c3, @b5_m4_y14_c3, @b6_m4_y14_c3, @b7_m4_y14_c3])
    f.series(:name => "May", :yAxis => 1, :data => [@b1_m5_y14_c3, @b2_m5_y14_c3, @b3_m5_y14_c3, @b4_m5_y14_c3, @b5_m5_y14_c3, @b6_m5_y14_c3, @b7_m5_y14_c3])
    f.series(:name => "June", :yAxis => 1, :data => [@b1_m6_y14_c3, @b2_m6_y14_c3, @b3_m6_y14_c3, @b4_m6_y14_c3, @b5_m6_y14_c3, @b6_m6_y14_c3, @b7_m6_y14_c3])
    f.series(:name => "July", :yAxis => 1, :data => [@b1_m7_y14_c3, @b2_m7_y14_c3, @b3_m7_y14_c3, @b4_m7_y14_c3, @b5_m7_y14_c3, @b6_m7_y14_c3, @b7_m7_y14_c3])
    f.series(:name => "August", :yAxis => 1, :data => [@b1_m8_y14_c3, @b2_m8_y14_c3, @b3_m8_y14_c3, @b4_m8_y14_c3, @b5_m8_y14_c3, @b6_m8_y14_c3, @b7_m8_y14_c3])
    f.series(:name => "September", :yAxis => 1, :data => [@b1_m9_y14_c3, @b2_m9_y14_c3, @b3_m9_y14_c3, @b4_m9_y14_c3, @b5_m9_y14_c3, @b6_m9_y14_c3, @b7_m9_y14_c3])
    f.series(:name => "October", :yAxis => 1, :data => [@b1_m10_y14_c3, @b2_m10_y14_c3, @b3_m10_y14_c3, @b4_m10_y14_c3, @b5_m10_y14_c3, @b6_m10_y14_c3, @b7_m10_y14_c3])
    f.series(:name => "November", :yAxis => 1, :data => [@b1_m11_y14_c3, @b2_m11_y14_c3, @b3_m11_y14_c3, @b4_m11_y14_c3, @b5_m11_y14_c3, @b6_m11_y14_c3, @b7_m11_y14_c3])
    f.series(:name => "December", :yAxis => 1, :data => [@b1_m12_y14_c3, @b2_m12_y14_c3, @b3_m12_y14_c3, @b4_m12_y14_c3, @b5_m12_y14_c3, @b6_m12_y14_c3, @b7_m12_y14_c3])

    f.yAxis [
      {:title => {:text => "", :margin => 0} },
      {:title => {:text => "Average Contact per Bridge"}, :opposite => true},
    ]
    #f.options[:tooltip][:formatter] = "function(){ return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %'; }"

    f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    f.chart({:defaultSeriesType=>"column"})
  end
  end #end def intensity

  def intensity2013
    # year=  2013
    #2013 - Jan
    @b1_m1_y13_c3 = (Email.average_intensity_year_cluster(1,1,2013,3)).to_i
    @b2_m1_y13_c3 = (Email.average_intensity_year_cluster(2,1,2013,3)).to_i
    @b3_m1_y13_c3 = (Email.average_intensity_year_cluster(3,1,2013,3)).to_i
    @b4_m1_y13_c3 = (Email.average_intensity_year_cluster(4,1,2013,3)).to_i
    @b5_m1_y13_c3 = (Email.average_intensity_year_cluster(5,1,2013,3)).to_i
    @b6_m1_y13_c3 = (Email.average_intensity_year_cluster(6,1,2013,3)).to_i
    @b7_m1_y13_c3 = (Email.average_intensity_year_cluster(7,1,2013,3)).to_i
    #2013 - Feb
    @b1_m2_y13_c3 = (Email.average_intensity_year_cluster(1,2,2013,3)).to_i
    @b2_m2_y13_c3 = (Email.average_intensity_year_cluster(2,2,2013,3)).to_i
    @b3_m2_y13_c3 = (Email.average_intensity_year_cluster(3,2,2013,3)).to_i
    @b4_m2_y13_c3 = (Email.average_intensity_year_cluster(4,2,2013,3)).to_i
    @b5_m2_y13_c3 = (Email.average_intensity_year_cluster(5,2,2013,3)).to_i
    @b6_m2_y13_c3 = (Email.average_intensity_year_cluster(6,2,2013,3)).to_i
    @b7_m2_y13_c3 = (Email.average_intensity_year_cluster(7,2,2013,3)).to_i
    #2013 - March
    @b1_m3_y13_c3 = (Email.average_intensity_year_cluster(1,3,2013,3)).to_i
    @b2_m3_y13_c3 = (Email.average_intensity_year_cluster(2,3,2013,3)).to_i
    @b3_m3_y13_c3 = (Email.average_intensity_year_cluster(3,3,2013,3)).to_i
    @b4_m3_y13_c3 = (Email.average_intensity_year_cluster(4,3,2013,3)).to_i
    @b5_m3_y13_c3 = (Email.average_intensity_year_cluster(5,3,2013,3)).to_i
    @b6_m3_y13_c3 = (Email.average_intensity_year_cluster(6,3,2013,3)).to_i
    @b7_m3_y13_c3 = (Email.average_intensity_year_cluster(7,3,2013,3)).to_i
    #2013- April
    @b1_m4_y13_c3 = (Email.average_intensity_year_cluster(1,4,2013,3)).to_i
    @b2_m4_y13_c3 = (Email.average_intensity_year_cluster(2,4,2013,3)).to_i
    @b3_m4_y13_c3 = (Email.average_intensity_year_cluster(3,4,2013,3)).to_i
    @b4_m4_y13_c3 = (Email.average_intensity_year_cluster(4,4,2013,3)).to_i
    @b5_m4_y13_c3 = (Email.average_intensity_year_cluster(5,4,2013,3)).to_i
    @b6_m4_y13_c3 = (Email.average_intensity_year_cluster(6,4,2013,3)).to_i
    @b7_m4_y13_c3 = (Email.average_intensity_year_cluster(7,4,2013,3)).to_i
    #2013- May
    @b1_m5_y13_c3 = (Email.average_intensity_year_cluster(1,5,2013,3)).to_i
    @b2_m5_y13_c3 = (Email.average_intensity_year_cluster(2,5,2013,3)).to_i
    @b3_m5_y13_c3 = (Email.average_intensity_year_cluster(3,5,2013,3)).to_i
    @b4_m5_y13_c3 = (Email.average_intensity_year_cluster(4,5,2013,3)).to_i
    @b5_m5_y13_c3 = (Email.average_intensity_year_cluster(5,5,2013,3)).to_i
    @b6_m5_y13_c3 = (Email.average_intensity_year_cluster(6,5,2013,3)).to_i
    @b7_m5_y13_c3 = (Email.average_intensity_year_cluster(7,5,2013,3)).to_i
    #2013- June
    @b1_m6_y13_c3 = (Email.average_intensity_year_cluster(1,6,2013,3)).to_i
    @b2_m6_y13_c3 = (Email.average_intensity_year_cluster(2,6,2013,3)).to_i
    @b3_m6_y13_c3 = (Email.average_intensity_year_cluster(3,6,2013,3)).to_i
    @b4_m6_y13_c3 = (Email.average_intensity_year_cluster(4,6,2013,3)).to_i
    @b5_m6_y13_c3 = (Email.average_intensity_year_cluster(5,6,2013,3)).to_i
    @b6_m6_y13_c3 = (Email.average_intensity_year_cluster(6,6,2013,3)).to_i
    @b7_m6_y13_c3 = (Email.average_intensity_year_cluster(7,6,2013,3)).to_i
    #2013- July
    @b1_m7_y13_c3 = (Email.average_intensity_year_cluster(1,7,2013,3)).to_i
    @b2_m7_y13_c3 = (Email.average_intensity_year_cluster(2,7,2013,3)).to_i
    @b3_m7_y13_c3 = (Email.average_intensity_year_cluster(3,7,2013,3)).to_i
    @b4_m7_y13_c3 = (Email.average_intensity_year_cluster(4,7,2013,3)).to_i
    @b5_m7_y13_c3 = (Email.average_intensity_year_cluster(5,7,2013,3)).to_i
    @b6_m7_y13_c3 = (Email.average_intensity_year_cluster(6,7,2013,3)).to_i
    @b7_m7_y13_c3 = (Email.average_intensity_year_cluster(7,7,2013,3)).to_i
    #2013- August
    @b1_m8_y13_c3 = (Email.average_intensity_year_cluster(1,8,2013,3)).to_i
    @b2_m8_y13_c3 = (Email.average_intensity_year_cluster(2,8,2013,3)).to_i
    @b3_m8_y13_c3 = (Email.average_intensity_year_cluster(3,8,2013,3)).to_i
    @b4_m8_y13_c3 = (Email.average_intensity_year_cluster(4,8,2013,3)).to_i
    @b5_m8_y13_c3 = (Email.average_intensity_year_cluster(5,8,2013,3)).to_i
    @b6_m8_y13_c3 = (Email.average_intensity_year_cluster(6,8,2013,3)).to_i
    @b7_m8_y13_c3 = (Email.average_intensity_year_cluster(7,8,2013,3)).to_i
    #2013- September
    @b1_m9_y13_c3 = (Email.average_intensity_year_cluster(1,9,2013,3)).to_i
    @b2_m9_y13_c3 = (Email.average_intensity_year_cluster(2,9,2013,3)).to_i
    @b3_m9_y13_c3 = (Email.average_intensity_year_cluster(3,9,2013,3)).to_i
    @b4_m9_y13_c3 = (Email.average_intensity_year_cluster(4,9,2013,3)).to_i
    @b5_m9_y13_c3 = (Email.average_intensity_year_cluster(5,9,2013,3)).to_i
    @b6_m9_y13_c3 = (Email.average_intensity_year_cluster(6,9,2013,3)).to_i
    @b7_m9_y13_c3 = (Email.average_intensity_year_cluster(7,9,2013,3)).to_i
    #2013- October
    @b1_m10_y13_c3 = (Email.average_intensity_year_cluster(1,10,2013,3)).to_i
    @b2_m10_y13_c3 = (Email.average_intensity_year_cluster(2,10,2013,3)).to_i
    @b3_m10_y13_c3 = (Email.average_intensity_year_cluster(3,10,2013,3)).to_i
    @b4_m10_y13_c3 = (Email.average_intensity_year_cluster(4,10,2013,3)).to_i
    @b5_m10_y13_c3 = (Email.average_intensity_year_cluster(5,10,2013,3)).to_i
    @b6_m10_y13_c3 = (Email.average_intensity_year_cluster(6,10,2013,3)).to_i
    @b7_m10_y13_c3 = (Email.average_intensity_year_cluster(7,10,2013,3)).to_i
    #2013- November
    @b1_m11_y13_c3 = (Email.average_intensity_year_cluster(1,11,2013,3)).to_i
    @b2_m11_y13_c3 = (Email.average_intensity_year_cluster(2,11,2013,3)).to_i
    @b3_m11_y13_c3 = (Email.average_intensity_year_cluster(3,11,2013,3)).to_i
    @b4_m11_y13_c3 = (Email.average_intensity_year_cluster(4,11,2013,3)).to_i
    @b5_m11_y13_c3 = (Email.average_intensity_year_cluster(5,11,2013,3)).to_i
    @b6_m11_y13_c3 = (Email.average_intensity_year_cluster(6,11,2013,3)).to_i
    @b7_m11_y13_c3 = (Email.average_intensity_year_cluster(7,11,2013,3)).to_i
    #2013- December
    @b1_m12_y13_c3 = (Email.average_intensity_year_cluster(1,12,2013,3)).to_i
    @b2_m12_y13_c3 = (Email.average_intensity_year_cluster(2,12,2013,3)).to_i
    @b3_m12_y13_c3 = (Email.average_intensity_year_cluster(3,12,2013,3)).to_i
    @b4_m12_y13_c3 = (Email.average_intensity_year_cluster(4,12,2013,3)).to_i
    @b5_m12_y13_c3 = (Email.average_intensity_year_cluster(5,12,2013,3)).to_i
    @b6_m12_y13_c3 = (Email.average_intensity_year_cluster(6,12,2013,3)).to_i
    @b7_m12_y13_c3 = (Email.average_intensity_year_cluster(7,12,2013,3)).to_i

    #chart for intensity
    @averageIntensityChart2013 = LazyHighCharts::HighChart.new('graph') do |f|
    f.title(:text => "2014: Average intensity of communication per bridge")
    f.xAxis(:categories =>  ["Capital", "Company", "Research", "Public Sector", "Cluster", "Global Market", "Education"])
    f.series(:name => "January", :yAxis => 1, :data => [@b1_m1_y13_c3, @b2_m1_y13_c3, @b3_m1_y13_c3, @b4_m1_y13_c3, @b5_m1_y13_c3, @b6_m1_y13_c3, @b7_m1_y13_c3])
    f.series(:name => "February", :yAxis => 1, :data => [@b1_m2_y13_c3, @b2_m2_y13_c3, @b3_m2_y13_c3, @b4_m2_y13_c3, @b5_m2_y13_c3, @b6_m2_y13_c3, @b7_m2_y13_c3])
    f.series(:name => "March", :yAxis => 1, :data => [@b1_m3_y13_c3, @b2_m3_y13_c3, @b3_m3_y13_c3, @b4_m3_y13_c3, @b5_m3_y13_c3, @b6_m3_y13_c3, @b7_m3_y13_c3])
    f.series(:name => "April", :yAxis => 1, :data =>[@b1_m4_y13_c3, @b2_m4_y13_c3, @b3_m4_y13_c3, @b4_m4_y13_c3, @b5_m4_y13_c3, @b6_m4_y13_c3, @b7_m4_y13_c3])
    f.series(:name => "May", :yAxis => 1, :data => [@b1_m5_y13_c3, @b2_m5_y13_c3, @b3_m5_y13_c3, @b4_m5_y13_c3, @b5_m5_y13_c3, @b6_m5_y13_c3, @b7_m5_y13_c3])
    f.series(:name => "June", :yAxis => 1, :data => [@b1_m6_y13_c3, @b2_m6_y13_c3, @b3_m6_y13_c3, @b4_m6_y13_c3, @b5_m6_y13_c3, @b6_m6_y13_c3, @b7_m6_y13_c3])
    f.series(:name => "July", :yAxis => 1, :data => [@b1_m7_y13_c3, @b2_m7_y13_c3, @b3_m7_y13_c3, @b4_m7_y13_c3, @b5_m7_y13_c3, @b6_m7_y13_c3, @b7_m7_y13_c3])
    f.series(:name => "August", :yAxis => 1, :data => [@b1_m8_y13_c3, @b2_m8_y13_c3, @b3_m8_y13_c3, @b4_m8_y13_c3, @b5_m8_y13_c3, @b6_m8_y13_c3, @b7_m8_y13_c3])
    f.series(:name => "September", :yAxis => 1, :data => [@b1_m9_y13_c3, @b2_m9_y13_c3, @b3_m9_y13_c3, @b4_m9_y13_c3, @b5_m9_y13_c3, @b6_m9_y13_c3, @b7_m9_y13_c3])
    f.series(:name => "October", :yAxis => 1, :data => [@b1_m10_y13_c3, @b2_m10_y13_c3, @b3_m10_y13_c3, @b4_m10_y13_c3, @b5_m10_y13_c3, @b6_m10_y13_c3, @b7_m10_y13_c3])
    f.series(:name => "November", :yAxis => 1, :data => [@b1_m11_y13_c3, @b2_m11_y13_c3, @b3_m11_y13_c3, @b4_m11_y13_c3, @b5_m11_y13_c3, @b6_m11_y13_c3, @b7_m11_y13_c3])
    f.series(:name => "December", :yAxis => 1, :data => [@b1_m12_y13_c3, @b2_m12_y13_c3, @b3_m12_y13_c3, @b4_m12_y13_c3, @b5_m12_y13_c3, @b6_m12_y13_c3, @b7_m12_y13_c3])

    f.yAxis [
      {:title => {:text => "", :margin => 0} },
      {:title => {:text => "Average Contact per Bridge"}, :opposite => true},
    ]
    #f.options[:tooltip][:formatter] = "function(){ return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %'; }"

    f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
    f.chart({:defaultSeriesType=>"column"})
  end
end #end def intensity 2013

  def metrics
    #bridge, month for average intensity
    @year = 2014 || params[:year]
    @cluster = 3
    @testb1m1year_cluster = (Email.average_intensity_year_cluster(1,1,@year, @cluster)).to_i
    #jan
    @b1_m1 = (Email.average_intensity(1,1)).to_i
    @b2_m1 = (Email.average_intensity(2,1)).to_i
    @b3_m1 = (Email.average_intensity(3,1)).to_i
    @b4_m1 = (Email.average_intensity(4,1)).to_i
    @b5_m1 = (Email.average_intensity(5,1)).to_i
    @b6_m1 = (Email.average_intensity(6,1)).to_i
    @b7_m1 = (Email.average_intensity(7,1)).to_i
    #feb
    @b1_m2 = (Email.average_intensity(1,2)).to_i
    @b2_m2 = (Email.average_intensity(2,2)).to_i
    @b3_m2 = (Email.average_intensity(3,2)).to_i
    @b4_m2 = (Email.average_intensity(4,2)).to_i
    @b5_m2 = (Email.average_intensity(5,2)).to_i
    @b6_m2 = (Email.average_intensity(6,2)).to_i
    @b7_m2 = (Email.average_intensity(7,2)).to_i
    #month
    @b1_m3 = (Email.average_intensity(1,3)).to_i
    @b2_m3 = (Email.average_intensity(2,3)).to_i
    @b3_m3 = (Email.average_intensity(3,3)).to_i
    @b4_m3 = (Email.average_intensity(4,3)).to_i
    @b5_m3 = (Email.average_intensity(5,3)).to_i
    @b6_m3 = (Email.average_intensity(6,3)).to_i
    @b7_m3 = (Email.average_intensity(7,3)).to_i
    #April
    @b1_m4 = (Email.average_intensity(1,4)).to_i
    @b2_m4 = (Email.average_intensity(2,4)).to_i
    @b3_m4 = (Email.average_intensity(3,4)).to_i
    @b4_m4 = (Email.average_intensity(4,4)).to_i
    @b5_m4 = (Email.average_intensity(5,4)).to_i
    @b6_m4 = (Email.average_intensity(6,4)).to_i
    @b7_m4 = (Email.average_intensity(7,4)).to_i
    #May
    @b1_m5 = (Email.average_intensity(1,5)).to_i
    @b2_m5 = (Email.average_intensity(2,5)).to_i
    @b3_m5 = (Email.average_intensity(3,5)).to_i
    @b4_m5 = (Email.average_intensity(4,5)).to_i
    @b5_m5 = (Email.average_intensity(5,5)).to_i
    @b6_m5 = (Email.average_intensity(6,5)).to_i
    @b7_m5 = (Email.average_intensity(7,5)).to_i
    #month
    @b1_m6 = (Email.average_intensity(1,4)).to_i
    @b2_m6 = (Email.average_intensity(2,4)).to_i
    @b3_m6 = (Email.average_intensity(3,4)).to_i
    @b4_m6 = (Email.average_intensity(4,4)).to_i
    @b5_m6 = (Email.average_intensity(5,4)).to_i
    @b6_m6 = (Email.average_intensity(6,4)).to_i
    @b7_m6 = (Email.average_intensity(7,4)).to_i
    #month
    @b1_m4 = (Email.average_intensity(1,4)).to_i
    @b2_m4 = (Email.average_intensity(2,4)).to_i
    @b3_m4 = (Email.average_intensity(3,4)).to_i
    @b4_m4 = (Email.average_intensity(4,4)).to_i
    @b5_m4 = (Email.average_intensity(5,4)).to_i
    @b6_m4 = (Email.average_intensity(6,4)).to_i
    @b7_m4 = (Email.average_intensity(7,4)).to_i
    #month
    @b1_m4 = (Email.average_intensity(1,4)).to_i
    @b2_m4 = (Email.average_intensity(2,4)).to_i
    @b3_m4 = (Email.average_intensity(3,4)).to_i
    @b4_m4 = (Email.average_intensity(4,4)).to_i
    @b5_m4 = (Email.average_intensity(5,4)).to_i
    @b6_m4 = (Email.average_intensity(6,4)).to_i
    @b7_m4 = (Email.average_intensity(7,4)).to_i
    #month
    @b1_m4 = (Email.average_intensity(1,4)).to_i
    @b2_m4 = (Email.average_intensity(2,4)).to_i
    @b3_m4 = (Email.average_intensity(3,4)).to_i
    @b4_m4 = (Email.average_intensity(4,4)).to_i
    @b5_m4 = (Email.average_intensity(5,4)).to_i
    @b6_m4 = (Email.average_intensity(6,4)).to_i
    @b7_m4 = (Email.average_intensity(7,4)).to_i
    #month
    @b1_m4 = (Email.average_intensity(1,4)).to_i
    @b2_m4 = (Email.average_intensity(2,4)).to_i
    @b3_m4 = (Email.average_intensity(3,4)).to_i
    @b4_m4 = (Email.average_intensity(4,4)).to_i
    @b5_m4 = (Email.average_intensity(5,4)).to_i
    @b6_m4 = (Email.average_intensity(6,4)).to_i
    @b7_m4 = (Email.average_intensity(7,4)).to_i

    @test_average = Email.average_intensity(1,1)
    #average
    @average_January = Email.where("month = '1'").group("bridge").average("email_frequency")
    #a year of bridge contacts
    @bridge_1_long = Email.where("bridge = '1'").group('month').order('month ASC').sum('email_frequency')
    @bridge_1 = Email.bridge_month(1)
    @bridge_2 = Email.bridge_month(2)
    @bridge_3 = Email.bridge_month(3)
    @bridge_4 = Email.bridge_month(4)
    @bridge_5 = Email.bridge_month(5)
    @bridge_4 = Email.bridge_month(4)
    @bridge_5 = Email.bridge_month(5)
    @bridge_6 = Email.bridge_month(6)
    @bridge_7 = Email.bridge_month(7)


    # using a scope defined in Model to get all contacts within a month by bridge
    @month_contacts_January = Email.email_total(1)
    @month_contacts_February = Email.email_total(2)
    @month_contacts_March = Email.email_total(3)
    @month_contacts_April = Email.email_total(4)
    @month_contacts_May = Email.email_total(5)
    @month_contacts_June = Email.email_total(6)
    @month_contacts_July = Email.email_total(7)
    @month_contacts_August = Email.email_total(8)
    @month_contacts_September = Email.email_total(9)
    @month_contacts_October = Email.email_total(10)
    @month_contacts_November = Email.email_total(11)
    @month_contacts_December = Email.email_total(12)

    @month_contacts_Jan = Email.where("month = '1'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Feb = Email.where("month = '2'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Mar = Email.where("month = '3'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Apr = Email.where("month = '4'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_May = Email.where("month = '5'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Jun = Email.where("month = '6'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Jul = Email.where("month = '7'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Aug = Email.where("month = '8'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Sep = Email.where("month = '9'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Oct = Email.where("month = '10'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Nov = Email.where("month = '11'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
    @month_contacts_Dec = Email.where("month = '12'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency

  end

  def annual_report
    @test_2014 = Email.where("year = '2014'").count

    @report_2014 = Email.where("year = '2014'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency

    #chart for monthly contacts grouped by bridge
        @annual_contact = LazyHighCharts::HighChart.new('graph') do |f|
          f.title(:text => "Contact per year by bridge")
          f.xAxis(:categories =>  Email::BRIDGENAMES)

          f.series(:name => "2014", :yAxis => 1, :data => @report_2014.map)




          f.yAxis [
            {:title => {:text => "", :margin => 0} },
            {:title => {:text => ""}, :opposite => true},
          ]

          f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
          f.chart({:defaultSeriesType=>"column"})
        end
    #end below ends annual_report
  end

  def total
      @total_Jan_2014 =  (Email.total_contact_month_year_cluster(1,2014,3)).map
      @total_Feb_2014 =  (Email.total_contact_month_year_cluster(2,2014,3)).map
      @total_Mar_2014 =  (Email.total_contact_month_year_cluster(3,2014,3)).map
      @total_Apr_2014 =  (Email.total_contact_month_year_cluster(4,2014,3)).map
      @total_May_2014 =  (Email.total_contact_month_year_cluster(5,2014,3)).map
      @total_Jun_2014 =  (Email.total_contact_month_year_cluster(6,2014,3)).map
      @total_Jul_2014 =  (Email.total_contact_month_year_cluster(7,2014,3)).map
      @total_Aug_2014 =  (Email.total_contact_month_year_cluster(8,2014,3)).map
      @total_Sep_2014 =  (Email.total_contact_month_year_cluster(9,2014,3)).map
      @total_Oct_2014 =  (Email.total_contact_month_year_cluster(10,2014,3)).map
      @total_Nov_2014 =  (Email.total_contact_month_year_cluster(11,2014,3)).map
      @total_Dec_2014 =  (Email.total_contact_month_year_cluster(12,2014,3)).map

      @month_contacts_Jan = Email.where("month = '1'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Feb = Email.where("month = '2'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Mar = Email.where("month = '3'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Apr = Email.where("month = '4'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_May = Email.where("month = '5'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Jun = Email.where("month = '6'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Jul = Email.where("month = '7'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Aug = Email.where("month = '8'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Sep = Email.where("month = '9'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Oct = Email.where("month = '10'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Nov = Email.where("month = '11'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency
      @month_contacts_Dec = Email.where("month = '12'").bridge_filter.where("email_frequency >=?", Email::MINCONTACT).gr_bridge_or_bridge_su_frequency

      #chart for monthly contacts grouped by bridge
          @total_contact2014 = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(:text => "2014: Contact per month by bridge")
            f.xAxis(:categories =>  Email::BRIDGENAMES)
            f.series(:name => "January", :yAxis => 1, :data =>  @total_Jan_2014)
            f.series(:name => "February", :yAxis => 1, :data => @total_Feb_2014)
            f.series(:name => "March", :yAxis => 1, :data => @total_Mar_2014)
            f.series(:name => "April", :yAxis => 1, :data => @total_Apr_2014)
            f.series(:name => "May", :yAxis => 1, :data => @total_May_2014)
            f.series(:name => "June", :yAxis => 1, :data => @total_Jun_2014)
            f.series(:name => "July", :yAxis => 1, :data => @total_Jul_2014)
            f.series(:name => "August", :yAxis => 1, :data => @total_Aug_2014)
            f.series(:name => "September", :yAxis => 1, :data => @total_Sep_2014)
            f.series(:name => "October", :yAxis => 1, :data => @total_Oct_2014)
            f.series(:name => "November", :yAxis => 1, :data => @total_Nov_2014)
            f.series(:name => "December", :yAxis => 1, :data => @total_Dec_2014)

            f.yAxis [
              {:title => {:text => "", :margin => 0} },
              {:title => {:text => ""}, :opposite => true},
            ]

            f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
            f.chart({:defaultSeriesType=>"column"})
          end

  #below ends the def total
  end


  def upload
  end

  def import
  Email.import(params[:file])
  redirect_to emails_classify_path, notice: "Emails imported."
  end

  def classify
    @emails_bridge0 = Email.where("bridge = '0' AND email_frequency >='4'").order("id DESC")
    respond_to do |format|
      format.html
      format.csv {send_data @emails_bridge0.to_csv}
      format.xls {send_data @emails_bridge0.to_csv(col_sep: "\t")}
      format.json {send_data @emails_bridge0.to_json}
    end
  end

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all.order("id DESC")
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = Email.find(params[:id])
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
    @email = Email.find(params[:id])
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)
    respond_to do |format|
      if @email.save
        format.html { redirect_to ('/'), notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: ('/') }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    @email = Email.find(params[:id])
    respond_to do |format|
      if @email.update(email_params)
        @redirect_next_edit = Email.where("bridge = '0'").first
        #logic to ensure that when all email_domains are classified, user is told that all is done.
        if @redirect_next_edit == nil
          format.html { redirect_to ("/"), notice: 'All emails have been classified.' }
          format.json { render :show, status: :ok, location: ('/') }
        else
        format.html { redirect_to edit_email_path(@redirect_next_edit), notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: ('/') }
        end
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = Email.find(params[:id])
    @email.destroy
    respond_to do |format|
      format.html { redirect_to ('/'), notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:email_domain, :bridge, :bridge_global, :email_frequency, :month, :year, :cluster_id)
    end

    def query_params
      params.require(:query).permit(:year_analysis)
    end
end
