class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(params[:team])

	
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
  end
end
  # PUT /teams/1
  # PUT /teams/1.json
  def update
    @team = Team.find(params[:id])
    @cu_power = Node.sum(:Power, :conditions => {:Team => current_user.team})+1
    @cu_util = ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))


    @t_power=  (Node.sum(:Power, :conditions => {:Team => params[:id]})+1) - ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", params[:id]]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", params[:id]]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", params[:id]]).count))	



        if @cu_power <= @cu_util
        respond_to do |format|
                format.html { redirect_to @team, notice: 'Attack failed.' }
                format.json { render json: @team.errors, status: :unprocessable_entity }
        end
	elsif (@cu_power-@cu_util) < @t_power
        respond_to do |format|
                format.html { redirect_to @team, notice: 'Attack failed.' }
                format.json { render json: @team.errors, status: :unprocessable_entity }
        end
	else
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully attacked.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
