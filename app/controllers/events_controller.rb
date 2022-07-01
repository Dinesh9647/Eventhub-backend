class EventsController < ApplicationController
    before_action :current_user
    wrap_parameters :event, include: [:title, :description, :reg_start, :reg_end, :fees, :venue, :category, :image]

    def index
        current = DateTime.current()
        sub_category = params.has_key?(:sub_category) ? params[:sub_category] : "Upcoming"
        @events = Event.all.order(reg_end: :asc)
        if params.has_key?(:category)
            @events = @events.where(category: params[:category])
        end
        if sub_category == "Archived"
            @events = @events.where("reg_end < ?", current)
        else
            @events = @events.where("reg_end >= ?", current)
        end
        if params.has_key?(:tags)
            @events = @events.joins(:event_tags).distinct.where("event_tags.tag_id IN (?)", params[:tags])
        end

        # Pagination
        page = params.has_key?(:page) ? params[:page].to_i : 1
        perPage = params.has_key?(:perPage) ? params[:perPage].to_i : 20
        totalCount = @events.length()
        totalPages = (totalCount.to_f / perPage).ceil()
        page = [page, totalPages].min
        skip = (page - 1) * perPage
        @events = @events.limit(perPage).offset(skip)
        eventsWithTags = Array.new
        @events.each do |event|
            eventsWithTags.push({ event: event, tags: event.tags })
        end

        render json: { 
            events: eventsWithTags,
            page: page,
            perPage: perPage,
            totalCount: totalCount,
            totalPages: totalPages,
            hasPrev: page > 1,
            hasNext:  page < totalPages
        }, status: :ok
    end

    def create
        @event = Event.new(event_params)
        authorize @event
        if @event.save
            @event.url = url_for(@event.image)
            if @event.save
                render json: { event: @event }, status: :created
            else
                render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @event = Event.find(params[:id])
        puts @event.tags
        render json: { event: @event, tags: @event.tags }, status: :ok
    end

    def update
        @event = Event.find(params[:id])
        authorize @event
        if params[:image].present?
            @event.image.purge
            @event.image.attach(params[:image])
            @event.url = url_for(@event.image)
        end
        if @event.update(event_params.except(:image))
            render json: { event: @event }, status: :ok
        else 
            render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @event = Event.find(params[:id])
        authorize @event
        if @event.destroy
            render json: { 
                messages: ["Event destroyed"]
            }, status: :ok
        else
            render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def tags
        @event = Event.find(params[:id])
        authorize @event
        tags = params[:tags]
        tags.each do |id|
            tag = Tag.find(id)
            @event.event_tags.create(tag: tag)
        end
        render json: { event: @event, tags: @event.tags }, status: :ok
    end

    def participants
        @event = Event.find(params[:id])
        authorize @event
        render json: { registrations: @event.users }, status: :ok
    end

    private

    def event_params
        params.require(:event).permit(:title, :description, :reg_start, :reg_end, :fees, :venue, :category, :image)
    end
end
