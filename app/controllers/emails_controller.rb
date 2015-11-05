class EmailsController < ApplicationController

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
          @total_contact = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(:text => "Contact per month by bridge")
            f.xAxis(:categories =>  Email::BRIDGENAMES)
            f.series(:name => "January", :yAxis => 1, :data => @month_contacts_Jan.map)
            f.series(:name => "February", :yAxis => 1, :data => @month_contacts_Feb.map)
            f.series(:name => "March", :yAxis => 1, :data => @month_contacts_Mar.map)
            f.series(:name => "April", :yAxis => 1, :data => @month_contacts_Apr.map)
            f.series(:name => "May", :yAxis => 1, :data => @month_contacts_May.map)
            f.series(:name => "June", :yAxis => 1, :data => @month_contacts_Jun.map)
            f.series(:name => "July", :yAxis => 1, :data => @month_contacts_Jul.map)
            f.series(:name => "August", :yAxis => 1, :data => @month_contacts_Aug.map)
            f.series(:name => "September", :yAxis => 1, :data => @month_contacts_Sep.map)
            f.series(:name => "October", :yAxis => 1, :data => @month_contacts_Oct.map)
            f.series(:name => "November", :yAxis => 1, :data => @month_contacts_Nov.map)
            f.series(:name => "December", :yAxis => 1, :data => @month_contacts_Dec.map)

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

  def load
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
end
