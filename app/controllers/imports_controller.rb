# coding: utf-8
require 'open-uri'

class ImportsController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :imported_file, :rule_parameter_set, :export, :compliance_check]

  defaults :resource_class => Import

  respond_to :html, :only => [:show, :index, :destroy, :imported_file, :rule_parameter_set, :compliance_check]
  respond_to :js, :only => [:index, :compliance_check]
  belongs_to :referential

  def index
    begin
      index! do
        build_breadcrumb :index
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def show
    begin
      show! do
        build_breadcrumb :show
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def destroy
    begin
      destroy!
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def imported_file
    # WARNING : files under 10kb in size get treated as StringIO by OpenUri
    # http://stackoverflow.com/questions/10496874/why-does-openuri-treat-files-under-10kb-in-size-as-stringio
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
    begin
      send_file open(resource.file_path), { :type => "application/#{resource.filename_extension}", :disposition => "attachment", :filename => resource.filename }
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def rule_parameter_set
    begin
      @rule_parameter_set = resource.rule_parameter_set
      build_breadcrumb :rule_parameter_set
      render "rule_parameter_sets/show"
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def export
    respond_to do |format|
      format.zip { send_file ComplianceCheckExport.new(resource, @referential.id, request).export, :type => :zip }
    end
  end

  def compliance_check
    begin
      @compliance_check = resource
      build_breadcrumb :compliance_check
      render "compliance_checks/report"
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  protected
  alias_method :import, :resource

  def import_service
    ImportService.new(@referential)
  end

  def resource
    @import ||= import_service.find( params[:id] )
    return @import unless @import.report
    @line_items = @import.report.line_items
    if @line_items.size > 500
      @line_items = Kaminari.paginate_array(@line_items).page(params[:page])
    end
    @import
  end

  def collection
    @imports ||= Kaminari.paginate_array(import_service.all.sort_by{ |import|
        import.created_at
      }.reverse).page(params[:page])
  end

end
