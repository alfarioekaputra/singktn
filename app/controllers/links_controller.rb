class LinksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_link, only: %i[ show edit update destroy ]

    # GET /links
    def index
        @links = Link.where(user_id: current_user.id)
        # @data = []

        # links.each_with_index do |link, indexLink|
        #     @data << {'id': link.id, 'title': link.title, 'url': link.url, 'click': link.click, 'thumbnail': url_for(link.thumbnail.variant(resize_to_fit: [64, 64], monochrome: false, quality: 100))}
        # end
    end

    # GET /links/1 or /links/1.json
    def show
    end

    # GET /links/1/edit
    def edit
        thumbnail = url_for(@link.thumbnail.variant(resize_to_fit: [64, 64], monochrome: false, quality: 100)) if @link.thumbnail.attached?
        
        @link.as_json(only: [:id, :title, :url]).merge({:thumbnail_path => thumbnail})
        
    end

    # POST /links or /links.json
    def create
        begin
            @link = Link.new(link_params)
            @link.user_id = current_user.id
            @link.short_url = generate_short_url
            @link.thumbnail.attach(link_params[:thumbnail]) if @link.thumbnail.attached?
            
            if (params[:url].include? "http://") || (params[:url].include? "https://")
                @link.url = params[:url]
            else
                @link.url = 'https://' + params[:url]
            end
        rescue ActiveRecord::RecordNotUnique
            retry
        end
        
        if @link.save
        redirect_to links_path, notice: 'Links was successfully created.'
        else
        redirect_to new_link_path, errors: link.errors
        end
    end

    # PATCH/PUT /links/1 or /links/1.json
    def update
        if link_params[:thumbnail].present?
            @link.thumbnail.purge
            @link.thumbnail.attach(link_params[:thumbnail])
        end
        

        if @link.update(link_params)      
            # attach_thumbnail(@link) if link_params[:thumbnail].present?
            redirect_to links_path, notice: 'Link was successfully update.'
        else
            redirect_to edit_link_path(@link), error: @link.errors
        end
    end

    # DELETE /links/1 or /links/1.json
    def destroy
        file = ActiveStorage::Attachment.find_by(record_id: params[:id])
        file.purge
        @link.destroy
        respond_to do |format|
        format.html { redirect_to links_url, notice: "Link was successfully destroyed." }
        format.json { head :no_content }
        end
        
    end

    private
        def attach_thumbnail(link)
            link.thumbnail.attach(link_params[:thumbnail])
        end
        # Use callbacks to share common setup or constraints between actions.
        def set_link
            @link = Link.find_by(id: params[:id], user_id: current_user.id)

            if !@link
                redirect_to links_path
            end
        end

        # Only allow a list of trusted parameters through.
        def link_params
            params.permit(:title, :url, :thumbnail)
        end

        def generate_short_url(length = 6)
            characters = [*'a'..'z', *'A'..'Z', *'0'..'9']
            (0...length).map { characters.sample }.join
        end
end
