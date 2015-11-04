class EmailsController < ApplicationController

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
    @emails = Email.all
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
