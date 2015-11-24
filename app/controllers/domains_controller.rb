class DomainsController < ApplicationController
  #before_action :set_domain, except: [:show, :edit, :update, :destroy]

  # GET /domains
  # GET /domains.json
  def index
    @domains = Domain.all
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    @domain = Domain.find(params[:id])
  end

  # GET /domains/new
  def new
    @domain = Domain.new
    @email_name = Email.where("bridge = '0'")
      #logic to ensure that when all email_domains are classified, user is told that all is done.
      if @email_name == nil
        format.html { redirect_to ("/"), notice: 'All emails have been classied.' }
        format.json { render :show, status: :ok, location: ('/') }
      else
        @email_domain =   @email_name[0].email_domain
      end
  end

  # GET /domains/1/edit
  def edit
  end

  # POST /domains
  # POST /domains.json
  def create
    @domain = Domain.new(domain_params)
    @emails = Email.where("email_domain = ?", @domain.url)
    respond_to do |format|
      if @domain.save
        @emails.each do |dupdate|
          dupdate.bridge = @domain.sat_bridge
          dupdate.save
        end
        format.html { redirect_to new_domain_path, notice: 'Domain was successfully created.' }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def parked
    @parked = Domain.where("sat_bridge = '9'")
  end #parked

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    @emails = Email.where("email_domain = ?", @domain.url)
    respond_to do |format|
      if @domain.update(domain_params)
        @emails.each do |dupdate|
          dupdate.bridge = @domain.sat_bridge
          dupdate.save
        end
        format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to domains_url, notice: 'Domain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_domain
      @domain = Domain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      params.require(:domain).permit(:url, :sat_bridge, :cluster_id, :global_bridge)
    end
end
