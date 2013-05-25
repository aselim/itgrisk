class NodesController < ApplicationController
  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nodes }
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @node }
    end
  end

  # GET /nodes/new
  # GET /nodes/new.json
  def new
    @node = Node.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @node }
    end
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
    
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(params[:node])

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render json: @node, status: :created, location: @node }
      else
        format.html { render action: "new" }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nodes/1
  # PUT /nodes/1.json
  def update
    if params[:node][:Attack]
	@attack = Attack.find(params[:node][:Attack]).attack
    end
    @node = Node.find(params[:id])
    @node.Team=current_user.team
    @node.Aquired=true
    @Defense = Node.find(params[:id]).Defense
    @Type = Node.find(params[:id]).Details
    @Name = Node.find(params[:id]).Node

    if 	@Defense =~ %r{AV} && @attack=='Send Virus'
	respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity } 
	end
    elsif  @Defense =~ %r{HFW} && (@attack== 'Send Worm' || @attack== 'Client Side Attacks')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif  @Defense =~ %r{HIPS} && (@attack== 'Send Worm' || @attack== 'Bruteforce')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif  @Type =='r_telnet' && (@attack== 'Send Worm' || @attack== 'Send Virus' || @attack== 'Client Side Attacks')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }        
        end
    elsif  (@Type =='smtp' || @Type =='ms_smtp') && (@attack== 'Bruteforce')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }        
        end
    elsif (Node.sum(:Power, :conditions => {:Team => current_user.team})+1) < ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif (((Node.sum(:Power, :conditions => {:Team => current_user.team})+1) - ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))) < 1) && (@attack== 'Send Virus')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif (((Node.sum(:Power, :conditions => {:Team => current_user.team})+1) - ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))) < 2) && (@attack== 'Send Worm')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif (((Node.sum(:Power, :conditions => {:Team => current_user.team})+1) - ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))) < 4) && (@attack== 'Client Side Attacks')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    elsif (((Node.sum(:Power, :conditions => {:Team => current_user.team})+1) - ((2*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%AV%", current_user.team]).count) + (4*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HFW%", current_user.team]).count) + (8*Node.find(:all, :conditions => ["Defense LIKE ? and Team = ?", "%HIPS%", current_user.team]).count))) < 16) && (@attack== 'Bruteforce')
        respond_to do |format|
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
        end
    else
     	respond_to do |format|
              if @node.update_attributes(params[:node])
                format.html { redirect_to @node, notice: 'Node was successfully attacked.' }
                format.json { head :no_content }
              else
                format.html { redirect_to @node, notice: 'Attack failed.' }
                format.json { render json: @node.errors, status: :unprocessable_entity }
              end
         end
    end
        puts @attack
	puts  current_user.team

#    respond_to do |format|
#      if @node.update_attributes(params[:node])
#        format.html { redirect_to @node, notice: 'Node was successfully attacked.' }
#        format.json { head :no_content }
#      else
#        format.html { redirect_to @node, notice: 'Attack failed.' }
#        format.json { render json: @node.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to nodes_url }
      format.json { head :no_content }
    end
  end
end
