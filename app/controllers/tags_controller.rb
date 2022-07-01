class TagsController < ApplicationController
    before_action :current_user
    wrap_parameters :tag, include: [:phrase]

    def index
        @tags = Tag.all
        render json: { tags: @tags }, status: :ok
    end

    def create
        @tag = Tag.new(tag_params)
        authorize @tag
        if @tag.save
            render json: { tag: @tag }, status: :created
        else
            render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        @tag = Tag.find(params[:id])
        authorize @tag
        if @tag.update(tag_params)
            render json: { tag: @tag }, status: :created
        else
            render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @tag = Tag.find(params[:id])
        authorize @tag
        if @tag.destroy
            render json: { 
                messages: ["Tag destroyed"]
            }, status: :ok
        else
            render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
        end 
    end

    private

    def tag_params
        params.require(:tag).permit(:phrase)
    end
end
