require 'redcloth'
require 'app/models/contribution.rb'

class ProjectController < RestrictedController
 
  before_filter :hide_column,   :only => :edit

  restrict :permission => :project_create, :only => :new
  restrict :permission => :project_edit, :on_type => 'project', 
    :only => [:set_project_desc, :set_project_need, :set_project_saving]

  around_filter :ajax_wrap, :only => [:set_project_desc, :get_project_desc, :set_project_need, :set_project_saving]

  in_place_edit_for :project, :name
  in_place_edit_for :project, :short_desc
  in_place_edit_for :need, :desc
  in_place_edit_for :saving, :desc

  def new
    @project = Project.new(params[:project])
    @project.users << @user 
    if request.post? and @project.save
      flash.now[:notice] = _("New project saved successfully, thank you for this contribution.")
      redirect_to :action => "edit", :id => @project.id
    end
  end

  def show
    edit
  end

  def edit
    begin
      @project = Project.find(params[:id])
      @project.desc = textilize(@project.desc)
    rescue ActiveRecord::RecordNotFound
      redirect_to_index(_("Invalid project id: %s, couldn't find the required project.") % params[:id])
    end
  end

  def search
    if params[:query]
      @query = params[:query]
      @total, @projects = Project.full_text_search(@query, :page => (params[:page]||1))
      @projects ||= []
      @pages = pages_for(@projects, @total, params)
    end
  end

  def take_action
    @project = Project.find(params[:id])
  end

  # Used by in-place editing to set the desc value.
  # Necessary hook for textile formatting.
  def set_project_desc
    @project = Project.find(params[:id])
    @project.update_attribute('desc', params[:value])
    render :text => textilize(@project.desc)
  end

  # Used by in-place editing to get the desc value
  # on field refresh. Necessary textile hook.
  def get_project_desc
    @project = Project.find(params[:id])
    render :layout => false, :inline => @project.desc
  end

  # Called when a need is selected or unselected for 
  # a project
  def set_project_need
    @project = Project.find(params[:id])
    if params[:state] == "1"
      # checkbox is checked, adding a new need
      @need = Need.new({:need_type=>params[:code], :local=>false, 
                       :desc=>'', :project=>@project})
      @need.save
      logger.error @need.errors.full_messages.join("\n") if @need.errors

      @contrib = CONTR_LOOKUP[@need.need_type]
      render :update do |page|
        page.insert_html :bottom, 'div_needs', :partial=>'need'
      end
    else
      # checkbox has been unchecked, removing a need
      @need = @project.needs.detect { |n| n.need_type.to_s == params[:code]}
      unless @need
        logger.error "No need with code #{params[:code]} found for project #{@project}"
      end
      @need.destroy

      render :update do |page|
        page.remove("div_need_#{params[:code]}")
      end
    end
  end

  # Called when a saving is selected or unselected for 
  # a project
  def set_project_saving
    @project = Project.find(params[:id])
    if params[:state] == "1"
      # checkbox is checked, adding a new need
      @saving = Saving.new({:saving_type=>params[:code],
                           :desc=>'', :project=>@project})
      @saving.save
      logger.error @saving.errors.full_messages.join("\n") if @saving.errors

      @res = RES_LOOKUP[@saving.saving_type]
      render :update do |page|
        page.insert_html :bottom, 'div_savings', :partial=>'saving'
      end
    else
      # checkbox has been unchecked, removing a need
      @saving = @project.savings.detect { |s| s.saving_type.to_s == params[:code]}
      unless @saving
        logger.error "No saving with code #{params[:code]} found for project #{@project}"
      end
      @saving.destroy

      render :update do |page|
        page.remove("div_saving_#{params[:code]}")
      end
    end
  end

end
